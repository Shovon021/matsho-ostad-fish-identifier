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
