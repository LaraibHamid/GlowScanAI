// lib/screens/settings/settings_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../constants.dart';
import '../../routes.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController pulseController;

  String name = "User";
  String email = "";
  bool loading = true;

  @override
  void initState() {
    super.initState();

    pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    loadUser();
  }

  @override
  void dispose() {
    pulseController.dispose();
    super.dispose();
  }

  // =====================================================
  // LOAD USER
  // =====================================================

  Future<void> loadUser() async {

    try {

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      email = user.email ?? "";

      String? fetchedName;

      final doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get();

      if (doc.exists && doc.data()?["name"] != null) {
        fetchedName = doc["name"];
      }

      if (fetchedName == null || fetchedName.trim().isEmpty) {
        fetchedName = user.displayName;
      }

      if (fetchedName == null || fetchedName.trim().isEmpty) {
        fetchedName = email.contains("@")
            ? email.split("@")[0]
            : "User";
      }

      setState(() {
        name = fetchedName!;
        loading = false;
      });

    } catch (e) {
      debugPrint("Load user error: $e");
      setState(() => loading = false);
    }
  }

  // =====================================================
  // UI
  // =====================================================

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

        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),

          slivers: [

            _appBar(),

            SliverToBoxAdapter(

              child: Padding(
                padding: const EdgeInsets.all(22),

                child: Column(
                  children: [

                    _profileCard(),

                    const SizedBox(height:34),

                    // ACCOUNT

                    _sectionHeader("Account", Icons.person),

                    const SizedBox(height:14),

                    _tile(
                      title: "Edit Profile",
                      subtitle: "Update your information",
                      icon: Icons.edit_rounded,
                      gradient: const [Color(0xFF6B73FF), Color(0xFF9D73FF)],
                      onTap: () => Navigator.pushNamed(context, AppRoutes.profile),
                    ),

                    const SizedBox(height:30),

                    // LEGAL

                    _sectionHeader("Legal & Support", Icons.shield_rounded),

                    const SizedBox(height:14),

                    _tile(
                      title: "Privacy Policy",
                      subtitle: "See how we protect your data",
                      icon: Icons.privacy_tip_rounded,
                      gradient: const [Color(0xFFFFB74D), Color(0xFFFFA726)],
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.privacyPolicy),
                    ),

                    _tile(
                      title: "Terms & Conditions",
                      subtitle: "Read terms of service",
                      icon: Icons.description_rounded,
                      gradient: const [Color(0xFFFB6F92), Color(0xFFFF8FAB)],
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.termsConditions),
                    ),

                    _tile(
                      title: "Help & Support",
                      subtitle: "FAQs & contact info",
                      icon: Icons.help_outline_rounded,
                      gradient: const [Color(0xFF6B73FF), Color(0xFF9D73FF)],
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.helpSupport),
                    ),

                    _tile(
                      title: "About GlowScanAI",
                      subtitle: "Version 1.0.0",
                      icon: Icons.info_outline_rounded,
                      gradient: const [Color(0xFF8ACB88), Color(0xFF6BBF59)],
                      onTap: () => Navigator.pushNamed(context, AppRoutes.about),
                    ),

                    const SizedBox(height:30),

                    _logoutButton(),

                    const SizedBox(height:40),

                    _swipeBackHint(),

                    const SizedBox(height:40),

                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // =====================================================
  // APP BAR
  // =====================================================

  SliverAppBar _appBar() {

    return SliverAppBar(

      pinned: true,
      expandedHeight: 110,
      elevation: 0,

      backgroundColor: Colors.white.withValues(alpha: 0.9),

      flexibleSpace: FlexibleSpaceBar(

        titlePadding: const EdgeInsets.only(left:22,bottom:16),

        title: Text(
          "Settings",
          style: GoogleFonts.outfit(
            fontSize:22,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
          ),
        ),
      ),
    );
  }

  // =====================================================
  // PROFILE CARD
  // =====================================================

  Widget _profileCard() {

    return Container(

      padding: const EdgeInsets.all(22),

      decoration: BoxDecoration(

        borderRadius: BorderRadius.circular(22),

        gradient: const LinearGradient(
          colors: [Color(0xFF6B73FF), Color(0xFFFF8FAB)],
        ),

        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.25),
            blurRadius: 14,
            offset: const Offset(0,6),
          )
        ],
      ),

      child: Row(

        children: [

          ScaleTransition(

            scale: Tween(begin:1.0,end:1.07).animate(
              CurvedAnimation(
                parent:pulseController,
                curve:Curves.easeInOut,
              ),
            ),

            child: CircleAvatar(

              radius:34,
              backgroundColor: Colors.white,

              child: Text(
                name.isNotEmpty
                    ? name[0].toUpperCase()
                    : "U",

                style: GoogleFonts.outfit(
                  fontSize:26,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),

          const SizedBox(width:16),

          Expanded(

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                loading
                    ? Container(
                  height:18,
                  width:120,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(6),
                  ),
                )
                    : Text(
                  name,
                  style: GoogleFonts.outfit(
                    fontSize:22,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height:4),

                Text(
                  email,
                  style: GoogleFonts.poppins(
                    fontSize:13,
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // SECTION HEADER
  // =====================================================

  Widget _sectionHeader(String title, IconData icon) {

    return Row(

      children: [

        Container(

          padding: const EdgeInsets.all(10),

          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
          ),

          child: Icon(icon,color:AppColors.primary),
        ),

        const SizedBox(width:12),

        Text(
          title,
          style: GoogleFonts.outfit(
            fontSize:20,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        )
      ],
    );
  }

  // =====================================================
  // SETTINGS TILE
  // =====================================================

  Widget _tile({
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {

    return Container(

      margin: const EdgeInsets.only(bottom:12),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),

        gradient: LinearGradient(
          colors:[
            gradient.first.withValues(alpha:0.08),
            gradient.last.withValues(alpha:0.04),
          ],
        ),

        border: Border.all(
          color: gradient.first.withValues(alpha:0.2),
        ),
      ),

      child: InkWell(

        borderRadius: BorderRadius.circular(20),

        onTap: onTap,

        child: Padding(

          padding: const EdgeInsets.all(18),

          child: Row(

            children: [

              Container(

                padding: const EdgeInsets.all(12),

                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: gradient),
                  borderRadius: BorderRadius.circular(14),
                ),

                child: Icon(icon,color:Colors.white,size:22),
              ),

              const SizedBox(width:16),

              Expanded(

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize:16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),

                    const SizedBox(height:4),

                    Text(
                      subtitle,
                      style: GoogleFonts.poppins(
                        fontSize:13,
                        color: AppColors.textLight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =====================================================
  // LOGOUT BUTTON
  // =====================================================

  Widget _logoutButton() {

    return InkWell(

      onTap: showLogoutDialog,

      borderRadius: BorderRadius.circular(18),

      child: Container(

        padding: const EdgeInsets.symmetric(vertical:16),

        decoration: BoxDecoration(

          borderRadius: BorderRadius.circular(18),

          gradient: LinearGradient(
            colors:[Colors.red.shade400,Colors.red.shade700],
          ),
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            const Icon(Icons.logout_rounded,color:Colors.white),

            const SizedBox(width:10),

            Text(
              "Logout",
              style: GoogleFonts.poppins(
                fontSize:16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =====================================================
  // LOGOUT CONFIRM
  // =====================================================

  void showLogoutDialog(){

    showDialog(

      context: context,

      builder: (_)=>AlertDialog(

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),

        title: Text(
          "Logout",
          style: GoogleFonts.outfit(fontSize:20),
        ),

        content: Text(
          "Are you sure you want to logout?",
          style: GoogleFonts.poppins(fontSize:14),
        ),

        actions:[

          TextButton(
            onPressed: ()=>Navigator.pop(context),
            child: const Text("Cancel"),
          ),

          ElevatedButton(

            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),

            onPressed: () async {

              await FirebaseAuth.instance.signOut();

              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.login,
                    (route)=>false,
              );
            },

            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // SWIPE HINT
  // =====================================================

  Widget _swipeBackHint(){

    return Row(

      mainAxisAlignment: MainAxisAlignment.center,

      children: [

        Icon(
          Icons.arrow_back_ios_new_rounded,
          size:14,
          color: AppColors.textLight.withValues(alpha: 0.6),
        ),

        const SizedBox(width:8),

        Text(
          "Swipe right to go back",
          style: GoogleFonts.poppins(
            fontSize:13,
            color: AppColors.textLight.withValues(alpha: 0.9),
          ),
        ),
      ],
    );
  }
}
