import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../constants.dart';
import '../../routes.dart';
import '../../widgets/bottom_navbar.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {

  int _currentIndex = 0;
  String _userName = "User";

  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    );

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    _slide = Tween(
      begin: const Offset(0,0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _controller.forward();
    _loadUser();
  }

  void _loadUser() {
    final user = FirebaseAuth.instance.currentUser;
    _userName = user?.displayName ?? "User";
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap(int index) {

    setState(()=> _currentIndex = index);

    switch(index){

      case 1:
        Navigator.pushNamed(context, AppRoutes.scanSelection);
        break;

      case 2:
        Navigator.pushNamed(context, AppRoutes.chatbot);
        break;

      case 3:
        Navigator.pushNamed(context, AppRoutes.profile);
        break;
    }
  }

  String _greeting(){
    final h = DateTime.now().hour;

    if(h < 12) return "Good Morning";
    if(h < 17) return "Good Afternoon";
    return "Good Evening";
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Container(

        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors:[
              Color(0xFFFFF4F8),
              Color(0xFFFFE6EE)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: SafeArea(

          child: AnimatedBuilder(

            animation: _controller,

            builder:(_,child)=>Opacity(
              opacity:_fade.value,
              child: SlideTransition(
                position:_slide,
                child: child,
              ),
            ),

            child: SingleChildScrollView(

              physics: const BouncingScrollPhysics(),

              padding: const EdgeInsets.fromLTRB(24,10,24,90),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  _header(),

                  const SizedBox(height:28),

                  _startScanCard(),

                  const SizedBox(height:28),

                  _quickActions(),

                  const SizedBox(height:28),

                  _dailyTips(),

                ],
              ),
            ),
          ),
        ),
      ),

      bottomNavigationBar:
      BottomNavBar(currentIndex:_currentIndex,onTap:_onTap),
    );
  }

  // HEADER

  Widget _header(){

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,

      children:[

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              _greeting(),
              style: GoogleFonts.poppins(
                fontSize:14,
                color: AppColors.textLight,
              ),
            ),

            const SizedBox(height:4),

            Text(
              _userName,
              style: GoogleFonts.outfit(
                fontSize:30,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
              ),
            ),

          ],
        ),

        Row(
          children: [

            GestureDetector(
              onTap:()=>Navigator.pushNamed(context, AppRoutes.settings),

              child: Container(
                padding: const EdgeInsets.all(10),

                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),

                child: const Icon(
                  Icons.settings_rounded,
                  size:22,
                ),
              ),
            ),

            const SizedBox(width:12),

            GestureDetector(

              onTap:()=>Navigator.pushNamed(context, AppRoutes.profile),

              child: CircleAvatar(
                radius:24,
                backgroundColor: Colors.white,

                child: Text(
                  _userName.isNotEmpty
                      ? _userName[0].toUpperCase()
                      : "U",

                  style: GoogleFonts.outfit(
                    fontSize:22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  // SCAN CARD

  Widget _startScanCard(){

    return Container(

      width: double.infinity,

      padding: const EdgeInsets.all(26),

      decoration: BoxDecoration(

        gradient: const LinearGradient(
          colors:[
            Color(0xFFFB6F92),
            Color(0xFFFF8FAB),
            Color(0xFFFFB3C6)
          ],
        ),

        borderRadius: BorderRadius.circular(24),

      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children:[

          Text(
            "AI Skin Analysis",
            style: GoogleFonts.outfit(
              fontSize:26,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),

          const SizedBox(height:6),

          Text(
            "Powered by GlowScanAI",
            style: GoogleFonts.poppins(
              color: Colors.white70,
              fontSize:14,
            ),
          ),

          const SizedBox(height:22),

          GestureDetector(
            onTap:()=>Navigator.pushNamed(context, AppRoutes.scanSelection),

            child: Container(
              padding: const EdgeInsets.symmetric(vertical:14),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [

                  Icon(Icons.camera_alt_rounded,
                      color: AppColors.primary),

                  const SizedBox(width:10),

                  Text(
                    "Start Scan",
                    style: GoogleFonts.poppins(
                      fontSize:16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // QUICK ACTIONS

  Widget _quickActions(){

    final List<Map<String,dynamic>> items=[

      {
        "title":"Routines",
        "subtitle":"AI skincare plans",
        "icon":Icons.local_offer_rounded, // onboarding match
        "color":const Color(0xFF8ACB88),
        "route":AppRoutes.routines,
      },

      {
        "title":"Track",
        "subtitle":"Your progress",
        "icon":Icons.show_chart_rounded,
        "color":const Color(0xFF6B73FF),
        "route":AppRoutes.log,
      },

      {
        "title":"GlowMate",
        "subtitle":"Chat support",
        "icon":Icons.chat_bubble_rounded,
        "color":const Color(0xFFFFB74D),
        "route":AppRoutes.chatbot,
      },

      {
        "title":"History",
        "subtitle":"Scan records",
        "icon":Icons.history_rounded,
        "color":const Color(0xFFFB6F92),
        "route":AppRoutes.history,
      },

    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children:[

        Text(
          "Quick Actions",
          style: GoogleFonts.outfit(
            fontSize:24,
            fontWeight: FontWeight.w800,
          ),
        ),

        const SizedBox(height:16),

        GridView.builder(

          shrinkWrap:true,
          physics: const NeverScrollableScrollPhysics(),

          itemCount:items.length,

          gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount:2,
            crossAxisSpacing:14,
            mainAxisSpacing:14,
            childAspectRatio:1.10,
          ),

          itemBuilder:(context,i)=>_quickActionItem(items[i]),

        )
      ],
    );
  }

  Widget _quickActionItem(Map<String,dynamic> item){

    return GestureDetector(

      onTap:()=>Navigator.pushNamed(context, item["route"] as String),

      child: Container(

        padding: const EdgeInsets.all(18),

        decoration: BoxDecoration(
          color:(item["color"] as Color).withValues(alpha: .12),
          borderRadius: BorderRadius.circular(20),
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,

          children:[

            Container(

              padding: const EdgeInsets.all(14),

              decoration: BoxDecoration(
                color:item["color"] as Color,
                borderRadius: BorderRadius.circular(16),
              ),

              child: Icon(
                item["icon"] as IconData,
                color: Colors.white,
                size:26,
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children:[

                Text(
                  item["title"] as String,
                  style: GoogleFonts.poppins(
                    fontSize:16,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                Text(
                  item["subtitle"] as String,
                  style: GoogleFonts.poppins(
                    fontSize:12,
                    color: AppColors.textLight,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  // DAILY TIPS (REPLACED STREAK)

  Widget _dailyTips(){

    return Container(

      padding: const EdgeInsets.all(22),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow:[
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius:16,
            offset: const Offset(0,8),
          )
        ],
      ),

      child: Row(

        children:[

          const Icon(
            Icons.lightbulb_outline_rounded,
            color: AppColors.primary,
            size:30,
          ),

          const SizedBox(width:16),

          Expanded(
            child: Text(
              "Cleanse your face twice daily and always apply sunscreen before going outdoors.",
              style: GoogleFonts.poppins(
                fontSize:14,
                height:1.4,
              ),
            ),
          ),

        ],
      ),
    );
  }

}
