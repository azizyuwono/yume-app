import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:yume_app/core/theme/app_colors.dart';

/// Text styles for Yume app
/// Header Font: Cinzel (elegant, dreamy feel) - BOLDER weights
/// Body Font: Inter (clean readability) - Medium weights for clarity
abstract final class AppTextStyles {
  // Display - Large headers (bolder for impact)
  static TextStyle displayLarge = GoogleFonts.cinzel(
    fontSize: 57,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.5,
    height: 1.2,
    color: AppColors.onBackground,
  );

  static TextStyle displayMedium = GoogleFonts.cinzel(
    fontSize: 45,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.2,
    height: 1.2,
    color: AppColors.onBackground,
  );

  static TextStyle displaySmall = GoogleFonts.cinzel(
    fontSize: 36,
    fontWeight: FontWeight.w500,
    letterSpacing: 1,
    height: 1.25,
    color: AppColors.onBackground,
  );

  // Headlines (increased weights)
  static TextStyle headlineLarge = GoogleFonts.cinzel(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.8,
    height: 1.3,
    color: AppColors.onBackground,
  );

  static TextStyle headlineMedium = GoogleFonts.cinzel(
    fontSize: 28,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.3,
    color: AppColors.onBackground,
  );

  static TextStyle headlineSmall = GoogleFonts.cinzel(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.3,
    height: 1.35,
    color: AppColors.onBackground,
  );

  // Titles (medium weight for clarity)
  static TextStyle titleLarge = GoogleFonts.inter(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
    height: 1.4,
    color: AppColors.onBackground,
  );

  static TextStyle titleMedium = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    height: 1.5,
    color: AppColors.onBackground,
  );

  static TextStyle titleSmall = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.5,
    color: AppColors.onBackground,
  );

  // Body text (w500 for better readability)
  static TextStyle bodyLarge = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.3,
    height: 1.6,
    color: AppColors.onBackground,
  );

  static TextStyle bodyMedium = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.2,
    height: 1.55,
    color: AppColors.onBackground,
  );

  static TextStyle bodySmall = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.2,
    height: 1.5,
    color: AppColors.onBackground,
  );

  // Labels (w600 for emphasis)
  static TextStyle labelLarge = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.4,
    color: AppColors.onBackground,
  );

  static TextStyle labelMedium = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.4,
    height: 1.4,
    color: AppColors.onBackground,
  );

  static TextStyle labelSmall = GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
    height: 1.4,
    color: AppColors.onBackground,
  );
}
