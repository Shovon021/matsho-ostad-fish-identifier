import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTypography {
  static TextTheme get lightTextTheme => TextTheme(
        displayLarge: GoogleFonts.poppins(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimaryLight,
          height: 1.2,
        ),
        displayMedium: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimaryLight,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimaryLight,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: AppColors.textPrimaryLight,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: AppColors.textSecondaryLight,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppColors.surfaceWhite,
          letterSpacing: 0.5,
        ),
      );

  static TextTheme get darkTextTheme => lightTextTheme.copyWith(
        displayLarge: lightTextTheme.displayLarge
            ?.copyWith(color: AppColors.textPrimaryDark),
        displayMedium: lightTextTheme.displayMedium
            ?.copyWith(color: AppColors.textPrimaryDark),
        titleLarge: lightTextTheme.titleLarge
            ?.copyWith(color: AppColors.textPrimaryDark),
        bodyLarge: lightTextTheme.bodyLarge
            ?.copyWith(color: AppColors.textPrimaryDark),
        bodyMedium: lightTextTheme.bodyMedium
            ?.copyWith(color: AppColors.textSecondaryDark),
      );
}
