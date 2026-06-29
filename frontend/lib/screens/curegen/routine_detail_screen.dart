import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants.dart';

class RoutineDetailScreen extends StatelessWidget {

  final Map<String, dynamic> routine;

  const RoutineDetailScreen({super.key, required this.routine});

  // -------------------------------------------------------
  // OPEN EXTERNAL LINK (FIXED)
  // -------------------------------------------------------

  Future<void> _openLink(BuildContext context, String url) async {

    final Uri uri = Uri.parse(url);

    try {

      final bool launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        throw 'Could not launch $url';
      }

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Unable to open link",
            style: GoogleFonts.poppins(),
          ),
        ),
      );
    }
  }

  // -------------------------------------------------------
  // SECTION TITLE
  // -------------------------------------------------------

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: GoogleFonts.outfit(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: AppColors.textDark,
        ),
      ),
    );
  }

  // -------------------------------------------------------
  // ROUTINE STEP TILE
  // -------------------------------------------------------

  Widget _stepTile(String text) {

    return Container(

      margin: const EdgeInsets.only(bottom: 10),

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0,4),
          )
        ],
      ),

      child: Row(

        children: [

          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.spa_rounded,
              size: 18,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.textDark,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------
  // PRODUCT BUTTON
  // -------------------------------------------------------

  Widget _buyButton(BuildContext context, String label, String url) {

    return Container(

      margin: const EdgeInsets.only(bottom: 14),

      width: double.infinity,

      child: ElevatedButton.icon(

        icon: const Icon(Icons.shopping_bag_rounded),

        label: Text(
          label,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),

        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical:16),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),

          elevation: 3,
        ),

        onPressed: () => _openLink(context, url),
      ),
    );
  }

  // -------------------------------------------------------
  // ROUTINE CARD
  // -------------------------------------------------------

  Widget _routineCard(String title, List steps) {

    return Container(

      padding: const EdgeInsets.all(20),

      margin: const EdgeInsets.only(bottom: 24),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0,6),
          )
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [

              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  title == "Morning Routine"
                      ? Icons.wb_sunny_rounded
                      : Icons.nightlight_round,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(width:12),

              Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize:20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height:16),

          ...steps.map<Widget>((s)=>_stepTile(s)).toList(),
        ],
      ),
    );
  }

  // -------------------------------------------------------
  // BUILD
  // -------------------------------------------------------

  @override
  Widget build(BuildContext context) {

    final List morning = routine["morning"] ?? [];
    final List night = routine["night"] ?? [];

    return Scaffold(

      backgroundColor: AppColors.background,

      body: CustomScrollView(

        slivers: [

          SliverAppBar(

            expandedHeight: 180,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.transparent,

            flexibleSpace: FlexibleSpaceBar(

              titlePadding: const EdgeInsets.only(left:20,bottom:16),

              title: Text(
                routine["skin"] ?? "Routine",
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                ),
              ),

              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFFB6F92),
                      Color(0xFFFF8FAB),
                      Color(0xFFFFB3C6),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(

            child: Padding(

              padding: const EdgeInsets.all(22),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  _routineCard("Morning Routine", morning),

                  _routineCard("Night Routine", night),

                  _sectionTitle("Buy Products"),

                  const SizedBox(height:10),

                  _buyButton(
                    context,
                    "Shop at MakeupCity",
                    "https://makeupcityshop.com",
                  ),

                  _buyButton(
                    context,
                    "Shop at Colorshow.pk",
                    "https://colorshow.pk",
                  ),

                  const SizedBox(height:40),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
