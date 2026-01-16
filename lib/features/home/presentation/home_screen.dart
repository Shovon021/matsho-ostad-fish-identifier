import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/fluid_background.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/widgets/glass_drawer.dart';
import '../../scanner/presentation/scanner_screen.dart';
import '../../history/data/history_repository.dart';
import '../../history/presentation/aquarium_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;
  final HistoryRepository _historyRepository = HistoryRepository();

  // Real Stats
  int _totalScans = 0;
  int _uniqueSpecies = 0;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration:
          const Duration(milliseconds: 1500), // Slower, more organic pulse
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      // Subtle pulse
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOutSine),
    );

    _loadRealStats();
  }

  Future<void> _loadRealStats() async {
    final scans = await _historyRepository.getScanCount();
    final species = await _historyRepository.getUniqueSpeciesCount();
    if (mounted) {
      setState(() {
        _totalScans = scans;
        _uniqueSpecies = species;
      });
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const GlassDrawer(),
      body: FluidBackground(
        // New Animated Background
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        // Logo
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(20),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Image.asset('assets/images/logo.png'),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'মৎস্য ওস্তাদ',
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium
                                  ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Hind Siliguri',
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withAlpha(50),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              'MATSHO OSTAD',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    color: Colors.white.withAlpha(200),
                                    letterSpacing: 2.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    GlassContainer(
                      // Menu Button
                      width: 48,
                      height: 48,
                      padding: EdgeInsets.zero,
                      borderRadius: 14,
                      child: const Icon(Icons.menu, color: Colors.white),
                      onTap: () {
                        _scaffoldKey.currentState?.openDrawer();
                      },
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      // Dashboard Stats (Glassmorphic)
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              context,
                              labelBn: 'মোট স্ক্যান',
                              labelEn: 'Total Scans',
                              value: '$_totalScans',
                              icon: Icons.qr_code_scanner,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const AquariumScreen()),
                                );
                              },
                              child: _buildStatCard(
                                context,
                                labelBn: 'আমার মাছঘর',
                                labelEn: 'My Aquarium',
                                value: '$_uniqueSpecies',
                                icon: Icons.set_meal,
                                color: AppColors.accentGold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 40),

                      // Main Scanner Button (Central & Glowing)
                      GestureDetector(
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const ScannerScreen()),
                          );
                          _loadRealStats();
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Outer Glow
                            ScaleTransition(
                              scale: _scaleAnimation,
                              child: Container(
                                width: 220,
                                height: 220,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [
                                      AppColors.primaryLight.withAlpha(50),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // Secondary Glow Ring
                            Positioned.fill(
                              child: Container(
                                width: 200,
                                height: 200,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.accentGold.withAlpha(80),
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.accentGold.withAlpha(40),
                                      blurRadius: 30,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Glass Button
                            GlassContainer(
                              width: 180,
                              height: 180,
                              borderRadius: 90,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withAlpha(30),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.primaryLight.withAlpha(50),
                                          blurRadius: 15,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt_rounded,
                                      size: 48,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  const Column(
                                    children: [
                                      Text(
                                        'স্ক্যান',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Hind Siliguri',
                                        ),
                                      ),
                                      Text(
                                        'SCAN',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 10,
                                          letterSpacing: 2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),
                      Column(
                        children: [
                          Text(
                            'মাছ চিনতে ট্যাপ করুন',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.white,
                                  fontFamily: 'Hind Siliguri',
                                ),
                          ),
                          Text(
                            'Tap to identify species',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.white.withAlpha(150),
                                  letterSpacing: 0.5,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 50),

                      // Feature Cards (Glass)
                      _buildFeatureCard(
                        context,
                        icon: Icons.lightbulb_outline,
                        titleBn: 'বিভ্রান্তি ভাঙুন',
                        titleEn: 'Confusion Breaker',
                        descriptionBn: 'বৈজ্ঞানিক পার্থক্য শিখুন',
                        descriptionEn: 'Learn scientific differences',
                        color: AppColors.accentCoral,
                      ),
                      const SizedBox(height: 16),
                      // Mock "Fact of the Day"
                      GlassContainer(
                        width: double.infinity,
                        height: 90,
                        // Fixed height for GlassmorphicContainer usually preferred
                        child: Row(
                          children: [
                            Icon(Icons.auto_stories,
                                color: Colors.white.withAlpha(200), size: 28),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'দৈনিক তথ্য',
                                    style: TextStyle(
                                      color: AppColors.accentGold,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      fontFamily: 'Hind Siliguri',
                                    ),
                                  ),
                                  const Text(
                                    'DAILY FACT',
                                    style: TextStyle(
                                      color: AppColors.accentGold,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 8,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'ইলিশ ডিম পাড়তে সমুদ্র থেকে নদীতে আসে।',
                                    style: TextStyle(
                                        color: Colors.white.withAlpha(220),
                                        fontSize: 12,
                                        fontFamily: 'Hind Siliguri'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String labelBn,
    required String labelEn,
    required String value,
    required IconData icon,
    Color color = AppColors.primaryLight,
  }) {
    return GlassContainer(
      height: 110,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const Spacer(),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            labelBn,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: 'Hind Siliguri',
            ),
          ),
          Text(
            labelEn,
            style: TextStyle(
              color: Colors.white.withAlpha(150),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required String titleBn,
    required String titleEn,
    required String descriptionBn,
    required String descriptionEn,
    required Color color,
  }) {
    return GlassContainer(
      height: 110,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withAlpha(51),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withAlpha(80)),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  titleBn,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Hind Siliguri',
                      ),
                ),
                Text(
                  titleEn,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white.withAlpha(150),
                        fontSize: 10,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  descriptionBn,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white.withAlpha(200),
                        fontFamily: 'Hind Siliguri',
                      ),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios,
              color: Colors.white.withAlpha(50), size: 16),
        ],
      ),
    );
  }
}

