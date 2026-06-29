import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants.dart';
import '../../services/api_service.dart';
import 'analysis_screen.dart';

class PreviewScreen extends StatefulWidget {

  final File image;

  const PreviewScreen({super.key, required this.image});

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {

  bool isLoading = false;

  // ============================================
  // ANALYZE SKIN
  // ============================================

  Future<void> analyzeSkin() async {

    setState(() {
      isLoading = true;
    });

    final result = await ApiService.analyzeSkin(widget.image);

    setState(() {
      isLoading = false;
    });

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AnalysisScreen(result: result),
      ),
    );
  }

  // ============================================
  // UI
  // ============================================

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: AppColors.background,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "Preview Image",
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
      ),

      body: Padding(

        padding: const EdgeInsets.all(20),

        child: Column(

          children: [

            // ==============================
            // IMAGE PREVIEW CARD
            // ==============================

            Expanded(

              child: Container(

                width: double.infinity,

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.05),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),

                clipBehavior: Clip.hardEdge,

                child: Image.file(
                  widget.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 25),

            // ==============================
            // ANALYZE BUTTON
            // ==============================

            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton.icon(

                icon: const Icon(Icons.analytics_rounded),

                label: Text(
                  "Analyze Skin",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),

                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),

                onPressed: isLoading ? null : analyzeSkin,
              ),
            ),

            const SizedBox(height: 20),

            // ==============================
            // LOADING
            // ==============================

            if (isLoading)
              Column(
                children: [

                  const CircularProgressIndicator(),

                  const SizedBox(height: 10),

                  Text(
                    "Analyzing your skin...",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: AppColors.textLight,
                    ),
                  ),
                ],
              ),

          ],
        ),
      ),
    );
  }
}
