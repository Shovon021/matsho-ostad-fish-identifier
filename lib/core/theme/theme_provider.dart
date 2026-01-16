import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

enum AppThemeType { ocean, sunset, forest }

// Theme state notifier
class ThemeNotifier extends StateNotifier<AppThemeType> {
  static const String _themeKey = 'selected_theme';
  
  ThemeNotifier() : super(AppThemeType.ocean) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(_themeKey) ?? 0;
    state = AppThemeType.values[themeIndex];
  }

  Future<void> setTheme(AppThemeType theme) async {
    state = theme;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, theme.index);
  }
}

// Riverpod provider
final themeProvider = StateNotifierProvider<ThemeNotifier, AppThemeType>((ref) {
  return ThemeNotifier();
});

// Get theme colors based on type
ThemeColors getThemeColors(AppThemeType type) {
  switch (type) {
    case AppThemeType.ocean:
      return OceanTheme();
    case AppThemeType.sunset:
      return SunsetTheme();
    case AppThemeType.forest:
      return ForestTheme();
  }
}

// Base class for theme colors
abstract class ThemeColors {
  Color get primaryDark;
  Color get primaryMedium;
  Color get primaryLight;
  Color get accentCoral;
  Color get accentGold;
  Color get backgroundDark;
  String get name;
  String get nameBn;
  IconData get icon;
}

// Ocean Blue Theme (Default - "Nodi")
class OceanTheme extends ThemeColors {
  @override Color get primaryDark => const Color(0xFF004E64);
  @override Color get primaryMedium => const Color(0xFF25A4C4);
  @override Color get primaryLight => const Color(0xFF7AE7C7);
  @override Color get accentCoral => const Color(0xFFFF7B54);
  @override Color get accentGold => const Color(0xFFE4A11B);
  @override Color get backgroundDark => const Color(0xFF0F1C24);
  @override String get name => 'Ocean Blue';
  @override String get nameBn => 'সমুদ্র নীল';
  @override IconData get icon => Icons.water;
}

// Sunset Orange Theme
class SunsetTheme extends ThemeColors {
  @override Color get primaryDark => const Color(0xFF2D1B00);
  @override Color get primaryMedium => const Color(0xFFE65100);
  @override Color get primaryLight => const Color(0xFFFFAB40);
  @override Color get accentCoral => const Color(0xFFFF5252);
  @override Color get accentGold => const Color(0xFFFFD740);
  @override Color get backgroundDark => const Color(0xFF1A1000);
  @override String get name => 'Sunset Orange';
  @override String get nameBn => 'সূর্যাস্ত কমলা';
  @override IconData get icon => Icons.wb_sunny;
}

// Forest Green Theme
class ForestTheme extends ThemeColors {
  @override Color get primaryDark => const Color(0xFF1B3A2F);
  @override Color get primaryMedium => const Color(0xFF2E7D32);
  @override Color get primaryLight => const Color(0xFF81C784);
  @override Color get accentCoral => const Color(0xFFFFB74D);
  @override Color get accentGold => const Color(0xFFAED581);
  @override Color get backgroundDark => const Color(0xFF0D1F17);
  @override String get name => 'Forest Green';
  @override String get nameBn => 'বন সবুজ';
  @override IconData get icon => Icons.forest;
}
