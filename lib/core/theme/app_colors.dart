import 'package:flutter/material.dart';

class AppColors {
  // Concept 1: "Nodi" (The River) Theme Palette

  // Primary Colors
  static const Color primaryDark =
      Color(0xFF004E64); // Deep River Blue - Authority, Deep Water
  static const Color primaryMedium =
      Color(0xFF25A4C4); // River Surface Blue - Brighter, inviting
  static const Color primaryLight = Color(0xFF7AE7C7); // Shallow Water Teal

  // Accent Colors
  static const Color accentCoral = Color(
      0xFFFF7B54); // Sunrise Orange - Actions, alerts (morning sun on river)
  static const Color accentGold =
      Color(0xFFE4A11B); // Harvest Gold - Secondary highlights

  // Neutral Colors (The "Polimati" or Silt influence)
  static const Color backgroundLight =
      Color(0xFFEAE7DC); // Polimati Beige - Earthy, grounded background
  static const Color backgroundDark = Color(0xFF0F1C24); // Deep River Night
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1B2A36);
  static const Color hilsaSilver =
      Color(0xFFE6E6EA); // Hilsa Silver - Cards, secondary backgrounds

  // Text Colors
  static const Color textPrimaryLight =
      Color(0xFF003D4D); // Dark Blue text for contrast on beige
  static const Color textSecondaryLight = Color(0xFF536B78);
  static const Color textPrimaryDark =
      Color(0xFFEAE7DC); // Beige text on dark mode
  static const Color textSecondaryDark = Color(0xFFAAB8C2);

  // Gradients
  static const LinearGradient oceanGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryDark, Color(0xFF002A38)], // Deep mystery
  );

  static const LinearGradient riverGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF004E64), Color(0xFF00384A)],
  );

  static const LinearGradient glassGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0x99FFFFFF),
      Color(0x33FFFFFF),
    ],
  );
}
