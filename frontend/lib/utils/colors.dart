import 'package:flutter/material.dart';

/// ======================================================
/// GlowScanAI — Centralized Color System
/// Use these colors across the entire app for consistency.
/// Example:
/// Container(color: AppColors.primary)
/// ======================================================

class AppColors {

  const AppColors._(); // Prevents creating instances

  // ======================================================
  // BRAND COLORS
  // ======================================================

  /// Main brand color used for buttons, highlights etc.
  static const Color primary = Color(0xFFFB6F92);

  /// Soft accent background color
  static const Color secondary = Color(0xFFFFE6EB);


  // ======================================================
  // BACKGROUND COLORS
  // ======================================================

  /// Main app background
  static const Color background = Color(0xFFFDF6F0);

  /// Pure white surface color
  static const Color white = Colors.white;


  // ======================================================
  // TEXT COLORS
  // ======================================================

  /// Primary text color
  static const Color textDark = Color(0xFF333333);

  /// Secondary / muted text color
  static const Color textLight = Color(0xFF888888);


  // ======================================================
  // STATUS COLORS
  // ======================================================

  /// Success messages / positive states
  static const Color success = Color(0xFF6DD47E);

  /// Error messages / warnings
  static const Color error = Color(0xFFE57373);

}
