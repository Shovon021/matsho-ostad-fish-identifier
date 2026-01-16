import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_colors.dart';
import '../theme/theme_provider.dart';
import 'glass_container.dart';
import '../../features/map/presentation/catch_map_screen.dart';

class GlassDrawer extends ConsumerWidget {
  const GlassDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Drawer(
      backgroundColor: Colors.transparent, // Important for glass effect
      elevation: 0,
      width: 280,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryDark.withAlpha(230),
              AppColors.primaryDark.withAlpha(242),
            ],
          ),
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
          border: Border(
            right: BorderSide(color: Colors.white.withAlpha(25), width: 1),
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 40, 25, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(25),
                        borderRadius: BorderRadius.circular(20),
                        border:
                            Border.all(color: Colors.white.withAlpha(51)),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Image.asset('assets/images/logo.png'),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'মৎস্য ওস্তাদ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Hind Siliguri',
                      ),
                    ),
                    Text(
                      'Version 1.0.0',
                      style: TextStyle(
                        color: Colors.white.withAlpha(127),
                        fontSize: 12,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(color: Colors.white10),

              const SizedBox(height: 10),

              // Menu Items
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _buildMenuItem(
                      context,
                      icon: Icons.home_rounded,
                      labelBn: 'হোম',
                      labelEn: 'Home',
                      onTap: () => Navigator.pop(context),
                      isActive: true,
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.history_rounded,
                      labelBn: 'স্ক্যান ইতিহাস',
                      labelEn: 'Scan History',
                      onTap: () {
                        Navigator.pop(context);
                        // TODO: Navigate to history
                      },
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.map_rounded,
                      labelBn: 'ক্যাচ ম্যাপ',
                      labelEn: 'Catch Map',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CatchMapScreen(),
                          ),
                        );
                      },
                    ),

                    _buildMenuItem(
                      context,
                      icon: Icons.settings_rounded,
                      labelBn: 'সেটিংস',
                      labelEn: 'Settings',
                      onTap: () {
                        Navigator.pop(context);
                        // TODO: Navigate to settings
                      },
                    ),
                    
                    // Theme Selector Section
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: Row(
                        children: [
                          Icon(Icons.palette, color: Colors.white54, size: 18),
                          SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'থিম',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                  fontFamily: 'Hind Siliguri',
                                ),
                              ),
                              Text(
                                'Theme',
                                style: TextStyle(
                                  color: Colors.white38,
                                  fontSize: 8,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    _buildThemeSelector(context, ref),
                    
                    const SizedBox(height: 10),
                    
                    _buildMenuItem(
                      context,
                      icon: Icons.info_outline_rounded,
                      labelBn: 'সম্পর্কে',
                      labelEn: 'About',
                      onTap: () {
                        Navigator.pop(context);
                        showAboutDialog(
                          context: context,
                          applicationName: 'মৎস্য ওস্তাদ',
                          applicationVersion: '1.0.0',
                          applicationIcon: SizedBox(
                            width: 50,
                            height: 50,
                            child: Image.asset('assets/images/logo.png'),
                          ),
                          children: [
                            const Text(
                                'বাংলাদেশের জন্য AI চালিত মাছ শনাক্তকরণ।\nAI Powered Fish Identification for Bangladesh.'),
                          ],
                        );
                      },
                    ),

                  ],
                ),
              ),

              // Footer
              Padding(
                padding: const EdgeInsets.all(25),
                child: GlassContainer(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                  child: Row(
                    children: [
                      const Icon(Icons.shield_outlined,
                          color: AppColors.accentGold, size: 20),
                      const SizedBox(width: 12),
                      Text(
                        'Privacy Policy',
                        style: TextStyle(
                          color: Colors.white.withAlpha(230),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
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

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String labelBn,
    required String labelEn,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15),
          splashColor: Colors.white10,
          highlightColor: Colors.white10,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: isActive
                ? BoxDecoration(
                    color: Colors.white.withAlpha(25),
                    borderRadius: BorderRadius.circular(15),
                  )
                : null,
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isActive ? AppColors.accentGold : Colors.white70,
                  size: 22,
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      labelBn,
                      style: TextStyle(
                        color: isActive ? Colors.white : Colors.white70,
                        fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                        fontSize: 15,
                        fontFamily: 'Hind Siliguri',
                      ),
                    ),
                    Text(
                      labelEn,
                      style: TextStyle(
                        color: Colors.white.withAlpha(120),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

      ),
    );
  }

  Widget _buildThemeSelector(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeProvider);
    final themes = [
      (AppThemeType.ocean, OceanTheme()),
      (AppThemeType.sunset, SunsetTheme()),
      (AppThemeType.forest, ForestTheme()),
    ];
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: themes.map((theme) {
          final isSelected = currentTheme == theme.$1;
          final themeColors = theme.$2;
          
          return GestureDetector(
            onTap: () {
              ref.read(themeProvider.notifier).setTheme(theme.$1);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    themeColors.primaryLight,
                    themeColors.primaryDark,
                  ],
                ),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.white : Colors.white30,
                  width: isSelected ? 3 : 1,
                ),
                boxShadow: isSelected ? [
                  BoxShadow(
                    color: themeColors.primaryLight.withAlpha(100),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ] : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    themeColors.icon,
                    color: Colors.white,
                    size: 18,
                  ),
                  if (isSelected)
                    const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 12,
                    ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
