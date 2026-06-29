import 'dart:io';
import 'package:flutter/material.dart';

/// ======================================================
/// GlowScanAI – App Routes
/// Handles navigation across the entire application.
/// ======================================================



// ======================================================
// DERMAID MODULE
// ======================================================

import 'screens/splash_screen.dart';

import 'screens/onboarding/onboarding1.dart';
import 'screens/onboarding/onboarding2.dart';
import 'screens/onboarding/onboarding3.dart';
import 'screens/onboarding/onboarding4.dart';

import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/auth/forgot_password_screen.dart';

import 'screens/profile_setup_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';



// ======================================================
// SKINSENSE MODULE
// ======================================================

import 'screens/skinsense/scan_selection_screen.dart';
import 'screens/skinsense/camera_screen.dart';
import 'screens/skinsense/preview_screen.dart';
import 'screens/skinsense/analysis_screen.dart';



// ======================================================
// CUREGEN MODULE
// ======================================================

import 'screens/curegen/routine_screen.dart';
import 'screens/curegen/routine_detail_screen.dart';



// ======================================================
// SKINTRACK MODULE
// ======================================================

import 'screens/skintrack/log_screen.dart';
import 'screens/skintrack/scan_history_screen.dart';



// ======================================================
// GLOWMATE MODULE
// ======================================================

import 'screens/glowmate/chatbot_screen.dart';



// ======================================================
// SETTINGS MODULE
// ======================================================

import 'screens/settings/profile_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'screens/settings/privacy_policy_screen.dart';
import 'screens/settings/terms_conditions_screen.dart';
import 'screens/settings/help_support_screen.dart';
import 'screens/settings/about_screen.dart';



// ======================================================
// MISC SCREENS
// ======================================================

import 'screens/misc/no_internet_screen.dart';
import 'screens/misc/error_screen.dart';
import 'screens/misc/empty_state_screen.dart';



// ======================================================
// ROUTE NAMES
// ======================================================

class AppRoutes {

  const AppRoutes._();

  static const splash = '/';

  // Onboarding
  static const onboarding1 = '/onboarding1';
  static const onboarding2 = '/onboarding2';
  static const onboarding3 = '/onboarding3';
  static const onboarding4 = '/onboarding4';

  // Auth
  static const login = '/login';
  static const signup = '/signup';
  static const forgotPassword = '/forgotPassword';

  // Profile
  static const profileSetup = '/profileSetup';

  // Dashboard
  static const dashboard = '/dashboard';

  // SkinSense
  static const scanSelection = '/scanSelection';
  static const camera = '/camera';
  static const preview = '/preview';
  static const analysis = '/analysis';

  // CureGen
  static const routines = '/routines';
  static const routineDetail = '/routineDetail';

  // SkinTrack
  static const log = '/log';
  static const history = '/history';

  // GlowMate
  static const chatbot = '/chatbot';

  // Settings
  static const profile = '/profile';
  static const settings = '/settings';
  static const privacyPolicy = '/privacyPolicy';
  static const termsConditions = '/termsConditions';
  static const helpSupport = '/helpSupport';
  static const about = '/about';

  // Misc
  static const noInternet = '/noInternet';
  static const error = '/error';
  static const emptyState = '/emptyState';

}



// ======================================================
// ROUTE GENERATOR
// ======================================================

Route<dynamic> generateRoute(RouteSettings settings) {

  switch (settings.name) {

  // --------------------------------------------------
  // SPLASH & ONBOARDING
  // --------------------------------------------------

    case AppRoutes.splash:
      return _route(const SplashScreen(), settings);

    case AppRoutes.onboarding1:
      return _route(const Onboarding1(), settings);

    case AppRoutes.onboarding2:
      return _route(const Onboarding2(), settings);

    case AppRoutes.onboarding3:
      return _route(const Onboarding3(), settings);

    case AppRoutes.onboarding4:
      return _route(const Onboarding4(), settings);



  // --------------------------------------------------
  // AUTH
  // --------------------------------------------------

    case AppRoutes.login:
      return _route(const LoginScreen(), settings);

    case AppRoutes.signup:
      return _route(const SignupScreen(), settings);

    case AppRoutes.forgotPassword:
      return _route(const ForgotPasswordScreen(), settings);



  // --------------------------------------------------
  // PROFILE
  // --------------------------------------------------

    case AppRoutes.profileSetup:
      return _route(const ProfileSetupScreen(), settings);



  // --------------------------------------------------
  // DASHBOARD
  // --------------------------------------------------

    case AppRoutes.dashboard:
      return _route(const DashboardScreen(), settings);



  // --------------------------------------------------
  // SKINSENSE
  // --------------------------------------------------

    case AppRoutes.scanSelection:
      return _route(const ScanSelectionScreen(), settings);

    case AppRoutes.camera:
      return _route(const CameraScreen(), settings);

    case AppRoutes.preview:

      final image = settings.arguments as File;

      return _route(
        PreviewScreen(image: image),
        settings,
      );

    case AppRoutes.analysis:

      final result = settings.arguments as Map<String, dynamic>;

      return _route(
        AnalysisScreen(result: result),
        settings,
      );



  // --------------------------------------------------
  // CUREGEN
  // --------------------------------------------------

    case AppRoutes.routines:
      return _route(const RoutineScreen(), settings);

    case AppRoutes.routineDetail:

      final routine = settings.arguments as Map<String, dynamic>;

      return _route(
        RoutineDetailScreen(routine: routine),
        settings,
      );



  // --------------------------------------------------
  // SKINTRACK
  // --------------------------------------------------

    case AppRoutes.log:
      return _route(const LogScreen(), settings);

    case AppRoutes.history:
      return _route(const ScanHistoryScreen(), settings);



  // --------------------------------------------------
  // GLOWMATE
  // --------------------------------------------------

    case AppRoutes.chatbot:
      return _route(const ChatbotScreen(), settings);



  // --------------------------------------------------
  // SETTINGS
  // --------------------------------------------------

    case AppRoutes.profile:
      return _route(const ProfileScreen(), settings);

    case AppRoutes.settings:
      return _route(const SettingsScreen(), settings);

    case AppRoutes.privacyPolicy:
      return _route(const PrivacyPolicyScreen(), settings);

    case AppRoutes.termsConditions:
      return _route(const TermsConditionsScreen(), settings);

    case AppRoutes.helpSupport:
      return _route(const HelpSupportScreen(), settings);

    case AppRoutes.about:
      return _route(const AboutScreen(), settings);



  // --------------------------------------------------
  // MISC
  // --------------------------------------------------

    case AppRoutes.noInternet:
      return _route(const NoInternetScreen(), settings);

    case AppRoutes.error:
      return _route(const ErrorScreen(), settings);

    case AppRoutes.emptyState:
      return _route(
        const EmptyStateScreen(
          title: "No Data Found",
          message: "You don't have any records yet.",
          icon: Icons.hourglass_empty,
        ),
        settings,
      );



  // --------------------------------------------------
  // DEFAULT
  // --------------------------------------------------

    default:
      return _route(
        const ErrorScreen(message: "Page not found"),
        settings,
      );
  }
}



// ======================================================
// PAGE TRANSITION
// ======================================================

PageRouteBuilder _route(Widget page, RouteSettings settings) {

  return PageRouteBuilder(

    settings: settings,

    pageBuilder: (_, animation, __) {

      return FadeTransition(

        opacity: animation,

        child: SlideTransition(

          position: Tween(
            begin: const Offset(0, 0.05),
            end: Offset.zero,
          ).animate(animation),

          child: page,
        ),
      );
    },

    transitionDuration: const Duration(milliseconds: 300),
  );
}
