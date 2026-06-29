import 'package:flutter/material.dart';

/// ======================================================
/// GlowScanAI – Centralized Design System
/// ------------------------------------------------------
/// Contains colors, spacing, radii, shadows, and text
/// styles used across the entire application.
/// ======================================================



// ======================================================
// COLORS
// ======================================================

class AppColors {

  const AppColors._();

  // Brand Colors
  static const Color primary = Color(0xFFFB6F92);
  static const Color secondary = Color(0xFFFFE6EB);
  static const Color accent = Color(0xFFFFC1CC);

  // Background
  static const Color background = Color(0xFFFDF6F0);
  static const Color white = Colors.white;

  // Text
  static const Color textDark = Color(0xFF2D2D2D);
  static const Color textLight = Color(0xFF7A7A7A);

  // Status
  static const Color success = Color(0xFF8ACB88);
  static const Color error = Color(0xFFE57373);
}



// ======================================================
// BORDER RADII
// ======================================================

class AppRadii {

  const AppRadii._();

  static const double small = 8;
  static const double medium = 12;
  static const double large = 16;
  static const double xlarge = 24;

}



// ======================================================
// SPACING SYSTEM
// ======================================================

class AppSpacing {

  const AppSpacing._();

  static const double xs = 6;
  static const double sm = 12;
  static const double md = 18;
  static const double lg = 24;
  static const double xl = 32;

}



// ======================================================
// SHADOWS
// ======================================================

class AppShadows {

  const AppShadows._();

  static const List<BoxShadow> soft = [

    BoxShadow(
      color: Colors.black12,
      blurRadius: 10,
      offset: Offset(0, 4),
    ),

  ];
}



// ======================================================
// TYPOGRAPHY
// ======================================================

class AppText {

  const AppText._();

  static const TextStyle heading = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
    height: 1.3,
  );

  static const TextStyle subheading = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textDark,
    height: 1.3,
  );

  static const TextStyle body = TextStyle(
    fontSize: 14,
    color: AppColors.textLight,
    height: 1.4,
  );

  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );

}
