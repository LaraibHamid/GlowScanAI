import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../routes.dart';
import '../../constants.dart';

// =============================================
// GlowScanAI Onboarding Screen 4
// Introduces AI Chatbot Assistant
// =============================================

class Onboarding4 extends StatefulWidget {
  const Onboarding4({super.key});

  @override
  State<Onboarding4> createState() => _Onboarding4State();
}

class _Onboarding4State extends State<Onboarding4>
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

    _fadeAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.14),
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

          if (details.primaryVelocity! > 0) {
            navigate(AppRoutes.onboarding3);
          } else if (details.primaryVelocity! < 0) {
            navigate(AppRoutes.login);
          }
        },

        child: Container(
          width: double.infinity,
          height: double.infinity,

          // Background gradient
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFFFF1DD),
                Color(0xFFFFE3BF),
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

                  // =====================================
                  // Skip Button
                  // =====================================
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

                  // =====================================
                  // Animated Content
                  // =====================================
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

                          // Chatbot Illustration
                          _buildIllustration(size),

                          const SizedBox(height: 40),

                          // Title
                          _buildTitle(),

                          const SizedBox(height: 12),

                          // Description
                          _buildDescription(size),

                          const SizedBox(height: 40),

                          // Progress Dots
                          _buildProgressDots(),

                          const SizedBox(height: 35),

                          // Get Started Button
                          _buildStartButton(),

                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),

                  // =====================================
                  // Swipe Hint
                  // =====================================
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),

                    child: Text(
                      "Swipe left or tap the button to continue",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: AppColors.textLight,
                      ),
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
  // Illustration
  // =============================================

  Widget _buildIllustration(Size size) {

    return Container(
      width: size.width * 0.55,
      height: size.width * 0.55,

      decoration: BoxDecoration(
        shape: BoxShape.circle,

        gradient: const LinearGradient(
          colors: [
            Color(0xFFFFB74D),
            Color(0xFFFFA726),
          ],
        ),

        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFB74D).withOpacity(0.25),
            blurRadius: 22,
            offset: const Offset(0, 12),
          )
        ],
      ),

      child: const Icon(
        Icons.chat_bubble_rounded,
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
      "AI Skin\nChat Assistant",
      textAlign: TextAlign.center,

      style: GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: AppColors.textDark,
        height: 1.2,
      ),
    );
  }

  // =============================================
  // Description
  // =============================================

  Widget _buildDescription(Size size) {

    return SizedBox(
      width: size.width * 0.85,

      child: Text(
        "Ask questions about skincare, routines, or skin concerns and get instant AI-powered guidance directly inside the app.",

        textAlign: TextAlign.center,

        style: GoogleFonts.poppins(
          fontSize: 15,
          height: 1.6,
          color: AppColors.textLight,
        ),
      ),
    );
  }

  // =============================================
  // Start Button
  // =============================================

  Widget _buildStartButton() {

    return ElevatedButton(
      onPressed: () => navigate(AppRoutes.login),

      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFFA726),
        elevation: 0,
        padding: const EdgeInsets.symmetric(
          horizontal: 36,
          vertical: 14,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
      ),

      child: Text(
        "Get Started",
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // =============================================
  // Progress Dots
  // =============================================

  Widget _buildProgressDots() {

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _dot(false),
        const SizedBox(width: 10),
        _dot(false),
        const SizedBox(width: 10),
        _dot(false),
        const SizedBox(width: 10),
        _dot(true),
      ],
    );
  }

  // =============================================
  // Dot Widget
  // =============================================

  Widget _dot(bool active) {

    return AnimatedContainer(
      duration: const Duration(milliseconds: 260),
      width: active ? 28 : 10,
      height: 10,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),

        gradient: active
            ? const LinearGradient(
          colors: [
            Color(0xFFFFB74D),
            Color(0xFFFFA726),
          ],
        )
            : null,

        color: active ? null : AppColors.textLight.withOpacity(0.25),
      ),
    );
  }
}
