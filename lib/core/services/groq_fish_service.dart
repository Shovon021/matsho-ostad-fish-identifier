import 'dart:convert';
import 'dart:typed_data';
import 'package:cross_file/cross_file.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/fish_identification_result.dart';
import 'fish_validation_service.dart';

/// Service for fish identification using Groq Vision API (Llama 3.2 Vision)
class GroqFishService {
  static const String _baseUrl = 'https://api.groq.com/openai/v1/chat/completions';
  
  // Groq API Key - Get free from https://console.groq.com
  static String get _apiKey => dotenv.env['GROQ_API_KEY'] ?? '';

  // Max retry attempts
  static const int _maxRetries = 3;

  /// Compress and resize image to reduce API payload
  Future<String> _compressImage(Uint8List imageBytes) async {
    try {
      // Decode image
      final image = img.decodeImage(imageBytes);
      if (image == null) {
        return base64Encode(imageBytes);
      }

      // Resize if too large (max 1024px on longest side)
      img.Image resized;
      if (image.width > 1024 || image.height > 1024) {
        if (image.width > image.height) {
          resized = img.copyResize(image, width: 1024);
        } else {
          resized = img.copyResize(image, height: 1024);
        }
      } else {
        resized = image;
      }

      // Encode as JPEG with 80% quality
      final compressed = img.encodeJpg(resized, quality: 80);
      return base64Encode(compressed);
    } catch (e) {
      // If compression fails, use original
      return base64Encode(imageBytes);
    }
  }

  /// Analyze a fish image and return identification results
  Future<FishIdentificationResult> identifyFish(XFile imageFile) async {
    if (_apiKey == 'YOUR_GROQ_API_KEY' || _apiKey.isEmpty) {
      return FishIdentificationResult.error(
          'Groq API key not configured');
    }

    try {
      final imageBytes = await imageFile.readAsBytes();
      final base64Image = await _compressImage(imageBytes);

      const prompt = '''
You are an expert ichthyologist specializing in Bangladeshi freshwater and marine fish.

IMPORTANT CONFUSION PAIRS (Pay close attention to distinguish these):
- রুই (Rohu) vs তেলাপিয়া (Tilapia): Rohu has SILVER-GREY body, NO red fins. Tilapia has RED/PINK tail fin, slightly humped back.
- কাতলা (Katla) vs বিগহেড কার্প (Bighead Carp): Katla has larger head, upturned mouth. Bighead has downturned mouth, spotted body.
- ইলিশ (Hilsa) vs চান্দা/Silver Carp: Hilsa has distinctive golden sheen, forked tail. Carp is more silver, rounded.
- পাঙ্গাস (Pangasius) vs বোয়াল (Boal): Pangasius is catfish with smooth skin. Boal has wider head, predatory look.
- মৃগেল (Mrigal) vs রুই (Rohu): Mrigal has more elongated body, smaller head. Rohu is deeper-bodied.

Analyze this fish image carefully. Look at:
1. BODY SHAPE: Is it deep-bodied, elongated, flat?
2. FIN COLORS: Any red, orange, yellow coloration?
3. SCALE PATTERN: Large, small, or absent?
4. HEAD SHAPE: Pointed, rounded, upturned mouth?
5. TAIL FIN: Forked, rounded, colored?

Respond ONLY in this exact JSON format:

{
  "identified": true,
  "reasoning": "I identified this as X because [specific visual evidence from the image]. It is NOT Y because [key differences observed].",
  "local_name_bangla": "Name in Bangla",
  "local_name_english": "Common English Name",
  "scientific_name": "Scientific name",
  "confidence": 0.85,
  "confidence_reasoning": "High/Medium/Low because [image quality, visible features, etc.]",
  "habitat": "Freshwater/Saltwater/Both",
  "key_visual_markers": {
    "body_shape": "description",
    "fin_colors": "description",
    "scale_pattern": "description",
    "distinctive_features": ["feature1", "feature2"]
  },
  "identification_markers": [
    "Feature 1 observed in image",
    "Feature 2 observed in image",
    "Feature 3 observed in image"
  ],
  "similar_fish": {
    "name": "Most commonly confused species",
    "why_not_this": "Specific visual differences from the image"
  },
  "description": "Brief description of the species",
  "nutrition": {
    "calories": "approx calories per 100g",
    "protein": "approx protein per 100g"
  },
  "market_price": "Approx price range in BDT per kg",
  "cooking_method": "Recommended cooking style",
  "freshness_checklist": [
    "Fresh sign 1",
    "Fresh sign 2"
  ],
  "recipes": [
    "Popular dish 1",
    "Popular dish 2"
  ]
}

CRITICAL RULES:
1. If you see a RED or PINK tail fin, it is likely TILAPIA, not Rohu.
2. Always provide specific evidence from the image in "reasoning".
3. If unsure between two species, lower confidence to 0.6 or below.
4. If this is NOT a fish, set "identified": false with "error": "Not a fish".

Respond with ONLY the JSON object.
''';

      final requestBody = {
        'model': 'meta-llama/llama-4-scout-17b-16e-instruct',
        'messages': [
          {
            'role': 'user',
            'content': [
              {'type': 'text', 'text': prompt},
              {
                'type': 'image_url',
                'image_url': {
                  'url': 'data:image/jpeg;base64,$base64Image'
                }
              }
            ]
          }
        ],
        'temperature': 0.1,
        'max_tokens': 2048,
      };

      // Retry logic with exponential backoff
      http.Response? response;
      String lastError = '';

      for (int attempt = 0; attempt < _maxRetries; attempt++) {
        try {
          response = await http.post(
            Uri.parse(_baseUrl),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $_apiKey',
            },
            body: json.encode(requestBody),
          ).timeout(
            const Duration(seconds: 60),
          );

          // Success or non-retryable error
          if (response.statusCode == 200 || 
              response.statusCode == 400 || 
              response.statusCode == 401) {
            break;
          }

          // Retryable error (503, 429, 500)
          lastError = 'Error ${response.statusCode}';
          if (attempt < _maxRetries - 1) {
            await Future.delayed(Duration(seconds: (attempt + 1) * 2));
          }
        } catch (e) {
          lastError = e.toString();
          if (attempt < _maxRetries - 1) {
            await Future.delayed(Duration(seconds: (attempt + 1) * 2));
          }
        }
      }

      if (response == null) {
        return FishIdentificationResult.error('Connection failed: $lastError');
      }

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body) as Map<String, dynamic>;
        final choices = responseData['choices'] as List?;

