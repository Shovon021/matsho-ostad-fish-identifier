import 'fish_model.dart';

/// This repository provides mock data for demonstration.
/// In production, this would be backed by SQLite or Hive.
class FishRepository {
  // Singleton pattern
  static final FishRepository _instance = FishRepository._internal();
  factory FishRepository() => _instance;
  FishRepository._internal();

  // Sample Bangladeshi Fish Data
  final List<Fish> _allFish = [
    const Fish(
      id: 1,
      localName: 'রুই (Rui)',
      scientificName: 'Labeo rohita',
      habitat: 'Freshwater (মিঠা পানি)',
      description:
          'One of the most popular fish in Bangladesh. A major carp species with silvery scales.',
      imageAsset: 'assets/images/rui.png',
      identificationMarkers: [
        'ঠোঁট ভোঁতা ও পুরু (Blunt, thick lips)',
        'শরীর রুপালি ও লম্বাটে (Silvery, elongated body)',
        'পিঠে সবুজাভ আভা (Greenish tinge on back)',
      ],
      visualClusterId: 1, // Carp Group
    ),
    const Fish(
      id: 2,
      localName: 'মৃগেল (Mrigel)',
      scientificName: 'Cirrhinus cirrhosus',
      habitat: 'Freshwater (মিঠা পানি)',
      description:
          'Another major carp, often confused with Rui. Known for its bottom-feeding habits.',
      imageAsset: 'assets/images/mrigel.png',
      identificationMarkers: [
        'নিচের ঠোঁট সরু ও সামনে মুখ (Thin lower lip, terminal mouth)',
        'শরীরে সোনালি আভা (Golden tinge on body)',
        'মাথা ছোট ও গোলাকার (Small, rounded head)',
      ],
      visualClusterId: 1, // Carp Group
    ),
    const Fish(
      id: 3,
      localName: 'কাতল (Katla/Katol)',
      scientificName: 'Catla catla',
      habitat: 'Freshwater (মিঠা পানি)',
      description:
          'The largest of the Indian major carps. Popular for its large head.',
      imageAsset: 'assets/images/katol.png',
      identificationMarkers: [
        'মাথা অনেক বড় (Very large head)',
        'উপরের চোয়াল নিচেরটির চেয়ে ছোট (Upturned mouth)',
        'শরীর গভীর ও চ্যাপ্টা (Deep, laterally compressed body)',
      ],
      visualClusterId: 1, // Carp Group
    ),
    const Fish(
      id: 4,
      localName: 'ইলিশ (Hilsa)',
      scientificName: 'Tenualosa ilisha',
      habitat: 'Saltwater & Freshwater (লোনা ও মিঠা পানি)',
      description:
          'The national fish of Bangladesh. Prized for its unique taste and texture.',
      imageAsset: 'assets/images/hilsa.png',
      identificationMarkers: [
        'শরীর চ্যাপ্টা ও রুপালি (Flat, silvery body)',
        'পেটে তীক্ষ্ণ কাঁটার সারি (Sharp scutes on belly)',
        'লেজের পাখনা কাঁটাচামচ আকৃতির (Forked tail fin)',
      ],
      visualClusterId: null, // Unique, no common confusion
    ),
    const Fish(
      id: 5,
      localName: 'টেংরা (Tengra)',
      scientificName: 'Mystus tengara',
      habitat: 'Freshwater (মিঠা পানি)',
      description:
          'A small catfish with distinctive markings. Popular in Bengali cuisine.',
      imageAsset: 'assets/images/tengra.png',
      identificationMarkers: [
        'শরীরে কালো ফোঁটা/দাগ (Black spots/stripes on body)',
        'লম্বা গোঁফ (Long barbels)',
        'মাথা চ্যাপ্টা (Flat head)',
      ],
      visualClusterId: 2, // Small Catfish Group
    ),
    const Fish(
      id: 6,
      localName: 'গুলশা (Gulsha)',
      scientificName: 'Mystus cavasius',
      habitat: 'Freshwater (মিঠা পানি)',
      description:
          'A prized catfish, similar to Tengra but without prominent markings.',
      imageAsset: 'assets/images/gulsha.png',
      identificationMarkers: [
        'শরীর প্লেইন, দাগহীন (Plain body, no prominent markings)',
        'হালকা হলুদাভ রঙ (Light yellowish color)',
        'টেংরার চেয়ে একটু বড় (Slightly larger than Tengra)',
      ],
      visualClusterId: 2, // Small Catfish Group
    ),
    const Fish(
      id: 7,
      localName: 'শিং (Shing)',
      scientificName: 'Heteropneustes fossilis',
      habitat: 'Freshwater (মিঠা পানি)',
      description: 'A stinging catfish with venomous pectoral fin spines.',
      imageAsset: 'assets/images/shing.png',
      identificationMarkers: [
        'শরীর কালচে বা ধূসর (Blackish or grey body)',
        'লম্বা শরীর (Elongated body)',
        'বুকের কাঁটায় বিষ (Venomous pectoral spines)',
      ],
      visualClusterId: 3, // Large Catfish Group
    ),
    const Fish(
      id: 8,
      localName: 'মাগুর (Magur)',
      scientificName: 'Clarias batrachus',
      habitat: 'Freshwater (মিঠা পানি)',
      description:
          'A walking catfish, known for its ability to survive out of water.',
      imageAsset: 'assets/images/magur.png',
      identificationMarkers: [
        'শরীর কালো বা বাদামি (Black or brown body)',
        'মাথা চওড়া ও চ্যাপ্টা (Wide, flat head)',
        'পিঠের পাখনা লম্বা (Long dorsal fin)',
      ],
      visualClusterId: 3, // Large Catfish Group
    ),
    const Fish(
      id: 9,
      localName: 'পাঙ্গাস (Pangas)',
      scientificName: 'Pangasius pangasius',
      habitat: 'Freshwater (মিঠা পানি)',
      description:
          'A large river catfish, commercially farmed. Known for its fatty meat.',
      imageAsset: 'assets/images/pangas.png',
      identificationMarkers: [
        'শরীর অনেক বড় ও চর্বিযুক্ত (Large, fatty body)',
        'রুপালি রঙ (Silvery color)',
        'ছোট মাথা (Small head relative to body)',
      ],
      visualClusterId: 4, // Large River Fish
    ),
    const Fish(
      id: 10,
      localName: 'তেলাপিয়া (Tilapia)',
      scientificName: 'Oreochromis niloticus',
      habitat: 'Freshwater (মিঠা পানি)',
      description:
          'An introduced species, widely farmed due to its fast growth.',
      imageAsset: 'assets/images/tilapia.png',
      identificationMarkers: [
        'শরীরে উল্লম্ব কালো দাগ (Vertical dark stripes)',
        'পিঠের পাখনায় কাঁটা (Spiny dorsal fin)',
        'গোলাকার শরীর (Rounded body shape)',
      ],
      visualClusterId: 5, // Cichlid Group
    ),
  ];

