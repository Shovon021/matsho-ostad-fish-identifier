import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cross_file/cross_file.dart';
import '../data/fish_database.dart';
import '../models/fish_identification_result.dart';
import 'groq_fish_service.dart';

/// Fish Service
/// Uses Groq Vision API (primary)
/// Falls back to offline database for enrichment

class HybridFishService {
  final GroqFishService _groqService = GroqFishService();
  
  /// Check internet connectivity
  Future<bool> _hasInternet() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      return !connectivityResult.contains(ConnectivityResult.none);
    } catch (e) {
      return false;
    }
  }


  /// Identify fish using Groq Vision API
  Future<FishIdentificationResult> identifyFish(XFile imageFile) async {
    final hasInternet = await _hasInternet();
    
    // If no internet, return offline-friendly message
    if (!hasInternet) {
      return FishIdentificationResult.error(
        'ইন্টারনেট সংযোগ নেই। মাছ শনাক্ত করতে ইন্টারনেট প্রয়োজন।\n'
        'No internet connection. Please connect to identify fish.'
      );
    }

    // Use Groq API
    final groqResult = await _groqService.identifyFish(imageFile);
    
    if (groqResult.isIdentified) {
      return _enrichWithLocalData(groqResult);
    }
    
    return groqResult;
  }

  /// Enrich API results with local database data
  FishIdentificationResult _enrichWithLocalData(FishIdentificationResult apiResult) {
    // Try to find matching fish in local database
    final localFish = BangladeshiFishDatabase.findByName(apiResult.localNameEnglish);
    
    if (localFish != null) {
      // Merge local data with API result for more complete info
      return FishIdentificationResult(
        isIdentified: true,
        localNameBangla: localFish.nameBangla,
        localNameEnglish: localFish.nameEnglish,
        scientificName: localFish.scientificName,
        confidence: apiResult.confidence,
        habitat: localFish.habitat,
        identificationMarkers: apiResult.identificationMarkers,
        similarFishName: apiResult.similarFishName,
        whyNotSimilar: apiResult.whyNotSimilar,
        description: apiResult.description.isNotEmpty 
            ? apiResult.description 
            : localFish.description,
        calories: localFish.calories,
        protein: localFish.protein,
        marketPrice: localFish.priceRange,
        cookingMethod: localFish.cookingMethods.join(', '),
        freshnessChecklist: localFish.freshnessChecklist,
        recipes: localFish.recipes,
      );
    }
    
    // Return original API result if not found in local DB
    return apiResult;
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
