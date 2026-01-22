import '../models/fish_identification_result.dart';

/// Validation service to cross-check AI results against local knowledge base
class FishValidationService {
  
  /// Visual marker profiles for commonly confused fish
  /// This is our "ground truth" for validation
  static const Map<String, FishVisualProfile> _fishProfiles = {
    // ============ CARP FAMILY ============
    'rohu': FishVisualProfile(
      id: 'rohu',
      nameBangla: 'রুই',
      nameEnglish: 'Rohu',
      bodyShape: 'deep-bodied, laterally compressed',
      finColors: 'grey to pinkish, NO bright red',
      scalePattern: 'large cycloid scales, silver-grey',
      distinctiveFeatures: ['fleshy lips', 'no barbels', 'silvery body'],
      confusedWith: ['tilapia', 'mrigal', 'catla'],
      differentiators: {
        'tilapia': 'Tilapia has RED/PINK tail fin and slightly humped back. Rohu has grey fins and streamlined body.',
        'mrigal': 'Mrigal has more elongated body and smaller head. Rohu is deeper-bodied.',
        'catla': 'Catla has much larger head and upturned mouth. Rohu has normal proportioned head.',
      },
    ),
    
    'tilapia': FishVisualProfile(
      id: 'tilapia',
      nameBangla: 'তেলাপিয়া',
      nameEnglish: 'Tilapia',
      bodyShape: 'deep-bodied, slightly humped back',
      finColors: 'RED or PINK tail fin (key identifier!)',
      scalePattern: 'medium scales, often with vertical bars',
      distinctiveFeatures: ['red/pink tail fin', 'slightly humped back', 'vertical bars on body'],
      confusedWith: ['rohu', 'catla'],
      differentiators: {
        'rohu': 'Rohu has grey fins with NO red coloration. Rohu body is more streamlined.',
        'catla': 'Catla has much larger head. Tilapia has normal proportioned head with red tail.',
      },
    ),
    
    'catla': FishVisualProfile(
      id: 'catla',
      nameBangla: 'কাতলা',
      nameEnglish: 'Catla',
      bodyShape: 'deep-bodied with VERY LARGE head',
      finColors: 'greyish, no bright colors',
      scalePattern: 'large scales, silver',
      distinctiveFeatures: ['exceptionally large head (1/3 of body)', 'upturned mouth', 'protruding lower jaw'],
      confusedWith: ['bighead_carp', 'rohu'],
      differentiators: {
        'bighead_carp': 'Bighead carp has downturned mouth and spotted body. Catla has upturned mouth.',
        'rohu': 'Rohu has proportional head. Catla head is noticeably larger.',
      },
    ),
    
    'mrigal': FishVisualProfile(
      id: 'mrigal',
      nameBangla: 'মৃগেল',
      nameEnglish: 'Mrigal Carp',
      bodyShape: 'elongated, torpedo-shaped',
      finColors: 'greyish, sometimes with pink tinge',
      scalePattern: 'medium scales, dark grey back, silvery sides',
      distinctiveFeatures: ['elongated body', 'smaller head', 'subterminal mouth'],
      confusedWith: ['rohu', 'bata'],
      differentiators: {
        'rohu': 'Rohu is deeper-bodied. Mrigal is more torpedo-shaped.',
        'bata': 'Bata is smaller and has different scale pattern.',
      },
    ),
    
    // ============ HILSA AND LOOKALIKES ============
    'hilsa': FishVisualProfile(
      id: 'hilsa',
      nameBangla: 'ইলিশ',
      nameEnglish: 'Hilsa',
      bodyShape: 'elongated, laterally compressed, herring-like',
      finColors: 'silver with golden sheen, deeply forked tail',
      scalePattern: 'thin deciduous scales, brilliant silver',
      distinctiveFeatures: ['golden sheen', 'deeply forked tail', 'single dorsal fin', 'very oily'],
      confusedWith: ['silver_carp', 'chandana'],
      differentiators: {
        'silver_carp': 'Silver carp has larger head and no golden sheen. Hilsa is more streamlined.',
        'chandana': 'Chandana is smaller and lacks the distinctive golden sheen of Hilsa.',
      },
    ),
    
    // ============ CATFISH ============
    'pangasius': FishVisualProfile(
      id: 'pangasius',
      nameBangla: 'পাঙ্গাস',
      nameEnglish: 'Pangasius',
      bodyShape: 'elongated, shark-like profile',
      finColors: 'grey fins, white belly',
      scalePattern: 'smooth skin (scaleless catfish)',
      distinctiveFeatures: ['smooth scaleless skin', 'forked tail', 'small eyes', 'barbels around mouth'],
      confusedWith: ['boal', 'ayre'],
      differentiators: {
        'boal': 'Boal has much wider, flattened head and predatory appearance. Pangasius head is smaller.',
        'ayre': 'Ayre has spotted pattern and barbels near mouth. Pangasius is more uniform colored.',
      },
    ),
    
    'boal': FishVisualProfile(
      id: 'boal',
      nameBangla: 'বোয়াল',
      nameEnglish: 'Boal',
      bodyShape: 'large, elongated with wide flattened head',
      finColors: 'grey-brown, no bright colors',
      scalePattern: 'smooth skin (scaleless)',
      distinctiveFeatures: ['very wide flattened head', 'predatory appearance', 'large mouth with teeth'],
      confusedWith: ['pangasius', 'ayre'],
      differentiators: {
        'pangasius': 'Pangasius has smaller, more proportionate head. Boal head is distinctively wide and flat.',
        'ayre': 'Ayre has smaller head relative to body. Boal head is much larger.',
      },
    ),
  };

