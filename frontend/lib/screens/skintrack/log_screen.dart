import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '/constants.dart';

class LogScreen extends StatefulWidget {
  const LogScreen({super.key});

  @override
  State<LogScreen> createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen>
    with SingleTickerProviderStateMixin {

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  // ===============================
  // FETCH LOGS
  // ===============================

  Stream<QuerySnapshot> getLogs() {

    final user = FirebaseAuth.instance.currentUser;

    return FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .collection("skin_logs")
        .orderBy("date", descending: true)
        .snapshots();
  }

  // ===============================
  // BUILD
  // ===============================

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: AppColors.background,

      body: StreamBuilder<QuerySnapshot>(

        stream: getLogs(),

        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final logs = snapshot.data!.docs;

          return CustomScrollView(

            physics: const BouncingScrollPhysics(),

            slivers: [

              _appBar(),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: _tabBar(),
                ),
              ),

              SliverFillRemaining(
                child: TabBarView(
                  controller: _tabController,
                  children: [

                    _chartView(logs),

                    _logList(logs),

                  ],
                ),
              ),

            ],
          );
        },
      ),
    );
  }

  // ===============================
  // APP BAR
  // ===============================

  Widget _appBar() {

    return SliverAppBar(

      expandedHeight: 170,
      pinned: true,
      elevation: 0,

      backgroundColor: AppColors.primary,

      flexibleSpace: FlexibleSpaceBar(

        titlePadding: const EdgeInsets.only(left: 20, bottom: 16),

        title: Text(
          "Skin Log",
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // ===============================
  // TAB BAR
  // ===============================

  Widget _tabBar() {

    return Container(

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),

      child: TabBar(

        controller: _tabController,

        indicator: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(16),
        ),

        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey,

        tabs: const [

          Tab(icon: Icon(Icons.show_chart), text: "Chart"),
          Tab(icon: Icon(Icons.list), text: "Entries"),

        ],
      ),
    );
  }

  // ===============================
  // CHART VIEW
  // ===============================

  Widget _chartView(List logs) {

    if (logs.isEmpty) {
      return _emptyState();
    }

    return Padding(
      padding: const EdgeInsets.all(20),
      child: _skinTrendChart(logs),
    );
  }

  // ===============================
  // LOG LIST
  // ===============================

  Widget _logList(List logs) {

    if (logs.isEmpty) {
      return _emptyState();
    }

    return ListView.builder(

      padding: const EdgeInsets.all(20),

      itemCount: logs.length,

      itemBuilder: (_, i) {

        final log = logs[i].data() as Map<String, dynamic>;

        int score = log["score"] ?? 0;
        String issue = log["issue"] ?? "";
        String note = log["note"] ?? "";

        final color = _scoreColor(score);

        return Container(

          margin: const EdgeInsets.only(bottom: 14),

          padding: const EdgeInsets.all(18),

          decoration: BoxDecoration(

            color: Colors.white,

            borderRadius: BorderRadius.circular(18),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.05),
                blurRadius: 8,
                offset: const Offset(0, 4),
              )
            ],
          ),

          child: Row(

            children: [

              Expanded(

                child: Column(

                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    Text(
                      issue,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      note,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: AppColors.textLight,
                      ),
                    ),

                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6),

                decoration: BoxDecoration(
                  color: color.withOpacity(.15),
                  borderRadius: BorderRadius.circular(12),
                ),

                child: Text(
                  "$score",
                  style: GoogleFonts.poppins(
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ===============================
  // CHART
  // ===============================

  Widget _skinTrendChart(List logs) {

    return Container(

      padding: const EdgeInsets.all(22),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 10,
          )
        ],
      ),

      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          Text(
            "Skin Score Trend",
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(

            height: 220,

            child: LineChart(

              LineChartData(

                maxY: 100,
                minY: 0,

                gridData: FlGridData(show: false),

                borderData: FlBorderData(show: false),

                lineBarsData: [

                  LineChartBarData(

                    isCurved: true,

                    spots: List.generate(

                      logs.length,

                          (i) {

                        final log =
                        logs[i].data() as Map<String, dynamic>;

                        return FlSpot(
                          i.toDouble(),
                          (log["score"] ?? 0).toDouble(),
                        );
                      },
                    ),

                    barWidth: 3,

                    color: AppColors.primary,

                    dotData: FlDotData(show: true),

                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===============================
  // EMPTY STATE
  // ===============================

  Widget _emptyState() {

    return Center(

      child: Text(
        "No logs available yet",
        style: GoogleFonts.poppins(
          fontSize: 15,
          color: AppColors.textLight,
        ),
      ),
    );
  }

  // ===============================
  // SCORE COLOR
  // ===============================

  Color _scoreColor(int score) {

    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;

    return Colors.red;
  }
}
