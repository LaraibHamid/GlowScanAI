import 'package:flutter/material.dart';
import 'colors.dart';

class AppText {
  /// Main screen titles
  static const TextStyle heading = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
  );

  /// Section titles / card headers
  static const TextStyle subheading = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );

  /// General body text used across the UI
  static const TextStyle body = TextStyle(
    fontSize: 14.5,
    fontWeight: FontWeight.w400,
    color: AppColors.textLight,
    height: 1.5,
  );

  /// Primary button style
  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );

  /// Small caption text (timestamps, hints, labels)
  static const TextStyle caption = TextStyle(
    fontSize: 12.5,
    color: AppColors.textLight,
  );
}