        if (choices == null || choices.isEmpty) {
          return FishIdentificationResult.error('No response from AI');
        }

        final content = choices[0]['message']['content'] as String;

        // Extract JSON from response
        final jsonMatch = RegExp(r'\{[\s\S]*\}').firstMatch(content);
        if (jsonMatch == null) {
          return FishIdentificationResult.error('Could not parse AI response');
        }

        final jsonData = json.decode(jsonMatch.group(0)!) as Map<String, dynamic>;

        if (jsonData['identified'] == false) {
          return FishIdentificationResult.error(
              jsonData['error'] ?? 'Fish not identified');
        }

        final result = FishIdentificationResult(
          isIdentified: true,
          localNameBangla: jsonData['local_name_bangla'] ?? '',
          localNameEnglish: jsonData['local_name_english'] ?? '',
          scientificName: jsonData['scientific_name'] ?? '',
          confidence: (jsonData['confidence'] as num?)?.toDouble() ?? 0.0,
          habitat: jsonData['habitat'] ?? '',
          identificationMarkers:
              List<String>.from(jsonData['identification_markers'] ?? []),
          similarFishName: jsonData['similar_fish']?['name'],
          whyNotSimilar: jsonData['similar_fish']?['why_not_this'],
          description: jsonData['description'] ?? '',
          calories: jsonData['nutrition']?['calories'] ?? 'N/A',
          protein: jsonData['nutrition']?['protein'] ?? 'N/A',
          marketPrice: jsonData['market_price'] ?? 'N/A',
          cookingMethod: jsonData['cooking_method'] ?? 'N/A',
          freshnessChecklist: List<String>.from(jsonData['freshness_checklist'] ?? []),
          recipes: List<String>.from(jsonData['recipes'] ?? []),
        );
        
        // === LOCAL VALIDATION ===
        final validation = FishValidationService.validateResult(result);
        
        // If validation found issues, adjust confidence and add warning
        if (!validation.isValidated) {
          return FishIdentificationResult(
            isIdentified: true,
            localNameBangla: result.localNameBangla,
            localNameEnglish: result.localNameEnglish,
            scientificName: result.scientificName,
            confidence: validation.adjustedConfidence, // Use adjusted confidence
            habitat: result.habitat,
            identificationMarkers: result.identificationMarkers,
            similarFishName: validation.suggestedAlternatives.isNotEmpty 
                ? validation.suggestedAlternatives.first 
                : result.similarFishName,
            whyNotSimilar: validation.warnings.isNotEmpty 
                ? validation.warnings.first 
                : result.whyNotSimilar,
            description: result.description,
            calories: result.calories,
            protein: result.protein,
            marketPrice: result.marketPrice,
            cookingMethod: result.cookingMethod,
            freshnessChecklist: result.freshnessChecklist,
            recipes: result.recipes,
          );
        }
        
        return result;
      } else {
        return FishIdentificationResult.error(
            'Groq API Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      return FishIdentificationResult.error('Error: ${e.toString()}');
    }
  }
}
