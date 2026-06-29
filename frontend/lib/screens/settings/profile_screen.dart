import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../constants.dart';
import '../../routes.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {

  String name = "User";
  String email = "No Email";

  int age = 0;
  String gender = "Not set";

  String skinType = "Not set";
  List concerns = [];
  String allergies = "";

  late AnimationController pulse;

  @override
  void initState() {
    super.initState();

    pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1700),
    )..repeat(reverse: true);

    _loadUser();
  }

  @override
  void dispose() {
    pulse.dispose();
    super.dispose();
  }

  // ==========================================================
  // LOAD USER DATA
  // ==========================================================

  Future<void> _loadUser() async {

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    name = user.displayName ?? "User";
    email = user.email ?? "No Email";

    try {

      final doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .collection("skin_profile")
          .doc("details")
          .get();

      final data = doc.data();

      if (data != null) {

        skinType = data["skinType"] ?? "Not set";
        concerns = List.from(data["concerns"] ?? []);
        allergies = data["allergies"] ?? "";
        age = data["age"] ?? 0;
        gender = data["gender"] ?? "Not set";

      }

    } catch (_) {}

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;

    return Scaffold(

      backgroundColor: AppColors.background,

      body: GestureDetector(

        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity != null && details.primaryVelocity! > 0) {
            Navigator.pop(context);
          }
        },

        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),

          slivers: [

            _headerSection(width),

            SliverToBoxAdapter(

              child: Padding(

                padding: EdgeInsets.all(width * 0.055),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    _userInfoCard(width),

                    SizedBox(height: width * 0.06),

                    _sectionTitle("Skin Profile", width),

                    SizedBox(height: width * 0.04),

                    _infoTile("Age", age == 0 ? "Not set" : "$age", width),

                    _infoTile("Gender", gender, width),

                    _infoTile("Skin Type", skinType, width),

                    _infoTile(
                      "Concerns",
                      concerns.isEmpty ? "None" : concerns.join(", "),
                      width,
                    ),

                    _infoTile(
                      "Allergies",
                      allergies.isEmpty ? "None" : allergies,
                      width,
                    ),

                    SizedBox(height: width * 0.06),

                    _editProfileButton(width),

                    SizedBox(height: width * 0.05),

                    _logoutButton(width),

                    SizedBox(height: width * 0.12),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // HEADER SECTION
  // ==========================================================

  Widget _headerSection(double width) {

    return SliverAppBar(

      expandedHeight: width * 0.55,

      pinned: true,

      elevation: 0,

      automaticallyImplyLeading: false,

      backgroundColor: Colors.transparent,

      flexibleSpace: FlexibleSpaceBar(

        background: Stack(

          alignment: Alignment.center,

          children: [

            Container(
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

            AnimatedBuilder(

              animation: pulse,

              builder: (_, child) => Transform.scale(
                scale: 1 + (pulse.value * 0.04),

                child: CircleAvatar(

                  radius: width * 0.15,

                  backgroundColor: Colors.white,

                  child: Text(

                    name.isNotEmpty
                        ? name[0].toUpperCase()
                        : "U",

                    style: GoogleFonts.outfit(
                      fontSize: width * 0.13,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // USER CARD
  // ==========================================================

  Widget _userInfoCard(double width) {

    return Container(

      padding: EdgeInsets.all(width * 0.055),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius: BorderRadius.circular(width * 0.045),

        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 8),
            color: Colors.black.withValues(alpha: 0.06),
          )
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          Text(
            name,
            style: GoogleFonts.outfit(
              fontSize: width * 0.085,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),

          SizedBox(height: width * 0.015),

          Text(
            email,
            style: GoogleFonts.poppins(
              fontSize: width * 0.04,
              color: AppColors.textLight,
            ),
          ),

          SizedBox(height: width * 0.04),

          Divider(color: Colors.grey.shade300),
        ],
      ),
    );
  }

  // ==========================================================
  // SECTION TITLE
  // ==========================================================

  Widget _sectionTitle(String title, double width) {

    return Text(

      title,

      style: GoogleFonts.outfit(
        fontSize: width * 0.07,
        fontWeight: FontWeight.w800,
        color: AppColors.textDark,
      ),
    );
  }

  // ==========================================================
  // INFO TILE
  // ==========================================================

  Widget _infoTile(String title, String value, double width) {

    return Container(

      margin: EdgeInsets.only(bottom: width * 0.035),

      padding: EdgeInsets.all(width * 0.045),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius: BorderRadius.circular(width * 0.045),

        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            offset: const Offset(0, 6),
            color: Colors.black.withValues(alpha: 0.06),
          )
        ],
      ),

      child: Row(

        children: [

          Icon(
            Icons.check_circle_rounded,
            color: AppColors.primary,
            size: width * 0.06,
          ),

          SizedBox(width: width * 0.035),

          Expanded(
            child: Text(
              "$title: $value",
              style: GoogleFonts.poppins(
                fontSize: width * 0.044,
                color: AppColors.textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // EDIT PROFILE BUTTON
  // ==========================================================

  Widget _editProfileButton(double width) {

    return SizedBox(

      width: double.infinity,

      child: ElevatedButton(

        onPressed: () =>
            Navigator.pushNamed(context, AppRoutes.profileSetup),

        style: ElevatedButton.styleFrom(

          backgroundColor: AppColors.primary,

          padding: EdgeInsets.symmetric(vertical: width * 0.04),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(width * 0.04),
          ),
        ),

        child: Text(

          "Edit Skin Profile",

          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: width * 0.045,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // LOGOUT BUTTON
  // ==========================================================

  Widget _logoutButton(double width) {

    return SizedBox(

      width: double.infinity,

      child: ElevatedButton(

        onPressed: () async {

          await FirebaseAuth.instance.signOut();

          if (!mounted) return;

          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.login,
                (route) => false,
          );
        },

        style: ElevatedButton.styleFrom(

          backgroundColor: Colors.red.shade600,

          padding: EdgeInsets.symmetric(vertical: width * 0.04),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(width * 0.04),
          ),
        ),

        child: Text(

          "Logout",

          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: width * 0.045,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
