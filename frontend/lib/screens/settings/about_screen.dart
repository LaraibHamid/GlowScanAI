import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../constants.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen>
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

                    children: [

                      _logoSection()
                          .animate()
                          .fadeIn(duration: 450.ms)
                          .slideY(begin: .1),

                      const SizedBox(height: 28),

                      _infoCard(
                        title: "About GlowScanAI",
                        icon: Icons.info_outline,
                        content:
                        "GlowScanAI is an AI-powered skincare assistant designed to help users analyze skin conditions, receive personalized skincare routines, track scan history, and get instant help from the GlowMate AI assistant.",
                      ),

                      const SizedBox(height: 20),

                      _featuresCard(),

                      const SizedBox(height: 20),

                      _teamCard(),

                      const SizedBox(height: 20),

                      _versionCard(),

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
        "About",
        style: GoogleFonts.outfit(
          color: AppColors.textDark,
          fontSize: 22,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  // LOGO
  // ---------------------------------------------------------

  Widget _logoSection() {

    return Column(

      children: [

        AnimatedBuilder(

          animation: pulseController,

          builder: (_, child) {

            return Transform.scale(

              scale: 1 + (pulseController.value * 0.04),

              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.white,

                child: ClipOval(
                  child: Image.asset(
                    "assets/images/logo.about.jpeg",
                    width: 88,
                    height: 88,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 16),

        Text(
          "GlowScanAI",
          style: GoogleFonts.outfit(
            fontSize: 30,
            fontWeight: FontWeight.w800,
          ),
        ),

        const SizedBox(height: 6),

        Text(
          "AI-Powered Skincare",
          style: GoogleFonts.poppins(
            color: AppColors.primary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------
  // CARD WRAPPER
  // ---------------------------------------------------------

  Widget _card({required Widget child}) {

    return Container(

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),

        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),

      child: child,
    );
  }

  // ---------------------------------------------------------
  // INFO CARD
  // ---------------------------------------------------------

  Widget _infoCard({
    required String title,
    required IconData icon,
    required String content,
  }) {

    return _card(

      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          Row(
            children: [

              _iconTag(icon),

              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
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
              height: 1.55,
              color: AppColors.textLight,
            ),
          )
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // FEATURES
  // ---------------------------------------------------------

  Widget _featuresCard() {

    final features = [

      {
        "icon": Icons.camera_alt_rounded,
        "title": "AI Skin\nScanning"
      },

      {
        "icon": Icons.local_offer_rounded,
        "title": "Smart\nRecommendations"
      },

      {
        "icon": Icons.history_rounded,
        "title": "Scan History\nTracking"
      },

      {
        "icon": Icons.chat_bubble_rounded,
        "title": "GlowMate\nAssistant"
      },
    ];

    return _card(

      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          Row(
            children: [

              _iconTag(Icons.star_rounded),

              const SizedBox(width: 10),

              Text(
                "Key Features",
                style: GoogleFonts.poppins(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          LayoutBuilder(

            builder: (context, constraints) {

              int crossAxisCount = constraints.maxWidth < 360 ? 1 : 2;

              return GridView.builder(

                shrinkWrap: true,

                physics: const NeverScrollableScrollPhysics(),

                itemCount: features.length,

                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: 1.25,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                ),

                itemBuilder: (_, i) {

                  return _featureBox(
                    icon: features[i]["icon"] as IconData,
                    title: features[i]["title"] as String,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _featureBox({required IconData icon, required String title}) {

    return Container(

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),

      child: Column(

        mainAxisAlignment: MainAxisAlignment.center,

        children: [

          Icon(icon, color: AppColors.primary, size: 26),

          const SizedBox(height: 8),

          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // TEAM
  // ---------------------------------------------------------

  Widget _teamCard() {

    return _infoCard(

      title: "Developed By",

      icon: Icons.groups_rounded,

      content:
      "Laraib Hamid\nSamavia Tanveer\nMuhammad Asad\n\nDepartment of Software Engineering\nUniversity of Gujrat",
    );
  }

  // ---------------------------------------------------------
  // VERSION
  // ---------------------------------------------------------

  Widget _versionCard() {

    return _card(

      child: Row(

        children: [

          _iconTag(Icons.verified_rounded),

          const SizedBox(width: 10),

          Text(
            "Version 1.0.0",
            style: GoogleFonts.poppins(
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),

          const Spacer(),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Text(
              "Latest",
              style: TextStyle(color: Colors.white, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // ICON TAG
  // ---------------------------------------------------------

  Widget _iconTag(IconData icon) {

    return Container(

      padding: const EdgeInsets.all(10),

      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
      ),

      child: Icon(icon, color: AppColors.primary),
    );
  }
}

