import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cross_file/cross_file.dart';
import '../data/fish_database.dart';
import 'gemini_fish_service.dart';

/// Hybrid Fish Service
/// Uses offline database first, falls back to Gemini API when:
/// - Confidence is low
/// - Internet is available
/// - Fish not found in local database

class HybridFishService {
  final GeminiFishService _geminiService = GeminiFishService();
  
  /// Check internet connectivity
  Future<bool> _hasInternet() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      return !connectivityResult.contains(ConnectivityResult.none);
    } catch (e) {
      return false;
    }
  }


  /// Identify fish using hybrid approach
  Future<FishIdentificationResult> identifyFish(XFile imageFile) async {
    final hasInternet = await _hasInternet();
    
    // If no internet, return offline-friendly message
    if (!hasInternet) {
      // In a full implementation, we'd use TFLite here
      // For now, we'll inform user they need internet
      return FishIdentificationResult.error(
        'ইন্টারনেট সংযোগ নেই। মাছ শনাক্ত করতে ইন্টারনেট প্রয়োজন।\n'
        'No internet connection. Please connect to identify fish.'
      );
    }

    // Use Gemini for identification (primary method)
    final geminiResult = await _geminiService.identifyFish(imageFile);
    
    // If Gemini identified the fish, enrich with local database
    if (geminiResult.isIdentified) {
      return _enrichWithLocalData(geminiResult);
    }
    
    return geminiResult;
  }

  /// Enrich Gemini results with local database data
  FishIdentificationResult _enrichWithLocalData(FishIdentificationResult geminiResult) {
    // Try to find matching fish in local database
    final localFish = BangladeshiFishDatabase.findByName(geminiResult.localNameEnglish);
    
    if (localFish != null) {
      // Merge local data with Gemini result for more complete info
      return FishIdentificationResult(
        isIdentified: true,
        localNameBangla: localFish.nameBangla,
        localNameEnglish: localFish.nameEnglish,
        scientificName: localFish.scientificName,
        confidence: geminiResult.confidence,
        habitat: localFish.habitat,
        identificationMarkers: geminiResult.identificationMarkers,
        similarFishName: geminiResult.similarFishName,
        whyNotSimilar: geminiResult.whyNotSimilar,
        description: geminiResult.description.isNotEmpty 
            ? geminiResult.description 
            : localFish.description,
        calories: localFish.calories,
        protein: localFish.protein,
        marketPrice: localFish.priceRange,
        cookingMethod: localFish.cookingMethods.join(', '),
        freshnessChecklist: localFish.freshnessChecklist,
        recipes: localFish.recipes,
      );
    }
    
    // Return original Gemini result if not found in local DB
    return geminiResult;
  }

  /// Get fish info from local database by name
  FishData? getLocalFishInfo(String name) {
    return BangladeshiFishDatabase.findByName(name);
  }

  /// Get all fish from local database
  List<FishData> getAllLocalFish() {
    return BangladeshiFishDatabase.allFish;
  }

  /// Get fish by category
  List<FishData> getFishByCategory(String category) {
    return BangladeshiFishDatabase.getByCategory(category);
  }

  /// Check if fish exists in local database
  bool isInLocalDatabase(String name) {
    return BangladeshiFishDatabase.findByName(name) != null;
  }
}
