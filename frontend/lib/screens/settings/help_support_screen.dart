import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../constants.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController pulseController;

  final Set<int> expandedFaqs = {};

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

                      _contactCard(),

                      const SizedBox(height: 20),

                      _faqSection(),

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
        "Help & Support",
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

        Text(
          "We’re Here to Help 💬",
          style: GoogleFonts.outfit(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
          ),
        ),

        const SizedBox(height: 10),

        Text(
          "Find answers to common questions or reach out to our support team anytime.",
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
  // CONTACT CARD
  // ---------------------------------------------------------

  Widget _contactCard() {

    return _card(

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          _sectionTitle(Icons.support_agent_rounded, "Contact Us"),

          const SizedBox(height: 16),

          Row(
            children: [

              Expanded(
                child: _contactTile(
                  icon: Icons.email_rounded,
                  title: "Email",
                  subtitle: "support@glowscan.ai",
                  color: const Color(0xFF6B73FF),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: _contactTile(
                  icon: Icons.phone_rounded,
                  title: "Call",
                  subtitle: "+92 304 6856659",
                  color: const Color(0xFFFFB74D),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _contactTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {

    return Container(

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),

      child: Column(

        children: [

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),

          const SizedBox(height: 12),

          Text(
            title,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // FAQ SECTION
  // ---------------------------------------------------------

  Widget _faqSection() {

    final faqs = [

      {
        "title": "How do I scan my skin?",
        "answer":
        "Go to the Scan tab and tap 'Start Scan'. Follow the instructions for lighting and distance to capture an accurate skin scan."
      },

      {
        "title": "How does AI recommend products?",
        "answer":
        "GlowScanAI analyzes your scan results along with your skin profile to suggest dermatologist-inspired skincare routines."
      },

      {
        "title": "Can I update my skin profile?",
        "answer":
        "Yes. Go to Profile → Edit Skin Profile and update your skin type, concerns, and allergies anytime."
      },

      {
        "title": "Is my skin data secure?",
        "answer":
        "Yes. Your data is encrypted and securely stored. GlowScanAI never shares your scans or personal information."
      },
    ];

    return _card(

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          _sectionTitle(Icons.help_outline_rounded, "FAQs"),

          const SizedBox(height: 12),

          ...faqs.asMap().entries.map((entry) {

            final index = entry.key;
            final faq = entry.value;

            final expanded = expandedFaqs.contains(index);

            return Column(

              children: [

                GestureDetector(

                  onTap: () {

                    setState(() {

                      expanded
                          ? expandedFaqs.remove(index)
                          : expandedFaqs.add(index);
                    });
                  },

                  child: Container(

                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 4),

                    child: Row(

                      children: [

                        Expanded(
                          child: Text(
                            faq["title"]!,
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        Icon(
                          expanded
                              ? Icons.expand_less_rounded
                              : Icons.expand_more_rounded,
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                  ),
                ),

                AnimatedCrossFade(
                  firstChild: const SizedBox(),
                  secondChild: Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      faq["answer"]!,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        height: 1.6,
                        color: AppColors.textLight,
                      ),
                    ),
                  ),
                  crossFadeState: expanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 250),
                ),

                const Divider(height: 4),
              ],
            );
          }),
        ],
      ),
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
  // SECTION TITLE
  // ---------------------------------------------------------

  Widget _sectionTitle(IconData icon, String title) {

    return Row(

      children: [

        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primary),
        ),

        const SizedBox(width: 10),

        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
