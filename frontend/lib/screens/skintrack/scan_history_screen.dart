import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants.dart';
import '../../services/api_service.dart';

class ScanHistoryScreen extends StatefulWidget {
  const ScanHistoryScreen({super.key});

  @override
  State<ScanHistoryScreen> createState() => _ScanHistoryScreenState();
}

class _ScanHistoryScreenState extends State<ScanHistoryScreen> {

  List history = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  // ===============================
  // LOAD HISTORY
  // ===============================

  Future<void> loadHistory() async {

    try {

      final data = await ApiService.getScanHistory();

      setState(() {
        history = data.reversed.toList();
        loading = false;
      });

    } catch (e) {

      setState(() {
        loading = false;
      });
    }
  }

  // ===============================
  // BUILD
  // ===============================

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: AppColors.background,

      appBar: AppBar(

        elevation: 0,
        backgroundColor: Colors.white,

        title: Text(
          "Scan History",
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : history.isEmpty
          ? _emptyState()
          : ListView.builder(

        padding: const EdgeInsets.all(20),

        itemCount: history.length,

        itemBuilder: (context, index) {

          final item = history[index];

          final score = item["skin_score"] ?? 0;

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

                // ICON

                Container(
                  padding: const EdgeInsets.all(12),

                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(.1),
                    borderRadius: BorderRadius.circular(12),
                  ),

                  child: Icon(
                    Icons.analytics_rounded,
                    color: AppColors.primary,
                  ),
                ),

                const SizedBox(width: 14),

                // DETAILS

                Expanded(
                  child: Column(

                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [

                      Text(
                        item["issue"] ?? "Unknown",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        "Severity: ${item["severity"] ?? "Unknown"}",
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: AppColors.textLight,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        item["date"] ?? "",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),

                    ],
                  ),
                ),

                // SCORE BADGE

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
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ===============================
  // EMPTY STATE
  // ===============================

  Widget _emptyState() {

    return Center(

      child: Text(
        "No scans yet",
        style: GoogleFonts.poppins(
          fontSize: 16,
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