  // Confusion Pairs Data
  final List<ConfusionPair> _confusionPairs = [
    const ConfusionPair(
      fishId1: 1, // Rui
      fishId2: 2, // Mrigel
      distinguishingFeatureText:
          'রুই মাছের ঠোঁট পুরু ও ভোঁতা, কিন্তু মৃগেল মাছের নিচের ঠোঁট সরু এবং মুখ একটু নিচের দিকে থাকে। মৃগেলের শরীরে সোনালি আভা থাকে যা রুইতে দেখা যায় না।',
    ),
    const ConfusionPair(
      fishId1: 1, // Rui
      fishId2: 3, // Katol
      distinguishingFeatureText:
          'কাতল মাছের মাথা অনেক বড় এবং মুখ উপরের দিকে তাকানো, যেখানে রুই মাছের মাথা ছোট এবং মুখ সোজা।',
    ),
    const ConfusionPair(
      fishId1: 5, // Tengra
      fishId2: 6, // Gulsha
      distinguishingFeatureText:
          'টেংরা মাছের শরীরে স্পষ্ট কালো দাগ বা ফোঁটা থাকে, কিন্তু গুলশা মাছ প্রায় প্লেইন, হালকা হলুদাভ রঙের হয়। গুলশা সাধারণত টেংরার চেয়ে একটু বড় হয়।',
    ),
    const ConfusionPair(
      fishId1: 7, // Shing
      fishId2: 8, // Magur
      distinguishingFeatureText:
          'শিং মাছের শরীর সরু ও লম্বাটে এবং রঙ কালচে ধূসর। মাগুর মাছের শরীর বেশি মোটা, মাথা চওড়া ও চ্যাপ্টা এবং পিঠের পাখনা অনেক লম্বা।',
    ),
  ];

  List<Fish> getAllFish() => List.unmodifiable(_allFish);

  Fish? getFishById(int id) {
    try {
      return _allFish.firstWhere((fish) => fish.id == id);
    } catch (_) {
      return null;
    }
  }

  Fish? getFishByLocalName(String name) {
    try {
      return _allFish.firstWhere(
        (fish) => fish.localName.toLowerCase().contains(name.toLowerCase()),
      );
    } catch (_) {
      return null;
    }
  }

  /// Returns the confusion data if the identified fish has a known lookalike.
  /// Returns null if there isn't one or if confidence is very high.
  ConfusionPair? getConfusionDataForFish(int fishId) {
    try {
      return _confusionPairs.firstWhere(
        (pair) => pair.fishId1 == fishId || pair.fishId2 == fishId,
      );
    } catch (_) {
      return null;
    }
  }

  /// Gets the name of the fish that is commonly confused with the given one.
  String? getConfusedFishName(int identifiedFishId) {
    final pair = getConfusionDataForFish(identifiedFishId);
    if (pair == null) return null;

    final confusedId =
        pair.fishId1 == identifiedFishId ? pair.fishId2 : pair.fishId1;
    return getFishById(confusedId)?.localName;
  }
}
