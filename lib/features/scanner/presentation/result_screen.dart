import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:flutter_tts/flutter_tts.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/fluid_background.dart';
import '../../../core/widgets/glass_container.dart';
import '../../../core/widgets/bubble_splash.dart';

class ResultScreen extends StatefulWidget {
  final String imagePath;
  final String fishNameLocal;
  final String fishNameScientific;
  final String habitat;
  final double confidence;
  final List<String> identificationMarkers;
  final String? description;
  final String calories;
  final String protein;
  final String marketPrice;
  final String cookingMethod;
  final List<String> freshnessChecklist;
  final List<String> recipes;
  final ConfusionBreakerData? confusionBreaker;

  const ResultScreen({
    super.key,
    required this.imagePath,
    required this.fishNameLocal,
    required this.fishNameScientific,
    required this.habitat,
    required this.confidence,
    required this.identificationMarkers,
    this.description,
    this.calories = 'N/A',
    this.protein = 'N/A',
    this.marketPrice = 'N/A',
    this.cookingMethod = 'N/A',
    this.freshnessChecklist = const [],
    this.recipes = const [],
    this.confusionBreaker,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _entranceController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late FlutterTts _flutterTts;
  bool _isSpeaking = false;

  @override
  void initState() {
    super.initState();
    _initTts();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3), // Start 30% down
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeOutBack,
    ));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entranceController, curve: Curves.easeIn),
    );

    // Initial "Splash" delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _entranceController.forward();
    });
  }

  void _initTts() {
    _flutterTts = FlutterTts();
    
    _flutterTts.setStartHandler(() {
      setState(() => _isSpeaking = true);
    });

    _flutterTts.setCompletionHandler(() {
      setState(() => _isSpeaking = false);
    });

    _flutterTts.setErrorHandler((msg) {
      setState(() => _isSpeaking = false);
    });
  }

  Future<void> _speakFishName() async {
    await _flutterTts.setLanguage("bn-BD");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.speak(widget.fishNameLocal);
  }

  void _shareResult() {
    final shareText = '''
🐟 মৎস্য ওস্তাদ - Fish Identified!

📛 ${widget.fishNameLocal}
🔬 ${widget.fishNameScientific}
🌊 Habitat: ${widget.habitat}
✅ Confidence: ${(widget.confidence * 100).toInt()}%

💰 Market Price: ${widget.marketPrice}
👨‍🍳 Cooking: ${widget.cookingMethod}
💪 Protein: ${widget.protein} | Calories: ${widget.calories}

${widget.recipes.isNotEmpty ? '🍛 Recipes: ${widget.recipes.join(", ")}' : ''}

📱 Identified by মৎস্য ওস্তাদ (Matsho Ostad)
#MatshoOstad #BangladeshiFish #FishIdentification
''';
    SharePlus.instance.share(ShareParams(text: shareText, subject: 'মৎস্য ওস্তাদ - ${widget.fishNameLocal}'));
  }


  @override
  void dispose() {
    _entranceController.dispose();
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FluidBackground(
        child: BubbleSplash(
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                // Custom App Bar
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GlassContainer(
                        width: 48,
                        height: 48,
                        padding: EdgeInsets.zero,
                        borderRadius: 14,
                        child: const Icon(Icons.arrow_back_ios_new,
                            color: Colors.white, size: 20),
                        onTap: () => Navigator.pop(context),
                      ),
                      GlassContainer(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        height: 48,
                        borderRadius: 24,
                        child: Row(
                          children: [
                            const Icon(Icons.verified,
                                color: AppColors.accentGold, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              '${(widget.confidence * 100).toInt()}% Match',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Hero Image Card
                            Hero(
                              tag: 'fish_image',
                              child: Container(
                                height: 320,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withAlpha(100),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: kIsWeb
                                      ? Image.network(widget.imagePath,
                                          fit: BoxFit.cover,
                                          width: double.infinity)
                                      : Image.file(File(widget.imagePath),
                                          fit: BoxFit.cover,
                                          width: double.infinity),
                                ),
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Title Section (Modified with Speaker Button)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.fishNameLocal,
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall
                                        ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Hind Siliguri',
                                      shadows: [
                                        Shadow(
                                            color: Colors.black.withAlpha(127),
                                            blurRadius: 10),
                                      ],
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: _speakFishName,
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: _isSpeaking ? AppColors.accentGold : Colors.white.withAlpha(50),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      _isSpeaking ? Icons.volume_up : Icons.volume_up_outlined,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              widget.fishNameScientific,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: AppColors.primaryLight,
                                    fontStyle: FontStyle.italic,
                                  ),
                            ),

                            const SizedBox(height: 24),

                            // Freshness Guide (NEW)
                            if (widget.freshnessChecklist.isNotEmpty) ...[
                              GlassContainer(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.health_and_safety, color: Colors.greenAccent),
                                        const SizedBox(width: 10),
                                        Text(
                                          "Freshness Check",
                                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                              color: Colors.white, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    ...widget.freshnessChecklist.map((tip) => Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.check, color: Colors.greenAccent, size: 16),
                                          const SizedBox(width: 8),
                                          Expanded(child: Text(tip, style: const TextStyle(color: Colors.white70))),
                                        ],
                                      ),
                                    )),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],

                            // Recipes (NEW)
                            if (widget.recipes.isNotEmpty) ...[
                              GlassContainer(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.local_dining, color: Colors.orangeAccent),
                                        const SizedBox(width: 10),
                                        Text(
                                          "Popular Recipes",
                                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                              color: Colors.white, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: widget.recipes.map((recipe) => Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: Colors.orangeAccent.withAlpha(50),
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(color: Colors.orangeAccent.withAlpha(100)),
                                        ),
                                        child: Text(recipe, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                      )).toList(),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],

                            // Identification Markers (Glass List)
                            GlassContainer(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.fingerprint,
                                          color: AppColors.primaryLight),
                                      const SizedBox(width: 8),
                                      Text(
                                        "Identification Markers",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Divider(
                                      color: Colors.white.withAlpha(25),
                                      height: 30),
                                  ...widget.identificationMarkers
                                      .map((marker) => Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 12),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Icon(Icons.check_circle,
                                                    color:
                                                        AppColors.primaryLight,
                                                    size: 16),
                                                const SizedBox(width: 10),
                                                Expanded(
                                                  child: Text(
                                                    marker,
                                                    style: const TextStyle(
                                                        color: Colors.white70,
                                                        height: 1.4),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )),
                                ],
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Market & Kitchen Section
                            GlassContainer(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  _buildInfoRow(
                                    context,
                                    icon: Icons.restaurant_menu,
                                    label: "Cooking",
                                    value: widget.cookingMethod,
                                    color: AppColors.accentGold,
                                  ),
                                  const Divider(color: Colors.white12, height: 24),
                                  _buildInfoRow(
                                    context,
                                    icon: Icons.monetization_on_outlined,
                                    label: "Market Price",
                                    value: widget.marketPrice,
                                    color: Colors.greenAccent,
                                  ),
                                  const Divider(color: Colors.white12, height: 24),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Calories",
                                              style: TextStyle(color: Colors.white54, fontSize: 12),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              widget.calories,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Protein",
                                              style: TextStyle(color: Colors.white54, fontSize: 12),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              widget.protein,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            
                            const SizedBox(height: 24),
                            // Confusion Breaker (If applicable)
                            if (widget.confusionBreaker != null)
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border:
                                      Border.all(color: AppColors.accentCoral),
                                  color: AppColors.accentCoral.withAlpha(25),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                              Icons.warning_amber_rounded,
                                              color: AppColors.accentCoral),
                                          const SizedBox(width: 8),
                                          Text(
                                            "Confusion Breaker",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.copyWith(
                                                    color:
                                                        AppColors.accentCoral,
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      RichText(
                                        text: TextSpan(
                                          style: const TextStyle(
                                              color: Colors.white70,
                                              height: 1.5),
                                          children: [
                                            const TextSpan(
                                                text: "Often confused with "),
                                            TextSpan(
                                              text: widget.confusionBreaker!
                                                  .confusedWith,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const TextSpan(text: ".\n\n"),
                                            TextSpan(
                                                text: widget.confusionBreaker!
                                                    .explanation),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                            const SizedBox(height: 24),

                            // Share & Save Buttons
                            Row(
                                  children: [
                                  Expanded(
                                    child: GlassContainer(
                                      height: 56,
                                      onTap: () => _shareResult(),
                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.share, color: Colors.white),
                                          SizedBox(width: 8),
                                          Text("Share",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: GlassContainer(
                                      height: 56,
                                      onTap: () {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text("Correction submitted! (Learning Mode)"),
                                            backgroundColor: AppColors.accentCoral,
                                          )
                                        );
                                      }, 
                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.edit_note, color: AppColors.accentCoral),
                                          SizedBox(width: 8),
                                          Text("Wrong Fish?",
                                              style: TextStyle(
                                                  color: AppColors.accentCoral,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context,
      {required IconData icon,
      required String label,
      required String value,
      required Color color}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withAlpha(51),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ConfusionBreakerData {
  final String confusedWith;
  final String explanation;

  const ConfusionBreakerData({
    required this.confusedWith,
    required this.explanation,
  });
}
