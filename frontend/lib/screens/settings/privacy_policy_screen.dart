import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController pulseController;

  @override
  void initState() {
    super.initState();

    pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: AppColors.background,

      body: GestureDetector(

        onHorizontalDragEnd: (d) {
          if (d.primaryVelocity != null && d.primaryVelocity! > 0) {
            Navigator.pop(context);
          }
        },

        child: SafeArea(

          child: CustomScrollView(

            physics: const BouncingScrollPhysics(),

            slivers: [

              _appBar(),

              SliverToBoxAdapter(

                child: Padding(

                  padding: const EdgeInsets.all(22),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [

                      _header()
                          .animate()
                          .fadeIn(duration: 450.ms)
                          .slideY(begin: .1),

                      const SizedBox(height: 24),

                      _lastUpdated(),

                      const SizedBox(height: 28),

                      _policyItem(
                        icon: Icons.security_rounded,
                        gradient: const [
                          Color(0xFF6B73FF),
                          Color(0xFF9D73FF)
                        ],
                        title: "Your Privacy Matters",
                        content:
                        "At GlowScanAI, protecting your data is our highest priority. This policy explains how we collect, use, and protect your personal information.",
                      ),

                      _policyItem(
                        icon: Icons.assignment_rounded,
                        gradient: const [
                          Color(0xFF8ACB88),
                          Color(0xFF6BBF59)
                        ],
                        title: "Data We Collect",
                        content: "We collect the following information:",
                        bullets: [
                          "Basic account information (name, email)",
                          "Skin scan images",
                          "Skin type and concerns",
                          "Anonymous usage analytics"
                        ],
                      ),

                      _policyItem(
                        icon: Icons.analytics_rounded,
                        gradient: const [
                          Color(0xFFFFB74D),
                          Color(0xFFFFA726)
                        ],
                        title: "How We Use Your Data",
                        content: "Your information helps us:",
                        bullets: [
                          "Analyze skin conditions using AI",
                          "Provide personalized skincare recommendations",
                          "Track your skin improvement over time"
                        ],
                      ),

                      _policyItem(
                        icon: Icons.image_rounded,
                        gradient: const [
                          Color(0xFFFB6F92),
                          Color(0xFFFF8FAB)
                        ],
                        title: "Photo Processing",
                        content:
                        "Photos uploaded for scanning are used only for AI analysis and may be removed after processing depending on system requirements.",
                      ),

                      _policyItem(
                        icon: Icons.share_rounded,
                        gradient: const [
                          Color(0xFF9D73FF),
                          Color(0xFFB39DDB)
                        ],
                        title: "Data Sharing",
                        content:
                        "We never sell your personal data. Information may only be shared with:",
                        bullets: [
                          "Trusted service providers that help operate the platform",
                          "Authorities if legally required"
                        ],
                      ),

                      _policyItem(
                        icon: Icons.verified_user_rounded,
                        gradient: const [
                          Color(0xFF00BCD4),
                          Color(0xFF00ACC1)
                        ],
                        title: "Your Rights",
                        content: "You have full control over your data:",
                        bullets: [
                          "Update your profile information",
                          "Request account deletion",
                          "Download your stored data",
                          "Withdraw consent anytime"
                        ],
                      ),

                      _policyItem(
                        icon: Icons.lock_rounded,
                        gradient: const [
                          Color(0xFFE91E63),
                          Color(0xFFF06292)
                        ],
                        title: "Security Measures",
                        content:
                        "GlowScanAI uses modern encryption and secure cloud infrastructure to protect user data from unauthorized access.",
                      ),

                      _policyItem(
                        icon: Icons.update_rounded,
                        gradient: const [
                          Color(0xFFFF9800),
                          Color(0xFFFFB74D)
                        ],
                        title: "Policy Updates",
                        content:
                        "This privacy policy may be updated from time to time. If changes occur, users will be notified within the app.",
                      ),

                      const SizedBox(height: 40),

                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  // APP BAR
  // ---------------------------------------------------------

  Widget _appBar() {

    return SliverAppBar(
      pinned: true,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white.withValues(alpha: 0.9),
      elevation: 0,

      title: Text(
        "Privacy Policy",
        style: GoogleFonts.outfit(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: AppColors.textDark,
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  // HEADER
  // ---------------------------------------------------------

  Widget _header() {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [

        Container(
          padding: const EdgeInsets.symmetric(
              horizontal: 16, vertical: 8),

          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(20),
          ),

          child: Row(
            mainAxisSize: MainAxisSize.min,

            children: [

              Icon(Icons.shield_rounded,
                  color: AppColors.primary,
                  size: 20),

              const SizedBox(width: 8),

              Text(
                "We Protect Your Privacy",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        Text(
          "Privacy Policy",
          style: GoogleFonts.outfit(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
          ),
        ),

        const SizedBox(height: 6),

        Text(
          "Understand how we collect, use, and protect your data.",
          style: GoogleFonts.poppins(
            fontSize: 14,
            height: 1.6,
            color: AppColors.textLight,
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------
  // LAST UPDATED
  // ---------------------------------------------------------

  Widget _lastUpdated() {

    return Container(

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade200),
      ),

      child: Row(

        children: [

          Container(
            padding: const EdgeInsets.all(12),

            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(12),
            ),

            child: Icon(
              Icons.calendar_today_rounded,
              color: Colors.blue.shade700,
            ),
          ),

          const SizedBox(width: 12),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              Text(
                "Last Updated",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.blue.shade700,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                "November 4, 2025",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.blue.shade900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // POLICY CARD
  // ---------------------------------------------------------

  Widget _policyItem({
    required IconData icon,
    required List<Color> gradient,
    required String title,
    required String content,
    List<String>? bullets,
  }) {

    return Container(

      margin: const EdgeInsets.only(bottom: 18),

      padding: const EdgeInsets.all(22),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),

        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.10),
            blurRadius: 16,
            offset: const Offset(0, 6),
          )
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          Row(
            children: [

              _iconTag(icon, gradient),

              const SizedBox(width: 14),

              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Text(
            content,
            style: GoogleFonts.poppins(
              fontSize: 14,
              height: 1.7,
              color: AppColors.textLight,
            ),
          ),

          if (bullets != null) ...[
            const SizedBox(height: 14),

            ...bullets.map(
                  (b) => Padding(
                padding:
                const EdgeInsets.only(bottom: 10),
                child: _bullet(b, gradient),
              ),
            )
          ]
        ],
      ),
    );
  }

  Widget _iconTag(IconData icon, List<Color> gradient) {

    return Container(

      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradient),
        borderRadius: BorderRadius.circular(14),
      ),

      child: Icon(icon,
          color: Colors.white,
          size: 22),
    );
  }

  Widget _bullet(String text, List<Color> gradient) {

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [

        Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.only(top: 6),

          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(colors: gradient),
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 14,
              height: 1.6,
              color: AppColors.textLight,
            ),
          ),
        ),
      ],
    );
  }
}
