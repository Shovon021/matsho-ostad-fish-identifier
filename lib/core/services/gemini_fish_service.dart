import 'dart:convert';
import 'package:cross_file/cross_file.dart';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

/// Service for real fish identification using Gemini Vision API
class GeminiFishService {
  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';

  /// Analyze a fish image and return identification results
  Future<FishIdentificationResult> identifyFish(XFile imageFile) async {
    if (!ApiConfig.isConfigured) {
      return FishIdentificationResult.error(
          'API key not configured. Please add your Gemini API key in lib/core/config/api_config.dart');
    }

    try {
      final imageBytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(imageBytes);

      const prompt = '''
You are an expert ichthyologist specializing in Bangladeshi freshwater and saltwater fish species.

Analyze this fish image and identify the species. Respond ONLY in this exact JSON format:

{
  "identified": true,
  "local_name_bangla": "মাছের বাংলা নাম",
  "local_name_english": "Fish name in English",
  "scientific_name": "Scientific name",
  "confidence": 0.85,
  "habitat": "Freshwater/Saltwater/Both",
  "identification_markers": [
    "Feature 1 that helped identify this fish",
    "Feature 2",
    "Feature 3"
  ],
  "similar_fish": {
    "name": "Name of similar fish that could be confused",
    "why_not_this": "Explanation why it is NOT the similar fish - be specific about physical differences"
  },
  "description": "Brief description of the fish",
  "nutrition": {
    "calories": "approx calories per 100g",
    "protein": "approx protein per 100g"
  },
  "market_price": "Approximate price range in BDT per kg",
  "cooking_method": "Recommended cooking style (Curry, Fry, Steam, etc.)",
  "freshness_checklist": [
    "Specific sign 1 to check freshness (e.g. red gills)",
    "Specific sign 2 (e.g. firm texture)"
  ],
  "recipes": [
    "Name of popular Bangla dish 1",
    "Name of popular Bangla dish 2"
  ]
}

IMPORTANT VALIDATION RULES:
1. Is this a REAL BIOLOGICAL FISH? If it is a toy, drawing, plastic model, or cooked dish, set "identified": false and include "error": "This appears to be a [toy/drawing], not a live fish".
2. If the image is too blurry, dark, or partial to be sure, set "identified": false with "error": "Image quality too poor to identify".
3. Be honest with the "confidence" score. If it looks like a Tenualosa ilisha but has slight differences, give 0.8, not 1.0.
4. Always include the "similar_fish" field to educate the user about commonly confused species.
5. Respond with ONLY the JSON object, no additional text.
''';

      final requestBody = {
        'contents': [
          {
            'parts': [
              {'text': prompt},
              {
                'inline_data': {'mime_type': 'image/jpeg', 'data': base64Image}
              }
            ]
          }
        ],
        'generationConfig': {
          'temperature': 0.1,  // Lower for more consistent output
          'topK': 32,
          'topP': 0.95,
          'maxOutputTokens': 2048,  // Increased for complete JSON
        }
      };

      // Try all available API keys
      for (int attempt = 0; attempt < ApiConfig.keyCount; attempt++) {
        final response = await http.post(
          Uri.parse('$_baseUrl?key=${ApiConfig.geminiApiKey}'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(requestBody),
        ).timeout(
          const Duration(seconds: 30),
          onTimeout: () => http.Response('{"error": "Request timed out"}', 408),
        );

        if (response.statusCode == 200) {
          // Success - continue processing below
          final responseData = json.decode(response.body) as Map<String, dynamic>;
          final candidates = responseData['candidates'] as List?;

          if (candidates == null || candidates.isEmpty) {
            return FishIdentificationResult.error('No response from AI');
          }

          final content = candidates[0]['content']['parts'][0]['text'] as String;

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

          return FishIdentificationResult(
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
        } else if (response.statusCode == 429) {
          // Quota exhausted - rotate to next key and retry
          ApiConfig.rotateKey();
          continue;
        } else {
          return FishIdentificationResult.error(
              'API Error: ${response.statusCode} - ${response.body}');
        }
      }

      // All keys exhausted
      return FishIdentificationResult.error(
          'All API keys exhausted. Please try again later.');
    } catch (e) {
      return FishIdentificationResult.error('Error: ${e.toString()}');
    }
  }
}

class FishIdentificationResult {
  final bool isIdentified;
  final String? errorMessage;
  final String localNameBangla;
  final String localNameEnglish;
  final String scientificName;
  final double confidence;
  final String habitat;
  final List<String> identificationMarkers;
  final String? similarFishName;
  final String? whyNotSimilar;
  final String description;
  final String calories;
  final String protein;
  final String marketPrice;
  final String cookingMethod;
  final List<String> freshnessChecklist;
  final List<String> recipes;

  FishIdentificationResult({
    required this.isIdentified,
    this.errorMessage,
    this.localNameBangla = '',
    this.localNameEnglish = '',
    this.scientificName = '',
    this.confidence = 0.0,
    this.habitat = '',
    this.identificationMarkers = const [],
    this.similarFishName,
    this.whyNotSimilar,
    this.description = '',
    this.calories = '',
    this.protein = '',
    this.marketPrice = '',
    this.cookingMethod = '',
    this.freshnessChecklist = const [],
    this.recipes = const [],
  });

  factory FishIdentificationResult.error(String message) {
    return FishIdentificationResult(
      isIdentified: false,
      errorMessage: message,
    );
  }

  String get displayName => localNameBangla.isNotEmpty
      ? '$localNameBangla ($localNameEnglish)'
      : localNameEnglish;
}
