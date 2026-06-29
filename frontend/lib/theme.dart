// lib/theme/glow_scan_theme.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';

/// ======================================================
/// GlowScanAI – Global App Theme
/// Provides consistent UI styling across the application.
/// ======================================================

final ThemeData glowScanTheme = ThemeData(

  // -----------------------------------------------------
  // MATERIAL SETTINGS
  // -----------------------------------------------------

  useMaterial3: true,


  // -----------------------------------------------------
  // BACKGROUND
  // -----------------------------------------------------

  scaffoldBackgroundColor: AppColors.background,


  // -----------------------------------------------------
  // COLOR SCHEME
  // -----------------------------------------------------

  colorScheme: const ColorScheme.light(
    primary: AppColors.primary,
    secondary: AppColors.secondary,
    surface: AppColors.white,
    onPrimary: AppColors.white,
    onSecondary: AppColors.textDark,
  ),


  // -----------------------------------------------------
  // GLOBAL FONT
  // -----------------------------------------------------

  fontFamily: GoogleFonts.poppins().fontFamily,


  // -----------------------------------------------------
  // APP BAR
  // -----------------------------------------------------

  appBarTheme: AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    centerTitle: true,
    foregroundColor: AppColors.textDark,

    titleTextStyle: GoogleFonts.outfit(
      color: AppColors.textDark,
      fontWeight: FontWeight.w700,
      fontSize: 20,
      height: 1.2,
    ),
  ),


  // -----------------------------------------------------
  // TEXT THEME
  // -----------------------------------------------------

  textTheme: GoogleFonts.poppinsTextTheme().copyWith(
    bodyLarge: AppText.body,
    bodyMedium: AppText.body,
    titleLarge: AppText.heading,
    titleMedium: AppText.subheading,
  ),


  // -----------------------------------------------------
  // ELEVATED BUTTON
  // -----------------------------------------------------

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.white,
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 24,
      ),
      elevation: 4,
      shadowColor: AppColors.primary.withOpacity(0.3),
      textStyle: AppText.button,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadii.medium),
      ),
    ),
  ),


  // -----------------------------------------------------
  // INPUT FIELDS
  // -----------------------------------------------------

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.white,

    hintStyle: GoogleFonts.poppins(
      color: AppColors.textLight,
    ),

    contentPadding: const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 16,
    ),

    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadii.medium),
      borderSide: BorderSide.none,
    ),

    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadii.medium),
      borderSide: const BorderSide(
        color: AppColors.secondary,
        width: 1,
      ),
    ),

    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadii.medium),
      borderSide: const BorderSide(
        color: AppColors.primary,
        width: 2,
      ),
    ),
  ),


  // -----------------------------------------------------
  // CARD THEME
  // -----------------------------------------------------

  cardTheme: CardThemeData(
    color: AppColors.white,
    elevation: 2,
    shadowColor: Colors.black.withOpacity(0.1),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadii.medium),
    ),
  ),

);
