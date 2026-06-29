import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'routes.dart';
import 'theme.dart';

/// ======================================================
/// GlowScanAI – App Entry Point
/// Initializes Firebase and launches the main app.
/// ======================================================

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  // --------------------------------------------------
  // Firebase Initialization
  // (Manual setup without firebase_options.dart)
  // --------------------------------------------------

  await Firebase.initializeApp();

  runApp(const GlowScanAIApp());
}



/// ======================================================
/// ROOT APPLICATION
/// ======================================================

class GlowScanAIApp extends StatelessWidget {

  const GlowScanAIApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      // --------------------------------------------------
      // BASIC CONFIG
      // --------------------------------------------------

      title: 'GlowScanAI',
      debugShowCheckedModeBanner: false,


      // --------------------------------------------------
      // APP THEME
      // --------------------------------------------------

      theme: glowScanTheme,


      // --------------------------------------------------
      // INITIAL ROUTE
      // Splash → Onboarding → Auth → Dashboard
      // --------------------------------------------------

      initialRoute: AppRoutes.splash,


      // --------------------------------------------------
      // ROUTE GENERATOR
      // --------------------------------------------------

      onGenerateRoute: generateRoute,

    );
  }
}
