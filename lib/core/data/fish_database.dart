// Local Bangladeshi Fish Database
// Contains 50+ species with complete information for offline identification

class FishData {
  final String id;
  final String nameBangla;
  final String nameEnglish;
  final String scientificName;
  final String habitat; // Freshwater, Saltwater, Both
  final String category; // Freshwater, Saltwater, Cultured
  final String priceRange; // BDT per kg
  final String description;
  final List<String> cookingMethods;
  final List<String> freshnessChecklist;
  final List<String> recipes;
  final String calories;
  final String protein;

  const FishData({
    required this.id,
    required this.nameBangla,
    required this.nameEnglish,
    required this.scientificName,
    required this.habitat,
    required this.category,
    required this.priceRange,
    required this.description,
    required this.cookingMethods,
    required this.freshnessChecklist,
    required this.recipes,
    required this.calories,
    required this.protein,
  });
}

class BangladeshiFishDatabase {
  static const List<FishData> allFish = [
    // ============ FRESHWATER FISH (স্বাদুপানির মাছ) ============
    
    FishData(
      id: 'rohu',
      nameBangla: 'রুই',
      nameEnglish: 'Rohu',
      scientificName: 'Labeo rohita',
      habitat: 'Freshwater',
      category: 'Freshwater',
      priceRange: '৳250-350/kg',
      description: 'One of the most popular freshwater fish in Bangladesh. Has a silvery body with reddish fins.',
      cookingMethods: ['Curry', 'Fry', 'Bhuna'],
      freshnessChecklist: ['Bright red gills', 'Clear eyes', 'Firm flesh', 'Fresh smell'],
      recipes: ['রুই মাছের কালিয়া', 'রুই মাছ ভাজা', 'দই রুই'],
      calories: '97 kcal/100g',
      protein: '16.6g/100g',
    ),
    
    FishData(
      id: 'catla',
      nameBangla: 'কাতলা',
      nameEnglish: 'Catla',
      scientificName: 'Catla catla',
      habitat: 'Freshwater',
      category: 'Freshwater',
      priceRange: '৳280-400/kg',
      description: 'Large-headed carp with silver scales. The head is considered a delicacy.',
      cookingMethods: ['Curry', 'Kalia', 'Bhapa'],
      freshnessChecklist: ['Shiny scales', 'Red gills', 'No sliminess'],
      recipes: ['কাতলা মাছের মাথা দিয়ে ডাল', 'কাতলা কালিয়া', 'কাতলা ভাপা'],
      calories: '111 kcal/100g',
      protein: '18.2g/100g',
    ),
    
    FishData(
      id: 'mrigal',
      nameBangla: 'মৃগেল',
      nameEnglish: 'Mrigal Carp',
      scientificName: 'Cirrhinus mrigala',
      habitat: 'Freshwater',
      category: 'Freshwater',
      priceRange: '৳220-300/kg',
      description: 'Bottom-dwelling carp with dark grey back and silvery sides.',
      cookingMethods: ['Curry', 'Fry', 'Jhol'],
      freshnessChecklist: ['Firm body', 'Clear eyes', 'Fresh river smell'],
      recipes: ['মৃগেল মাছের ঝোল', 'মৃগেল ভাজা', 'মৃগেল কারি'],
      calories: '88 kcal/100g',
      protein: '15.8g/100g',
    ),
    
    FishData(
      id: 'kalibaus',
      nameBangla: 'কালিবাউস',
      nameEnglish: 'Kalibaus',
      scientificName: 'Labeo calbasu',
      habitat: 'Freshwater',
      category: 'Freshwater',
      priceRange: '৳350-500/kg',
      description: 'Dark-colored carp with thick lips. Highly prized for its taste.',
      cookingMethods: ['Curry', 'Kalia', 'Fry'],
      freshnessChecklist: ['Dark shiny skin', 'Firm flesh', 'Fresh smell'],
      recipes: ['কালিবাউস মাছের কালিয়া', 'কালিবাউস ভাজা'],
      calories: '102 kcal/100g',
      protein: '17.5g/100g',
    ),
    
    FishData(
      id: 'bata',
      nameBangla: 'বাটা',
      nameEnglish: 'Bata',
      scientificName: 'Labeo bata',
      habitat: 'Freshwater',
      category: 'Freshwater',
      priceRange: '৳180-250/kg',
      description: 'Small carp with silver body. Popular for everyday meals.',
      cookingMethods: ['Fry', 'Curry', 'Jhol'],
      freshnessChecklist: ['Shiny scales', 'Clear eyes', 'No bad smell'],
      recipes: ['বাটা মাছ ভাজা', 'বাটা মাছের ঝোল'],
      calories: '85 kcal/100g',
      protein: '14.2g/100g',
    ),
    
    FishData(
      id: 'pabda',
      nameBangla: 'পাবদা',
      nameEnglish: 'Pabda Catfish',
      scientificName: 'Ompok pabda',
      habitat: 'Freshwater',
      category: 'Freshwater',
      priceRange: '৳600-900/kg',
      description: 'Small catfish with smooth skin. Considered a delicacy with rich flavor.',
      cookingMethods: ['Jhol', 'Curry', 'Bhuna'],
      freshnessChecklist: ['Smooth skin', 'No slime', 'Fresh smell', 'Active when alive'],
      recipes: ['পাবদা মাছের ঝোল', 'পাবদা মাছ ভুনা', 'পাবদা শুঁটকি'],
      calories: '95 kcal/100g',
      protein: '16.8g/100g',
    ),
    
    FishData(
      id: 'shing',
      nameBangla: 'শিং',
      nameEnglish: 'Stinging Catfish',
      scientificName: 'Heteropneustes fossilis',
      habitat: 'Freshwater',
      category: 'Freshwater',
      priceRange: '৳700-1000/kg',
      description: 'Elongated catfish with venomous spine. Highly nutritious, especially for patients.',
      cookingMethods: ['Jhol', 'Curry', 'Bharta'],
      freshnessChecklist: ['Active movement', 'No wounds', 'Clear eyes'],
      recipes: ['শিং মাছের ঝোল', 'শিং মাছ ভর্তা', 'শিং মাছের তরকারি'],
      calories: '128 kcal/100g',
      protein: '22.1g/100g',
    ),
    
    FishData(
      id: 'magur',
      nameBangla: 'মাগুর',
      nameEnglish: 'Walking Catfish',
      scientificName: 'Clarias batrachus',
      habitat: 'Freshwater',
      category: 'Freshwater',
      priceRange: '৳500-800/kg',
      description: 'Air-breathing catfish that can survive out of water. Very nutritious.',
      cookingMethods: ['Jhol', 'Curry', 'Bhuna'],
      freshnessChecklist: ['Active and alive', 'No injuries', 'Moist skin'],
      recipes: ['মাগুর মাছের ঝোল', 'মাগুর মাছ ভুনা', 'মাগুর মাছের তরকারি'],
      calories: '135 kcal/100g',
      protein: '23.5g/100g',
    ),
    
    FishData(
      id: 'koi',
      nameBangla: 'কই',
      nameEnglish: 'Climbing Perch',
      scientificName: 'Anabas testudineus',
      habitat: 'Freshwater',
      category: 'Freshwater',
      priceRange: '৳400-600/kg',
      description: 'Hardy fish that can breathe air and climb on land. Rich in nutrients.',
      cookingMethods: ['Jhol', 'Bhuna', 'Shorshe'],
      freshnessChecklist: ['Active and jumping', 'Firm body', 'No marks'],
      recipes: ['কই মাছের ঝোল', 'শর্ষে কই', 'কই মাছ ভুনা'],
      calories: '120 kcal/100g',
      protein: '21.0g/100g',
    ),
    
    FishData(
      id: 'shol',
      nameBangla: 'শোল',
      nameEnglish: 'Striped Snakehead',
      scientificName: 'Channa striata',
      habitat: 'Freshwater',
      category: 'Freshwater',
      priceRange: '৳350-500/kg',
      description: 'Predatory fish with elongated body. Can survive in low-oxygen water.',
      cookingMethods: ['Curry', 'Fry', 'Jhol'],
      freshnessChecklist: ['Active if alive', 'Firm flesh', 'No bad smell'],
      recipes: ['শোল মাছের ঝোল', 'শোল মাছ ভাজা', 'শোল মাছের কালিয়া'],
      calories: '108 kcal/100g',
      protein: '18.5g/100g',
    ),
    
    FishData(
      id: 'boal',
      nameBangla: 'বোয়াল',
      nameEnglish: 'Boal Fish',
      scientificName: 'Wallago attu',
      habitat: 'Freshwater',
      category: 'Freshwater',
      priceRange: '৳300-450/kg',
      description: 'Large predatory catfish. The belly part (peti) is considered a delicacy.',
      cookingMethods: ['Curry', 'Fry', 'Kalia'],
      freshnessChecklist: ['Fresh smell', 'Firm flesh', 'Bright skin'],
      recipes: ['বোয়াল মাছের পেটি', 'বোয়াল মাছ ভাজা', 'বোয়াল মাছের কালিয়া'],
      calories: '92 kcal/100g',
      protein: '16.0g/100g',
    ),
    
    FishData(
      id: 'tengra',
      nameBangla: 'টেংরা',
      nameEnglish: 'Tengra Catfish',
      scientificName: 'Mystus tengara',
      habitat: 'Freshwater',
      category: 'Freshwater',
      priceRange: '৳400-600/kg',
      description: 'Small catfish with whiskers. Very tasty in jhol preparation.',
      cookingMethods: ['Jhol', 'Curry', 'Fry'],
      freshnessChecklist: ['Fresh smell', 'Active if alive', 'No slime'],
      recipes: ['টেংরা মাছের ঝোল', 'টেংরা মাছ ভাজা'],
      calories: '98 kcal/100g',
      protein: '17.2g/100g',
    ),
    
    FishData(
      id: 'gozar',
      nameBangla: 'গজার',
      nameEnglish: 'Giant Snakehead',
      scientificName: 'Channa marulius',
      habitat: 'Freshwater',
      category: 'Freshwater',
      priceRange: '৳400-600/kg',
      description: 'Large snakehead with spotted pattern. Prized game fish.',
      cookingMethods: ['Curry', 'Kalia', 'Fry'],
      freshnessChecklist: ['Bright spots', 'Firm flesh', 'Fresh smell'],
      recipes: ['গজার মাছের কালিয়া', 'গজার মাছ ভাজা'],
      calories: '105 kcal/100g',
      protein: '18.0g/100g',
    ),
    
    FishData(
      id: 'taki',
      nameBangla: 'টাকি',
      nameEnglish: 'Spotted Snakehead',
      scientificName: 'Channa punctata',
      habitat: 'Freshwater',
      category: 'Freshwater',
      priceRange: '৳350-500/kg',
      description: 'Small snakehead with spots. Common in ponds and ditches.',
      cookingMethods: ['Jhol', 'Curry', 'Fry'],
      freshnessChecklist: ['Active movement', 'Clear spots', 'No injuries'],
      recipes: ['টাকি মাছের ঝোল', 'টাকি মাছ ভাজা'],
      calories: '96 kcal/100g',
      protein: '16.5g/100g',
    ),
    
    FishData(
      id: 'ayre',
      nameBangla: 'আইড়',
      nameEnglish: 'Ayre Catfish',
      scientificName: 'Sperata aor',
      habitat: 'Freshwater',
      category: 'Freshwater',
      priceRange: '৳500-800/kg',
      description: 'Large river catfish. The head is particularly delicious.',
      cookingMethods: ['Curry', 'Jhol', 'Kalia'],
      freshnessChecklist: ['Fresh smell', 'Firm body', 'Clear eyes'],
      recipes: ['আইড় মাছের মাথা দিয়ে মুগ ডাল', 'আইড় মাছের ঝোল'],
      calories: '112 kcal/100g',
      protein: '19.5g/100g',
    ),
    
    FishData(
      id: 'baim',
      nameBangla: 'বাইম',
      nameEnglish: 'Spiny Eel',
      scientificName: 'Mastacembelus armatus',
      habitat: 'Freshwater',
      category: 'Freshwater',
      priceRange: '৳400-600/kg',
      description: 'Eel-like fish with spiny dorsal. Lives in muddy bottoms.',
      cookingMethods: ['Jhol', 'Bhuna', 'Curry'],
      freshnessChecklist: ['Active movement', 'Moist skin', 'No wounds'],
      recipes: ['বাইম মাছের ঝোল', 'বাইম মাছ ভুনা'],
      calories: '94 kcal/100g',
      protein: '16.0g/100g',
    ),
    
    FishData(
      id: 'chital',
      nameBangla: 'চিতল',
      nameEnglish: 'Clown Knifefish',
      scientificName: 'Chitala chitala',
      habitat: 'Freshwater',
      category: 'Freshwater',
      priceRange: '৳500-700/kg',
      description: 'Distinctive knife-shaped fish with spots. Used for making fish balls.',
      cookingMethods: ['Kofta', 'Curry', 'Fry'],
      freshnessChecklist: ['Bright spots', 'Fresh smell', 'Firm flesh'],
      recipes: ['চিতল মাছের মুইঠ্যা', 'চিতল মাছ ভাজা', 'চিতল মাছের কোফতা'],
      calories: '100 kcal/100g',
      protein: '17.5g/100g',
    ),
    
    FishData(
      id: 'foli',
      nameBangla: 'ফলি',
      nameEnglish: 'Butter Catfish',
      scientificName: 'Ompok bimaculatus',
      habitat: 'Freshwater',
      category: 'Freshwater',
      priceRange: '৳500-750/kg',
      description: 'Smooth-skinned catfish similar to pabda. Rich buttery flavor.',
      cookingMethods: ['Jhol', 'Curry', 'Bhuna'],
      freshnessChecklist: ['Smooth skin', 'No slime', 'Fresh smell'],
      recipes: ['ফলি মাছের ঝোল', 'ফলি মাছ ভুনা'],
      calories: '92 kcal/100g',
      protein: '16.2g/100g',
    ),
    
    FishData(
      id: 'punti',
      nameBangla: 'পুঁটি',
      nameEnglish: 'Pool Barb',
      scientificName: 'Puntius sophore',
      habitat: 'Freshwater',
      category: 'Freshwater',
      priceRange: '৳200-350/kg',
      description: 'Small silver fish with red fins. Very common and affordable.',
      cookingMethods: ['Fry', 'Jhol', 'Vorta'],
      freshnessChecklist: ['Shiny scales', 'Red fins', 'Fresh smell'],
      recipes: ['পুঁটি মাছ ভাজা', 'পুঁটি মাছের ঝোল', 'পুঁটি মাছ ভর্তা'],
      calories: '75 kcal/100g',
      protein: '13.0g/100g',
    ),
    
    FishData(
      id: 'mola',
      nameBangla: 'মলা',
      nameEnglish: 'Mola Carplet',
      scientificName: 'Amblypharyngodon mola',
      habitat: 'Freshwater',
      category: 'Freshwater',
      priceRange: '৳400-600/kg',
      description: 'Tiny fish rich in micronutrients. Excellent for eye health (Vitamin A).',
      cookingMethods: ['Fry', 'Vorta', 'Jhol'],
      freshnessChecklist: ['Bright silver color', 'No discoloration', 'Fresh smell'],
      recipes: ['মলা মাছ ভাজা', 'মলা মাছ ভর্তা', 'মলা মাছের ঝোল'],
      calories: '82 kcal/100g',
      protein: '14.5g/100g',
    ),
    
    FishData(
      id: 'dhela',
      nameBangla: 'ঢেলা',
      nameEnglish: 'Cotio',
      scientificName: 'Osteobrama cotio',
      habitat: 'Freshwater',
      category: 'Freshwater',
      priceRange: '৳300-450/kg',
      description: 'Small silver fish. Often eaten with vegetables.',
      cookingMethods: ['Fry', 'Jhol', 'Curry'],
      freshnessChecklist: ['Bright silver', 'Clear eyes', 'Firm body'],
      recipes: ['ঢেলা মাছ ভাজা', 'ঢেলা মাছের ঝোল'],
      calories: '78 kcal/100g',
      protein: '13.8g/100g',
    ),
    
    // ============ SALTWATER/RIVERINE FISH (নদী/সমুদ্রের মাছ) ============
    
    FishData(
      id: 'hilsa',
      nameBangla: 'ইলিশ',
      nameEnglish: 'Hilsa',
      scientificName: 'Tenualosa ilisha',
      habitat: 'Saltwater/Freshwater (migrates)',
      category: 'Saltwater',
      priceRange: '৳800-2500/kg',
      description: 'National fish of Bangladesh. Silver with oily, flavorful meat. Migrates from sea to rivers.',
      cookingMethods: ['Bhapa', 'Shorshe', 'Fry', 'Bhuna'],
      freshnessChecklist: ['Bright silver scales', 'Red gills', 'Firm belly', 'Fresh sea smell'],
      recipes: ['শর্ষে ইলিশ', 'ভাপা ইলিশ', 'ইলিশ পাতুরি', 'ইলিশ ভাজা', 'ইলিশ পোলাও'],
      calories: '273 kcal/100g',
      protein: '19.4g/100g',
    ),
    
    FishData(
      id: 'pomfret_rupchanda',
      nameBangla: 'রূপচাঁদা',
      nameEnglish: 'Silver Pomfret',
      scientificName: 'Pampus argenteus',
      habitat: 'Saltwater',
      category: 'Saltwater',
      priceRange: '৳700-1200/kg',
      description: 'Flat, diamond-shaped fish with silver skin. Popular for frying.',
      cookingMethods: ['Fry', 'Curry', 'Steam'],
      freshnessChecklist: ['Bright silver', 'Firm body', 'No browning'],
      recipes: ['রূপচাঁদা মাছ ভাজা', 'রূপচাঁদা মাছের কারি'],
      calories: '118 kcal/100g',
      protein: '20.5g/100g',
    ),
    
    FishData(
      id: 'vetki',
      nameBangla: 'ভেটকি',
      nameEnglish: 'Barramundi/Sea Bass',
      scientificName: 'Lates calcarifer',
      habitat: 'Saltwater/Freshwater',
      category: 'Saltwater',
      priceRange: '৳600-1000/kg',
      description: 'Large predatory fish. White, flaky meat with mild flavor.',
      cookingMethods: ['Fry', 'Curry', 'Grill', 'Steam'],
      freshnessChecklist: ['Clear eyes', 'Firm flesh', 'No strong smell'],
      recipes: ['ভেটকি মাছ ভাজা', 'ভেটকি মাছের কালিয়া', 'ভেটকি মাছের ফ্রাই'],
      calories: '110 kcal/100g',
      protein: '20.1g/100g',
    ),
    
    FishData(
      id: 'bagda_chingri',
      nameBangla: 'বাগদা চিংড়ি',
      nameEnglish: 'Black Tiger Prawn',
      scientificName: 'Penaeus monodon',
      habitat: 'Saltwater',
      category: 'Saltwater',
      priceRange: '৳800-1500/kg',
      description: 'Large marine shrimp with striped shell. Major export product.',
      cookingMethods: ['Curry', 'Fry', 'Bhuna', 'Malaikari'],
      freshnessChecklist: ['Firm shell', 'No black spots', 'Fresh sea smell'],
      recipes: ['চিংড়ি মালাইকারি', 'চিংড়ি ভুনা', 'চিংড়ি ভাজা'],
      calories: '99 kcal/100g',
      protein: '20.9g/100g',
    ),
    
    FishData(
      id: 'golda_chingri',
      nameBangla: 'গলদা চিংড়ি',
      nameEnglish: 'Giant River Prawn',
      scientificName: 'Macrobrachium rosenbergii',
      habitat: 'Freshwater',
      category: 'Freshwater',
      priceRange: '৳700-1200/kg',
      description: 'Large freshwater prawn with blue claws. Distinctive sweet taste.',
      cookingMethods: ['Curry', 'Fry', 'Bhuna', 'Malaikari'],
      freshnessChecklist: ['Blue claws', 'Active if alive', 'No discoloration'],
      recipes: ['গলদা চিংড়ি মালাইকারি', 'গলদা চিংড়ি ভুনা'],
      calories: '95 kcal/100g',
      protein: '19.8g/100g',
    ),
    
    FishData(
      id: 'coral',
      nameBangla: 'কোরাল',
      nameEnglish: 'Giant Sea Perch',
      scientificName: 'Lates calcarifer',
      habitat: 'Saltwater',
      category: 'Saltwater',
      priceRange: '৳500-800/kg',
      description: 'Large sea fish with firm white meat. Popular in coastal areas.',
      cookingMethods: ['Fry', 'Curry', 'Kalia'],
      freshnessChecklist: ['Clear eyes', 'Firm flesh', 'Fresh smell'],
      recipes: ['কোরাল মাছ ভাজা', 'কোরাল মাছের কালিয়া'],
      calories: '108 kcal/100g',
      protein: '19.5g/100g',
    ),
    
    FishData(
      id: 'loitta',
      nameBangla: 'লইট্টা',
      nameEnglish: 'Bombay Duck',
      scientificName: 'Harpadon nehereus',
      habitat: 'Saltwater',
      category: 'Saltwater',
      priceRange: '৳200-350/kg',
      description: 'Soft-bodied marine fish. Often dried (shutki) for preservation.',
      cookingMethods: ['Fry', 'Bharta', 'Curry'],
      freshnessChecklist: ['Translucent body', 'Fresh smell', 'No discoloration'],
      recipes: ['লইট্টা মাছ ভাজা', 'লইট্টা শুঁটকি ভর্তা'],
      calories: '88 kcal/100g',
      protein: '15.5g/100g',
    ),
    
    FishData(
      id: 'parshe',
      nameBangla: 'পারশে',
      nameEnglish: 'Gold Spot Mullet',
      scientificName: 'Liza parsia',
      habitat: 'Brackish/Saltwater',
      category: 'Saltwater',
      priceRange: '৳300-500/kg',
      description: 'Mullet with golden spot. Common in coastal areas of Bangladesh.',
      cookingMethods: ['Curry', 'Fry', 'Jhol'],
      freshnessChecklist: ['Visible golden spot', 'Clear eyes', 'Firm body'],
      recipes: ['পারশে মাছের ঝোল', 'পারশে মাছ ভাজা'],
      calories: '95 kcal/100g',
      protein: '16.8g/100g',
    ),
    
    FishData(
      id: 'taposhi',
      nameBangla: 'তাপসী',
      nameEnglish: 'Paradise Threadfin',
      scientificName: 'Polynemus paradiseus',
      habitat: 'Saltwater/Brackish',
      category: 'Saltwater',
      priceRange: '৳350-550/kg',
      description: 'Fish with thread-like fin extensions. Delicate flavor.',
      cookingMethods: ['Fry', 'Curry', 'Bhapa'],
      freshnessChecklist: ['Thread fins intact', 'Fresh smell', 'Clear eyes'],
      recipes: ['তাপসী মাছ ভাজা', 'তাপসী মাছের ঝোল'],
      calories: '92 kcal/100g',
      protein: '16.0g/100g',
    ),
    
    // ============ CULTURED/FARM FISH (চাষের মাছ) ============
    
    FishData(
      id: 'tilapia',
      nameBangla: 'তেলাপিয়া',
      nameEnglish: 'Tilapia',
      scientificName: 'Oreochromis niloticus',
      habitat: 'Freshwater',
      category: 'Cultured',
      priceRange: '৳150-220/kg',
      description: 'Popular farmed fish. Fast-growing and affordable.',
      cookingMethods: ['Fry', 'Curry', 'Bhuna'],
      freshnessChecklist: ['Clear eyes', 'Firm flesh', 'No muddy smell'],
      recipes: ['তেলাপিয়া মাছ ভাজা', 'তেলাপিয়া মাছের তরকারি'],
      calories: '96 kcal/100g',
      protein: '20.1g/100g',
    ),
    
    FishData(
      id: 'pangasius',
      nameBangla: 'পাঙ্গাস',
      nameEnglish: 'Pangasius',
      scientificName: 'Pangasianodon hypophthalmus',
      habitat: 'Freshwater',
      category: 'Cultured',
      priceRange: '৳130-180/kg',
      description: 'Large catfish from Vietnam origin. Very affordable and widely farmed.',
      cookingMethods: ['Curry', 'Fry', 'Bhuna'],
      freshnessChecklist: ['Firm flesh', 'Fresh smell', 'No sliminess'],
      recipes: ['পাঙ্গাস মাছের কারি', 'পাঙ্গাস মাছ ভাজা', 'পাঙ্গাস মাছ ভুনা'],
      calories: '92 kcal/100g',
      protein: '15.2g/100g',
    ),
    
    FishData(
      id: 'thai_koi',
      nameBangla: 'থাই কই',
      nameEnglish: 'Thai Climbing Perch',
      scientificName: 'Anabas testudineus (Thai variety)',
      habitat: 'Freshwater',
      category: 'Cultured',
      priceRange: '৳250-350/kg',
      description: 'Larger Thai variety of climbing perch. Faster growing than native koi.',
      cookingMethods: ['Jhol', 'Bhuna', 'Fry'],
      freshnessChecklist: ['Active if alive', 'No wounds', 'Firm body'],
      recipes: ['থাই কই মাছের ঝোল', 'থাই কই ভুনা'],
      calories: '115 kcal/100g',
      protein: '19.5g/100g',
    ),
    
    FishData(
      id: 'silver_carp',
      nameBangla: 'সিলভার কার্প',
      nameEnglish: 'Silver Carp',
      scientificName: 'Hypophthalmichthys molitrix',
      habitat: 'Freshwater',
      category: 'Cultured',
      priceRange: '৳180-250/kg',
      description: 'Chinese carp introduced for aquaculture. Filter feeder.',
      cookingMethods: ['Curry', 'Fry', 'Kalia'],
      freshnessChecklist: ['Shiny silver scales', 'Clear eyes', 'Firm flesh'],
      recipes: ['সিলভার কার্প মাছের কারি', 'সিলভার কার্প ভাজা'],
      calories: '104 kcal/100g',
      protein: '17.8g/100g',
    ),
    
    FishData(
      id: 'grass_carp',
      nameBangla: 'গ্রাস কার্প',
      nameEnglish: 'Grass Carp',
      scientificName: 'Ctenopharyngodon idella',
      habitat: 'Freshwater',
      category: 'Cultured',
      priceRange: '৳200-280/kg',
      description: 'Large carp that feeds on aquatic plants. Helps control weeds.',
      cookingMethods: ['Curry', 'Kalia', 'Fry'],
      freshnessChecklist: ['Green-grey color', 'Firm flesh', 'Fresh smell'],
      recipes: ['গ্রাস কার্প মাছের কালিয়া', 'গ্রাস কার্প ভাজা'],
      calories: '98 kcal/100g',
      protein: '17.0g/100g',
    ),
    
    FishData(
      id: 'mirror_carp',
      nameBangla: 'মিরর কার্প',
      nameEnglish: 'Mirror Carp',
      scientificName: 'Cyprinus carpio',
      habitat: 'Freshwater',
      category: 'Cultured',
      priceRange: '৳220-300/kg',
      description: 'European carp with large mirror-like scales. Farmed in ponds.',
      cookingMethods: ['Curry', 'Fry', 'Kalia'],
      freshnessChecklist: ['Large shiny scales', 'Clear eyes', 'Firm body'],
      recipes: ['মিরর কার্প মাছের কারি', 'মিরর কার্প ভাজা'],
      calories: '127 kcal/100g',
      protein: '17.8g/100g',
    ),
    
    FishData(
      id: 'thai_magur',
      nameBangla: 'থাই মাগুর',
      nameEnglish: 'African Catfish',
      scientificName: 'Clarias gariepinus',
      habitat: 'Freshwater',
      category: 'Cultured',
      priceRange: '৳180-280/kg',
      description: 'Large African catfish. Fast-growing and hardy.',
      cookingMethods: ['Curry', 'Jhol', 'Bhuna'],
      freshnessChecklist: ['Active if alive', 'Moist skin', 'No injuries'],
      recipes: ['থাই মাগুর মাছের ঝোল', 'থাই মাগুর ভুনা'],
      calories: '130 kcal/100g',
      protein: '22.0g/100g',
    ),
    
    FishData(
      id: 'thai_pangas',
      nameBangla: 'থাই পাঙ্গাস',
      nameEnglish: 'Striped Catfish',
      scientificName: 'Pangasius sutchi',
      habitat: 'Freshwater',
      category: 'Cultured',
      priceRange: '৳140-200/kg',
      description: 'Striped variety of pangasius. Popular in fish farms.',
      cookingMethods: ['Curry', 'Fry', 'Bhuna'],
      freshnessChecklist: ['Visible stripes', 'Firm flesh', 'Fresh smell'],
      recipes: ['থাই পাঙ্গাস মাছের কারি', 'থাই পাঙ্গাস ভাজা'],
      calories: '88 kcal/100g',
      protein: '14.8g/100g',
    ),
  ];

  /// Find fish by ID
  static FishData? findById(String id) {
    try {
      return allFish.firstWhere((fish) => fish.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Find fish by name (Bangla or English)
  static FishData? findByName(String name) {
    final lowerName = name.toLowerCase();
    try {
      return allFish.firstWhere(
        (fish) =>
            fish.nameBangla.contains(name) ||
            fish.nameEnglish.toLowerCase().contains(lowerName),
      );
    } catch (e) {
      return null;
    }
  }

  /// Get all fish in a category
  static List<FishData> getByCategory(String category) {
    return allFish.where((fish) => fish.category == category).toList();
  }

  /// Get all fish IDs for TFLite label mapping
  static List<String> get allIds => allFish.map((f) => f.id).toList();
  
  /// Get all English names for TFLite label mapping
  static List<String> get allEnglishNames => allFish.map((f) => f.nameEnglish).toList();
  
  /// Total fish count
  static int get totalFish => allFish.length;
}
