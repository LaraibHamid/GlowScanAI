import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    _fade = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _scale = Tween<double>(begin: 0.85, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _startFlow();
  }

  // =========================================================
  // START APP FLOW
  // =========================================================

  Future<void> _startFlow() async {

    await _controller.forward();

    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      Navigator.pushReplacementNamed(context, AppRoutes.onboarding1);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // =========================================================
  // UI
  // =========================================================

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Container(

        decoration: const BoxDecoration(

          gradient: LinearGradient(

            colors: [
              Color(0xFFFF6B9D),
              Color(0xFFFF8FAC),
              Color(0xFFFFB9D2),
            ],

            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: Center(

          child: FadeTransition(

            opacity: _fade,

            child: ScaleTransition(

              scale: _scale,

              child: Column(

                mainAxisAlignment: MainAxisAlignment.center,

                children: [

                  // LOGO

                  Container(

                    width: 120,
                    height: 120,

                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),

                    child: ClipRRect(

                      borderRadius: BorderRadius.circular(24),

                      child: Image.asset(
                        "assets/images/logo.jpeg",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // APP NAME

                  Text(

                    "GlowScanAI",

                    style: GoogleFonts.outfit(

                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // TAGLINE

                  Container(

                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 8,
                    ),

                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.25),
                      borderRadius: BorderRadius.circular(18),
                    ),

                    child: Text(

                      "Your AI-Powered Skin Companion",

                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 12.5,
                      ),
                    ),
                  ),

                  const SizedBox(height: 50),

                  const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.7,
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
