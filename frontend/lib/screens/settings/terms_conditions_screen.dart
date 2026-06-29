import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants.dart';

class TermsConditionsScreen extends StatefulWidget {
  const TermsConditionsScreen({super.key});

  @override
  State<TermsConditionsScreen> createState() => _TermsConditionsScreenState();
}

class _TermsConditionsScreenState extends State<TermsConditionsScreen>
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

                      _section(
                        icon: Icons.handshake_rounded,
                        gradient: const [Color(0xFF6B73FF), Color(0xFF9D73FF)],
                        title: "Welcome to GlowScanAI",
                        content:
                        "By accessing and using GlowScanAI, you agree to comply with the following terms and policies.",
                      ),

                      _section(
                        icon: Icons.check_circle_rounded,
                        gradient: const [Color(0xFF8ACB88), Color(0xFF6BBF59)],
                        title: "Acceptance of Terms",
                        content: "By using GlowScanAI you agree to:",
                        bullets: [
                          "Follow all usage policies",
                          "Provide accurate account information",
                          "Be responsible for your account activity",
                        ],
                      ),

                      _section(
                        icon: Icons.medical_services_rounded,
                        gradient: const [Color(0xFFFFB74D), Color(0xFFFFA726)],
                        title: "Medical Disclaimer",
                        content:
                        "GlowScanAI provides AI-powered skincare suggestions and insights.",
                        bullets: [
                          "Not a replacement for professional medical advice",
                          "Not suitable for medical emergencies",
                        ],
                      ),

                      _section(
                        icon: Icons.warning_rounded,
                        gradient: const [Color(0xFFFF8A65), Color(0xFFFF7043)],
                        title: "Limitation of Liability",
                        content:
                        "GlowScanAI is not responsible for decisions made based on AI suggestions.",
                        bullets: [
                          "Results are informational only",
                          "Users remain responsible for skincare decisions",
                        ],
                      ),

                      _section(
                        icon: Icons.update_rounded,
                        gradient: const [Color(0xFF00BCD4), Color(0xFF00ACC1)],
                        title: "Service Modifications",
                        content:
                        "GlowScanAI may update or improve features at any time. Continued use indicates acceptance of changes.",
                      ),

                      const SizedBox(height: 30),

                      _agreementNotice()
                          .animate()
                          .fadeIn(duration: 500.ms)
                          .slideY(begin: .1),

                      const SizedBox(height: 40),

                    ],
                  ),
                ),
              ),
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
        "Terms & Conditions",
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(20),
          ),

          child: Row(
            mainAxisSize: MainAxisSize.min,

            children: [

              Icon(Icons.assignment_rounded,
                  color: AppColors.primary,
                  size: 20),

              const SizedBox(width: 10),

              Text(
                "Legal Agreement",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        Text(
          "Terms & Conditions",
          style: GoogleFonts.outfit(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          "Please read these terms carefully before using GlowScanAI.",
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
            padding: const EdgeInsets.all(10),

            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(12),
            ),

            child: Icon(Icons.calendar_today_rounded,
                color: Colors.blue.shade700),
          ),

          const SizedBox(width: 14),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              Text(
                "Effective Date",
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
  // SECTION CARD
  // ---------------------------------------------------------

  Widget _section({
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
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            content,
            style: GoogleFonts.poppins(
              fontSize: 14,
              height: 1.7,
              color: AppColors.textLight,
            ),
          ),

          if (bullets != null) ...[

            const SizedBox(height: 12),

            ...bullets.map(
                  (b) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _bullet(b, gradient),
              ),
            ),
          ],
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

      child: Icon(icon, color: Colors.white, size: 22),
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

  // ---------------------------------------------------------
  // AGREEMENT NOTICE
  // ---------------------------------------------------------

  Widget _agreementNotice() {

    return Container(

      padding: const EdgeInsets.all(22),

      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.amber.shade200),
      ),

      child: Row(

        children: [

          Container(
            padding: const EdgeInsets.all(12),

            decoration: BoxDecoration(
              color: Colors.amber.shade100,
              borderRadius: BorderRadius.circular(12),
            ),

            child: Icon(Icons.info_rounded,
                color: Colors.amber.shade900),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Text(
              "By using GlowScanAI you confirm that you have read and accepted these Terms & Conditions.",
              style: GoogleFonts.poppins(
                fontSize: 14,
                height: 1.6,
                color: Colors.amber.shade900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
