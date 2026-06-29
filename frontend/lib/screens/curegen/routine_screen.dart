import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '/constants.dart';
import 'routine_detail_screen.dart';

class RoutineScreen extends StatefulWidget {
  const RoutineScreen({super.key});

  @override
  State<RoutineScreen> createState() => _RoutineScreenState();
}

class _RoutineScreenState extends State<RoutineScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _pulseController;

  // -------------------------------------------------------
  // ROUTINE DATA
  // -------------------------------------------------------

  final List<Map<String, dynamic>> routines = [

    {
      "skin":"Dry Skin",
      "morning":[
        "Hydrating Cleanser",
        "Hyaluronic Acid Serum",
        "Rich Moisturizer",
        "SPF 50 Sunscreen"
      ],
      "night":[
        "Gentle Cleanser",
        "Niacinamide Serum",
        "Deep Moisturizer"
      ]
    },

    {
      "skin":"Oily Skin",
      "morning":[
        "Foaming Cleanser",
        "Salicylic Acid Serum",
        "Oil Free Moisturizer",
        "SPF 50 Sunscreen"
      ],
      "night":[
        "Gel Cleanser",
        "Niacinamide Serum",
        "Light Moisturizer"
      ]
    },

    {
      "skin":"Acne Prone",
      "morning":[
        "Acne Cleanser",
        "Salicylic Acid",
        "Oil Free Moisturizer",
        "SPF 50"
      ],
      "night":[
        "Gentle Cleanser",
        "Retinol Treatment",
        "Moisturizer"
      ]
    },

    {
      "skin":"Sensitive Skin",
      "morning":[
        "Gentle Cleanser",
        "Centella Serum",
        "Barrier Moisturizer",
        "SPF 50"
      ],
      "night":[
        "Gentle Cleanser",
        "Soothing Serum",
        "Moisturizer"
      ]
    },

    {
      "skin":"Combination Skin",
      "morning":[
        "Balancing Cleanser",
        "Niacinamide Serum",
        "Light Moisturizer",
        "SPF 50"
      ],
      "night":[
        "Cleanser",
        "Hydrating Serum",
        "Moisturizer"
      ]
    },

    {
      "skin":"Aging Skin",
      "morning":[
        "Gentle Cleanser",
        "Vitamin C Serum",
        "Firming Moisturizer",
        "SPF 50"
      ],
      "night":[
        "Cleanser",
        "Retinol Treatment",
        "Night Cream"
      ]
    }

  ];

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  // -------------------------------------------------------
  // BUILD
  // -------------------------------------------------------

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: AppColors.background,

      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),

        slivers: [

          _buildAppBar(),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),

            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context,index)=>_routineCard(routines[index],index),
                childCount: routines.length,
              ),
            ),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: 40),
          )

        ],
      ),
    );
  }

  // -------------------------------------------------------
  // APP BAR
  // -------------------------------------------------------

  Widget _buildAppBar(){

    return SliverAppBar(

      expandedHeight: 180,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.transparent,

      flexibleSpace: FlexibleSpaceBar(

        titlePadding: const EdgeInsets.only(left:20,bottom:16),

        title: Text(
          "Skin Care Routines",
          style: GoogleFonts.outfit(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
          ),
        ),

        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white,
                AppColors.background
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------
  // ROUTINE CARD
  // -------------------------------------------------------

  Widget _routineCard(Map<String,dynamic> routine,int index){

    return GestureDetector(

      onTap:(){

        Navigator.push(
          context,
          MaterialPageRoute(
            builder:(_)=>RoutineDetailScreen(routine:routine),
          ),
        );
      },

      child: Container(

        margin: const EdgeInsets.only(bottom:18),

        padding: const EdgeInsets.all(18),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),

          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(.06),
              blurRadius: 20,
              offset: const Offset(0,8),
            )
          ],
        ),

        child: Row(

          children: [

            // ICON
            Container(
              width: 55,
              height: 55,

              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(.12),
                borderRadius: BorderRadius.circular(16),
              ),

              child: const Icon(
                Icons.spa_rounded,
                size: 26,
                color: Colors.pinkAccent,
              ),
            ),

            const SizedBox(width:16),

            // TEXT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    routine["skin"],
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),

                  const SizedBox(height:4),

                  Text(
                    "Tap to view routine",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: AppColors.textLight,
                    ),
                  ),

                ],
              ),
            ),

            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: AppColors.textLight,
            )

          ],
        ),
      )
          .animate()
          .fadeIn(delay:(150 + index*120).ms)
          .slideY(begin:0.2),
    );
  }
}
