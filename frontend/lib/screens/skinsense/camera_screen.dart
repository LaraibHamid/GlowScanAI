import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants.dart';
import 'preview_screen.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {

  final ImagePicker _picker = ImagePicker();

  bool _loading = false;

  // ============================================
  // CAPTURE IMAGE
  // ============================================

  Future<void> _captureImage() async {

    setState(() => _loading = true);

    try {

      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      if (image == null) {
        setState(() => _loading = false);
        return;
      }

      final File file = File(image.path);

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PreviewScreen(image: file),
        ),
      );

    } catch (e) {

      _showSnack("Camera error: $e");

    } finally {

      setState(() => _loading = false);

    }
  }

  // ============================================
  // PICK FROM GALLERY
  // ============================================

  Future<void> _pickFromGallery() async {

    setState(() => _loading = true);

    try {

      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image == null) {
        setState(() => _loading = false);
        return;
      }

      final File file = File(image.path);

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PreviewScreen(image: file),
        ),
      );

    } catch (e) {

      _showSnack("Gallery error: $e");

    } finally {

      setState(() => _loading = false);

    }
  }

  // ============================================
  // SNACKBAR
  // ============================================

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
          "Skin Scanner",
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
      ),

      body: SafeArea(

        child: Padding(

          padding: const EdgeInsets.symmetric(horizontal: 24),

          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,

            children: [

              // CAMERA ICON

              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.camera_alt_rounded,
                  size: 60,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(height: 32),

              // TITLE

              Text(
                "Capture Your Skin",
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                "Take a photo or upload one from your gallery\nfor AI skin analysis",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: AppColors.textLight,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 40),

              // ============================================
              // CAMERA BUTTON
              // ============================================

              SizedBox(
                width: double.infinity,
                height: 54,

                child: ElevatedButton.icon(

                  icon: const Icon(Icons.camera_alt_rounded),

                  label: Text(
                    "Capture Image",
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

                  onPressed: _loading ? null : _captureImage,
                ),
              ),

              const SizedBox(height: 16),

              // ============================================
              // GALLERY BUTTON
              // ============================================

              SizedBox(
                width: double.infinity,
                height: 54,

                child: OutlinedButton.icon(

                  icon: const Icon(Icons.photo_library_rounded),

                  label: Text(
                    "Pick From Gallery",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),

                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),

                  onPressed: _loading ? null : _pickFromGallery,
                ),
              ),

              const SizedBox(height: 30),

              if (_loading)
                const CircularProgressIndicator(),

            ],
          ),
        ),
      ),
    );
  }
}
