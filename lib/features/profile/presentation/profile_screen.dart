import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/fluid_background.dart';
import '../../../core/widgets/glass_container.dart';
import '../../history/data/history_repository.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final HistoryRepository _historyRepo = HistoryRepository();
  int _totalScans = 0;
  int _uniqueSpecies = 0;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final scans = await _historyRepo.getRecentScans();
    final uniqueNames = scans.map((s) => s.fishLocalName).toSet();
    
    if (mounted) {
      setState(() {
        _totalScans = scans.length;
        _uniqueSpecies = uniqueNames.length;
      });
    }
  }

  String _getLevelTitle() {
    if (_totalScans > 50) return "Master Angler (ওস্তাদ)";
    if (_totalScans > 20) return "Expert Fisher";
    if (_totalScans > 5) return "Fish Enthusiast";
    return "Novice Scanner";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FluidBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    GlassContainer(
                      width: 48,
                      height: 48,
                      padding: EdgeInsets.zero,
                      borderRadius: 14,
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Avatar Section
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.accentGold, width: 4),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.accentGold.withAlpha(50),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                          image: const DecorationImage(
                            image: AssetImage('assets/images/logo.png'), // Placeholder
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Guest User",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Hind Siliguri',
                        ),
                      ),
                      Text(
                        _getLevelTitle(),
                        style: const TextStyle(
                          color: AppColors.accentGold,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Stats Grid
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              "Total Scans",
                              "$_totalScans",
                              Icons.qr_code_scanner,
                              Colors.blueAccent,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildStatCard(
                              "Species Found",
                              "$_uniqueSpecies",
                              Icons.phishing, // Use phishing icon for fish/species
                              Colors.greenAccent,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 30),
                      
                      GlassContainer(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             Text(
                              "Achievements",
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildAchievementRow(
                              "First Catch",
                              "Scan your first fish",
                              _totalScans > 0,
                            ),
                            _buildAchievementRow(
                              "Collector",
                              "Find 5 different species",
                              _uniqueSpecies >= 5,
                            ),
                            _buildAchievementRow(
                              "Master",
                              "Scan 50 times",
                              _totalScans >= 50,
                            ),
                          ],
                        ),
                      ),
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

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return GlassContainer(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementRow(String title, String subtitle, bool unlocked) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: unlocked ? AppColors.accentGold.withAlpha(50) : Colors.white10,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.emoji_events,
              color: unlocked ? AppColors.accentGold : Colors.white30,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: unlocked ? Colors.white : Colors.white54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white30, fontSize: 12),
                ),
              ],
            ),
          ),
          if (unlocked)
            const Icon(Icons.check_circle, color: Colors.greenAccent, size: 16),
        ],
      ),
    );
  }
}
