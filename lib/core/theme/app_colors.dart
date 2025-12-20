import 'package:flutter/material.dart';

/// App color palette for Yume - Japanese Minimalist theme
abstract final class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF000000);
  static const Color onPrimary = Color(0xFFFFFFFF);

  // Background Colors
  static const Color background = Color(0xFFFFFFFF);
  static const Color onBackground = Color(0xFF000000);

  // Surface Colors
  static const Color surface = Color(0xFFFAFAFA);
  static const Color onSurface = Color(0xFF000000);
  static const Color surfaceVariant = Color(0xFFF5F5F5);

  // Accent - Soft desaturated indigo/slate
  static const Color accent = Color(0xFF6B7280);
  static const Color accentLight = Color(0xFF9CA3AF);

  // Neutral greys for subtle UI elements
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFE5E5E5);
  static const Color grey300 = Color(0xFFD4D4D4);
  static const Color grey400 = Color(0xFFA3A3A3);
  static const Color grey500 = Color(0xFF737373);
  static const Color grey600 = Color(0xFF525252);
  static const Color grey700 = Color(0xFF404040);
  static const Color grey800 = Color(0xFF262626);
  static const Color grey900 = Color(0xFF171717);

  // Functional colors
  static const Color error = Color(0xFFDC2626);
  static const Color success = Color(0xFF059669);

  // Shimmer colors
  static const Color shimmerBase = Color(0xFFF5F5F5);
  static const Color shimmerHighlight = Color(0xFFFFFFFF);

  // ==========================================================================
  // DARK THEME COLORS - Soft Premium Dark (No Pure Black)
  // ==========================================================================

  // Dark Primary Colors
  static const Color darkPrimary = Color(0xFFFFFFFF);
  static const Color darkOnPrimary = Color(0xFF121212); // Soft black text

  // Dark Background Colors - Soft Pastel Charcoal (Not Pure Black)
  static const Color darkBackground = Color(
    0xFF18181B,
  ); // Zinc-900 equivalent (Softer)
  static const Color darkOnBackground = Color(0xFFE4E4E7); // Zinc-200

  // Dark Surface Colors - Slightly lighter pastel slate
  static const Color darkSurface = Color(0xFF27272A); // Zinc-800
  static const Color darkOnSurface = Color(0xFFE4E4E7);
  static const Color darkSurfaceVariant = Color(0xFF3F3F46); // Zinc-700

  // Dark Accent - Pastel Indigo
  static const Color darkAccent = Color(0xFF818CF8); // Indigo-400 (Pastel)
  static const Color darkAccentLight = Color(0xFFD4D4D4);

  // Dark Shimmer colors
  static const Color darkShimmerBase = Color(0xFF2A2A2A);
  static const Color darkShimmerHighlight = Color(0xFF383838);
}