  /// Validate AI result against local knowledge base
  /// Returns adjusted result with potential corrections
  static ValidationResult validateResult(FishIdentificationResult aiResult) {
    final aiName = aiResult.localNameEnglish.toLowerCase();
    
    // Try to find matching profile
    FishVisualProfile? matchedProfile;
    for (final entry in _fishProfiles.entries) {
      if (aiName.contains(entry.key) || entry.value.nameEnglish.toLowerCase().contains(aiName)) {
        matchedProfile = entry.value;
        break;
      }
    }
    
    if (matchedProfile == null) {
      // No profile found, trust AI result
      return ValidationResult(
        isValidated: true,
        adjustedConfidence: aiResult.confidence,
        warnings: [],
        suggestedAlternatives: [],
      );
    }
    
    // Check for red flags in identification markers
    final markers = aiResult.identificationMarkers.join(' ').toLowerCase();
    List<String> warnings = [];
    List<String> alternatives = [];
    double adjustedConfidence = aiResult.confidence;
    
    // === TILAPIA vs ROHU CHECK ===
    if (aiName.contains('rohu')) {
      // If AI says Rohu, but markers mention red/pink fins, it's likely wrong
      if (markers.contains('red') || markers.contains('pink')) {
        warnings.add('⚠️ AI identified as Rohu but detected red/pink coloration - likely Tilapia');
        alternatives.add('Tilapia');
        adjustedConfidence = (adjustedConfidence * 0.5).clamp(0.0, 1.0); // Significantly lower confidence
      }
    }
    
    if (aiName.contains('tilapia')) {
      // If AI says Tilapia, but no red/pink mentioned, might be wrong
      if (!markers.contains('red') && !markers.contains('pink')) {
        warnings.add('⚠️ AI identified as Tilapia but no red/pink tail detected - verify identification');
        alternatives.add('Rohu');
        alternatives.add('Mrigal');
        adjustedConfidence = (adjustedConfidence * 0.7).clamp(0.0, 1.0);
      }
    }
    
    // === CATLA HEAD CHECK ===
    if (aiName.contains('catla')) {
      if (!markers.contains('large head') && !markers.contains('big head')) {
        warnings.add('⚠️ Catla should have noticeably large head - verify identification');
        alternatives.add('Rohu');
        alternatives.add('Bighead Carp');
        adjustedConfidence = (adjustedConfidence * 0.8).clamp(0.0, 1.0);
      }
    }
    
    // === HILSA GOLDEN SHEEN CHECK ===
    if (aiName.contains('hilsa')) {
      if (!markers.contains('golden') && !markers.contains('sheen') && !markers.contains('oily')) {
        warnings.add('⚠️ Hilsa should have golden sheen - might be Silver Carp');
        alternatives.add('Silver Carp');
        adjustedConfidence = (adjustedConfidence * 0.75).clamp(0.0, 1.0);
      }
    }
    
    return ValidationResult(
      isValidated: warnings.isEmpty,
      adjustedConfidence: adjustedConfidence,
      warnings: warnings,
      suggestedAlternatives: alternatives,
      matchedProfile: matchedProfile,
    );
  }
  
  /// Get confusion info for a fish
  static Map<String, String>? getConfusionInfo(String fishName) {
    final name = fishName.toLowerCase();
    for (final entry in _fishProfiles.entries) {
      if (name.contains(entry.key) || entry.value.nameEnglish.toLowerCase().contains(name)) {
        return entry.value.differentiators;
      }
    }
    return null;
  }
}

/// Visual profile for a fish species
class FishVisualProfile {
  final String id;
  final String nameBangla;
  final String nameEnglish;
  final String bodyShape;
  final String finColors;
  final String scalePattern;
  final List<String> distinctiveFeatures;
  final List<String> confusedWith;
  final Map<String, String> differentiators;
  
  const FishVisualProfile({
    required this.id,
    required this.nameBangla,
    required this.nameEnglish,
    required this.bodyShape,
    required this.finColors,
    required this.scalePattern,
    required this.distinctiveFeatures,
    required this.confusedWith,
    required this.differentiators,
  });
}

/// Result of validation check
class ValidationResult {
  final bool isValidated;
  final double adjustedConfidence;
  final List<String> warnings;
  final List<String> suggestedAlternatives;
  final FishVisualProfile? matchedProfile;
  
  const ValidationResult({
    required this.isValidated,
    required this.adjustedConfidence,
    required this.warnings,
    required this.suggestedAlternatives,
    this.matchedProfile,
  });
}
