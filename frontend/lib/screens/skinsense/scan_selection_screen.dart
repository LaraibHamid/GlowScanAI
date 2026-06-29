import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants.dart';
import '../../routes.dart';

class ScanSelectionScreen extends StatefulWidget {
  const ScanSelectionScreen({super.key});

  @override
  State<ScanSelectionScreen> createState() => _ScanSelectionScreenState();
}

class _ScanSelectionScreenState extends State<ScanSelectionScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController fadeController;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  @override
  void dispose() {
    fadeController.dispose();
    super.dispose();
  }

  // -------------------------------------------------------
  // OPEN CAMERA
  // -------------------------------------------------------

  void _openCamera() {
    Navigator.pushNamed(context, AppRoutes.camera);
  }

  // -------------------------------------------------------
  // SNACKBAR
  // -------------------------------------------------------

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        content: Text(
          msg,
          style: GoogleFonts.poppins(color: Colors.white),
        ),
      ),
    );
  }

  // -------------------------------------------------------
  // MAIN UI
  // -------------------------------------------------------

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

          child: FadeTransition(

            opacity: fadeController,

            child: Padding(

              padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),

              child: Column(

                crossAxisAlignment: CrossAxisAlignment.center,

                children: [

                  const SizedBox(height: 10),

                  _buildHeader(),

                  const SizedBox(height: 40),

                  _cameraScanCard(),

                  const SizedBox(height: 30),

                  _tipsCard(),

                  const Spacer(),

                  _swipeBackHint(),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------
  // HEADER
  // -------------------------------------------------------

  Widget _buildHeader() {

    return Column(

      children: [

        Text(
          "AI Skin Scan",
          style: GoogleFonts.outfit(
            fontSize: 34,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          "Capture your skin using the camera\nfor AI powered analysis",
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 15,
            color: AppColors.textLight,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  // -------------------------------------------------------
  // CAMERA CARD
  // -------------------------------------------------------

  Widget _cameraScanCard() {

    return GestureDetector(

      onTap: isLoading ? null : _openCamera,

      child: Container(

        padding: const EdgeInsets.all(26),

        decoration: BoxDecoration(

          gradient: LinearGradient(
            colors: [
              const Color(0xFFFB6F92).withOpacity(.12),
              const Color(0xFFFF8FAB).withOpacity(.08),
            ],
          ),

          borderRadius: BorderRadius.circular(24),

          border: Border.all(
            color: const Color(0xFFFB6F92).withOpacity(.25),
          ),

          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFB6F92).withOpacity(.15),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),

        child: Row(

          children: [

            Container(
              width: 68,
              height: 68,

              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFFB6F92),
                    Color(0xFFFF8FAB),
                  ],
                ),
                borderRadius: BorderRadius.all(Radius.circular(18)),
              ),

              child: const Icon(
                Icons.camera_alt_rounded,
                size: 34,
                color: Colors.white,
              ),
            ),

            const SizedBox(width: 20),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    "Use Camera",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "Take a photo for real-time AI skin analysis",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: AppColors.textLight,
                    ),
                  ),
                ],
              ),
            ),

            if (isLoading)
              const SizedBox(
                width: 26,
                height: 26,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2);
  }

  // -------------------------------------------------------
  // TIPS CARD
  // -------------------------------------------------------

  Widget _tipsCard() {

    final tips = [
      "Use natural lighting for better accuracy",
      "Keep your face centered in the frame",
      "Remove makeup before scanning",
      "Hold the phone steady while capturing"
    ];

    final icons = [
      Icons.wb_sunny_rounded,
      Icons.center_focus_strong_rounded,
      Icons.face_rounded,
      Icons.photo_camera_back_rounded,
    ];

    return Container(

      padding: const EdgeInsets.all(24),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.grey.shade300),
      ),

      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          Text(
            "Tips for Best Results",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),

          const SizedBox(height: 18),

          ...List.generate(tips.length, (index) {

            return Padding(

              padding: const EdgeInsets.only(bottom: 14),

              child: Row(

                children: [

                  Container(
                    padding: const EdgeInsets.all(8),

                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(.12),
                      borderRadius: BorderRadius.circular(10),
                    ),

                    child: Icon(
                      icons[index],
                      size: 20,
                      color: AppColors.primary,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Text(
                      tips[index],
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: AppColors.textDark,
                      ),
                    ),
                  )
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // -------------------------------------------------------
  // SWIPE BACK
  // -------------------------------------------------------

  Widget _swipeBackHint() {

    return Row(

      mainAxisAlignment: MainAxisAlignment.center,

      children: [

        Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 16,
          color: AppColors.textLight.withOpacity(.6),
        ),

        const SizedBox(width: 8),

        Text(
          "Swipe right to go back",
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: AppColors.textLight,
          ),
        ),
      ],
    );
  }
}
