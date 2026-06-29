import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../constants.dart';
import '../../screens/dashboard/dashboard_screen.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen>
    with SingleTickerProviderStateMixin {
  String selectedSkinType = "Oily";
  Set<String> selectedConcerns = {};

  final TextEditingController ageCtrl = TextEditingController();
  final TextEditingController allergiesCtrl = TextEditingController();
  String selectedGender = "";

  bool loading = false;

  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  final List<String> skinTypes = ["Oily", "Dry", "Combination", "Normal", "Sensitive"];

  final Map<String, IconData> skinTypeIcons = {
    "Oily": Icons.water_drop_rounded,
    "Dry": Icons.ac_unit_rounded,
    "Combination": Icons.merge_type_rounded,
    "Normal": Icons.check_circle_outline_rounded,
    "Sensitive": Icons.favorite_border_rounded,
  };

  final List<String> concerns = [
    "Acne",
    "Pigmentation",
    "Dryness",
    "Wrinkles",
    "Dark Circles",
    "Dullness",
    "Redness",
    "Large Pores",
  ];

  final Map<String, IconData> concernIcons = {
    "Acne": Icons.bubble_chart_rounded,
    "Pigmentation": Icons.color_lens_rounded,
    "Dryness": Icons.opacity_rounded,
    "Wrinkles": Icons.face_retouching_natural_rounded,
    "Dark Circles": Icons.visibility_outlined,
    "Dullness": Icons.brightness_low_rounded,
    "Redness": Icons.warning_amber_rounded,
    "Large Pores": Icons.blur_on_rounded,
  };

  final List<String> genders = ["Female", "Male", "Other"];

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 900));

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween(begin: const Offset(0, 0.12), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    ageCtrl.dispose();
    allergiesCtrl.dispose();
    _controller.dispose();
    super.dispose();
  }

  // ----------------------------------------------------------------------
  // PROGRESS BAR
  // ----------------------------------------------------------------------
  double get progress {
    int filled = 0;

    if (selectedSkinType.isNotEmpty) filled++;
    if (selectedConcerns.isNotEmpty) filled++;
    if (ageCtrl.text.trim().isNotEmpty) filled++;
    if (selectedGender.isNotEmpty) filled++;
    if (allergiesCtrl.text.trim().isNotEmpty) filled++;

    return filled / 5;
  }

  // ----------------------------------------------------------------------
  // SAVE PROFILE (With Age Validation)
  // ----------------------------------------------------------------------
  Future<void> _saveProfile() async {
    // AGE VALIDATION (13 to 100)
    if (ageCtrl.text.isEmpty || int.tryParse(ageCtrl.text) == null) {
      return _error("Please enter a valid age");
    }

    int age = int.parse(ageCtrl.text);
    if (age < 13 || age > 100) {
      return _error("Age must be between 13 and 100.");
    }

    if (selectedGender.isEmpty) {
      return _error("Please select your gender");
    }

    if (selectedConcerns.isEmpty) {
      return _error("Please select at least one concern");
    }

    setState(() => loading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("User not logged in");

      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .collection("skin_profile")
          .doc("details")
          .set({
        "age": age,
        "gender": selectedGender,
        "skinType": selectedSkinType,
        "concerns": selectedConcerns.toList(),
        "allergies": allergiesCtrl.text.trim(),
        "updatedAt": FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
        "profileCompleted": true,
        "updatedAt": FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DashboardScreen()),
        );
      }
    } catch (e) {
      _error("Error: $e");
    }

    if (mounted) setState(() => loading = false);
  }

  void _error(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.redAccent),
    );
  }

  // ----------------------------------------------------------------------
  // UI START
  // ----------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFFF4F8),
              Color(0xFFFFE6EE),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (_, child) => Opacity(
              opacity: _fade.value,
              child: SlideTransition(position: _slide, child: child),
            ),
            child: Column(
              children: [
                _appBar(width),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(28, 10, 28, 40),
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _header(),

                        const SizedBox(height: 26),
                        _ageCard(),

                        const SizedBox(height: 26),
                        _genderCard(),

                        const SizedBox(height: 26),
                        _skinTypeCard(),

                        const SizedBox(height: 26),
                        _concernCard(),

                        const SizedBox(height: 26),
                        _allergyCard(),

                        const SizedBox(height: 32),
                        _saveButton(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------------------------
  // APP BAR
  // ----------------------------------------------------------------------
  Widget _appBar(double width) {
    return Container(
      padding: const EdgeInsets.fromLTRB(28, 22, 28, 20),
      width: width,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Profile Setup",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              )),
          const SizedBox(height: 6),
          Text("Completed ${(progress * 100).toInt()}%",
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: AppColors.textLight,
              )),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation(AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------------------
  // HEADER
  // ----------------------------------------------------------------------
  Widget _header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Tell us about yourself",
            style: GoogleFonts.outfit(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            )),
        const SizedBox(height: 8),
        Text("We use your info to personalize recommendations.",
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.textLight,
            )),
      ],
    );
  }

  // ----------------------------------------------------------------------
  // AGE CARD (VALIDATION APPLIED)
  // ----------------------------------------------------------------------
  Widget _ageCard() {
    return _card(
      titleIcon: Icons.calendar_month_rounded,
      title: "Your Age",
      child: TextField(
        controller: ageCtrl,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: "Enter your age (13 - 100)",
          filled: true,
          fillColor: AppColors.background,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }

  // ----------------------------------------------------------------------
  // GENDER CARD
  // ----------------------------------------------------------------------
  Widget _genderCard() {
    return _card(
      titleIcon: Icons.person_outline_rounded,
      title: "Gender",
      child: Wrap(
        spacing: 12,
        children: genders.map((g) {
          final selected = selectedGender == g;

          return GestureDetector(
            onTap: () => setState(() => selectedGender = g),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 240),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: selected ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: selected ? AppColors.primary : Colors.grey.shade300,
                ),
              ),
              child: Text(
                g,
                style: GoogleFonts.poppins(
                  color: selected ? Colors.white : AppColors.textDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ----------------------------------------------------------------------
  // SKIN TYPE CARD
  // ----------------------------------------------------------------------
  Widget _skinTypeCard() {
    return _card(
      titleIcon: Icons.face_retouching_natural_rounded,
      title: "Select your skin type",
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: skinTypes.map((t) {
          final selected = selectedSkinType == t;

          return GestureDetector(
            onTap: () => setState(() => selectedSkinType = t),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 240),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: selected ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: selected ? AppColors.primary : Colors.grey.shade300,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(skinTypeIcons[t],
                      color: selected ? Colors.white : AppColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    t,
                    style: GoogleFonts.poppins(
                      color: selected ? Colors.white : AppColors.textDark,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ----------------------------------------------------------------------
  // CONCERNS CARD
  // ----------------------------------------------------------------------
  Widget _concernCard() {
    return _card(
      titleIcon: Icons.priority_high_rounded,
      title: "Select skin concerns",
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: concerns.map((c) {
          final selected = selectedConcerns.contains(c);

          return GestureDetector(
            onTap: () {
              setState(() {
                selected ? selectedConcerns.remove(c) : selectedConcerns.add(c);
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 240),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: selected ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: selected ? AppColors.primary : Colors.grey.shade300,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(concernIcons[c],
                      color: selected ? Colors.white : AppColors.primary),
                  const SizedBox(width: 6),
                  Text(
                    c,
                    style: GoogleFonts.poppins(
                      color: selected ? Colors.white : AppColors.textDark,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ----------------------------------------------------------------------
  // ALLERGY CARD
  // ----------------------------------------------------------------------
  Widget _allergyCard() {
    return _card(
      titleIcon: Icons.medical_information_rounded,
      title: "Allergies (optional)",
      child: TextField(
        controller: allergiesCtrl,
        maxLines: 3,
        decoration: InputDecoration(
          hintText: "List any skincare allergies...",
          filled: true,
          fillColor: AppColors.background,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }

  // ----------------------------------------------------------------------
  // SAVE BUTTON
  // ----------------------------------------------------------------------
  Widget _saveButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: loading ? null : _saveProfile,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: loading
            ? const CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 2,
        )
            : Text(
          "Save & Continue",
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------------------------
  // CARD TEMPLATE
  // ----------------------------------------------------------------------
  Widget _card({
    required IconData titleIcon,
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.94),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.07),
            blurRadius: 18,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(titleIcon, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }
}
