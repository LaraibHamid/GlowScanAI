import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../routes.dart';
import '../../constants.dart';

// =============================================
// GlowScanAI Onboarding Screen 1
// Introduces AI Skin Scanning Feature
// =============================================

class Onboarding1 extends StatefulWidget {
  const Onboarding1({super.key});

  @override
  State<Onboarding1> createState() => _Onboarding1State();
}

class _Onboarding1State extends State<Onboarding1>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    // Fade animation
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    // Slide animation
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Navigation helper
  void navigate(String route) {
    Navigator.pushReplacementNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: GestureDetector(

        // Swipe navigation
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity == null) return;

          if (details.primaryVelocity! < 0) {
            navigate(AppRoutes.onboarding2);
          } else if (details.primaryVelocity! > 0) {
            navigate(AppRoutes.splash);
          }
        },

        child: Container(
          width: double.infinity,
          height: double.infinity,

          // Background gradient
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.background,
                AppColors.secondary.withOpacity(0.7),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),

          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),

              child: Column(
                children: [

                  const SizedBox(height: 10),

                  // =============================
                  // Skip Button
                  // =============================
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => navigate(AppRoutes.login),

                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),

                      child: Text(
                        "Skip",
                        style: GoogleFonts.poppins(
                          color: AppColors.textDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // =============================
                  // Main Animated Content
                  // =============================
                  Expanded(
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (_, child) {

                        return Opacity(
                          opacity: _fadeAnimation.value,
                          child: SlideTransition(
                            position: _slideAnimation,
                            child: child,
                          ),
                        );
                      },

                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          // Illustration
                          _buildIllustration(size),

                          const SizedBox(height: 38),

                          // Title
                          _buildTitle(),

                          const SizedBox(height: 12),

                          // Description
                          _buildDescription(size),

                          const SizedBox(height: 40),

                          // Progress Indicators
                          _buildProgressDots(),

                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),

                  // =============================
                  // Bottom Swipe Hint
                  // =============================
                  Padding(
                    padding: const EdgeInsets.only(bottom: 22),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 17,
                          color: AppColors.textLight.withOpacity(0.5),
                        ),

                        const SizedBox(width: 10),

                        Text(
                          "Swipe to continue",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: AppColors.textLight,
                          ),
                        ),

                        const SizedBox(width: 10),

                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 17,
                          color: AppColors.textLight.withOpacity(0.5),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // =============================================
  // Illustration Widget
  // =============================================

  Widget _buildIllustration(Size size) {

    return Container(
      width: size.width * 0.55,
      height: size.width * 0.55,

      decoration: BoxDecoration(
        shape: BoxShape.circle,

        gradient: const LinearGradient(
          colors: [
            AppColors.primary,
            Color(0xFFFFB3C6),
          ],
        ),

        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.25),
            blurRadius: 22,
            offset: const Offset(0, 12),
          )
        ],
      ),

      child: const Icon(
        Icons.camera_alt_rounded,
        color: Colors.white,
        size: 90,
      ),
    );
  }

  // =============================================
  // Title
  // =============================================

  Widget _buildTitle() {

    return Text(
      "AI Skin Scanning",
      textAlign: TextAlign.center,

      style: GoogleFonts.poppins(
        fontSize: 28,
        color: AppColors.textDark,
        fontWeight: FontWeight.w700,
        height: 1.2,
      ),
    );
  }

  // =============================================
  // Description
  // =============================================

  Widget _buildDescription(Size size) {

    return SizedBox(
      width: size.width * 0.8,

      child: Text(
        "Advanced AI analyzes your skin for acne, pigmentation, dryness and more — instantly & accurately.",

        textAlign: TextAlign.center,

        style: GoogleFonts.poppins(
          color: AppColors.textLight,
          fontSize: 15,
          height: 1.6,
        ),
      ),
    );
  }

  // =============================================
  // Progress Indicators
  // =============================================

  Widget _buildProgressDots() {

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _dot(true),
        const SizedBox(width: 10),
        _dot(false),
        const SizedBox(width: 10),
        _dot(false),
        const SizedBox(width: 10),
        _dot(false),
      ],
    );
  }

  // =============================================
  // Single Dot
  // =============================================

  Widget _dot(bool active) {

    return AnimatedContainer(
      duration: const Duration(milliseconds: 280),
      width: active ? 28 : 10,
      height: 10,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),

        gradient: active
            ? const LinearGradient(
          colors: [
            AppColors.primary,
            Color(0xFFFFB3C6),
          ],
        )
            : null,

        color: active ? null : AppColors.textLight.withOpacity(0.25),
      ),
    );
  }
}
