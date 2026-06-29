import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants.dart';

enum ErrorType {
  general,
  network,
  server,
  notFound,
  permission,
  timeout,
}

class ErrorScreen extends StatelessWidget {
  final String? message;
  final ErrorType errorType;
  final VoidCallback? onRetry;
  final String? errorCode;

  const ErrorScreen({
    super.key,
    this.message,
    this.errorType = ErrorType.general,
    this.onRetry,
    this.errorCode,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getErrorConfig();

    final Color color = config["color"];
    final IconData icon = config["icon"];
    final String title = config["title"];
    final String defaultMessage = config["message"];

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: const SizedBox(),
      ),

      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity != null &&
              details.primaryVelocity! > 0) {
            Navigator.pop(context);
          }
        },

        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  _errorIcon(icon, color),

                  const SizedBox(height: 48),

                  _title(title),

                  const SizedBox(height: 16),

                  _message(message ?? defaultMessage),

                  if (errorCode != null) ...[
                    const SizedBox(height: 16),
                    _errorCode(),
                  ],

                  const SizedBox(height: 48),

                  _actionButtons(context, color),

                  const SizedBox(height: 24),

                  _supportCard(),

                  const SizedBox(height: 32),

                  _swipeHint(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --------------------------------------------------
  // ERROR ICON
  // --------------------------------------------------

  Widget _errorIcon(IconData icon, Color color) {
    return Stack(
      alignment: Alignment.center,
      children: [

        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: 0.08),
          ),
        )
            .animate(onPlay: (c) => c.repeat())
            .scale(duration: 2000.ms, begin: const Offset(1, 1), end: const Offset(1.1, 1.1))
            .then()
            .scale(duration: 2000.ms, begin: const Offset(1.1, 1.1), end: const Offset(1, 1)),

        Container(
          width: 160,
          height: 160,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: 0.12),
          ),
        )
            .animate(onPlay: (c) => c.repeat())
            .scale(duration: 1800.ms, begin: const Offset(1, 1), end: const Offset(1.15, 1.15))
            .then()
            .scale(duration: 1800.ms, begin: const Offset(1.15, 1.15), end: const Offset(1, 1)),

        Container(
          width: 120,
          height: 120,

          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [color, color.withValues(alpha: 0.7)],
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.4),
                blurRadius: 35,
                spreadRadius: 5,
                offset: const Offset(0, 12),
              ),
            ],
          ),

          child: Icon(
            icon,
            size: 60,
            color: Colors.white,
          ),
        )
            .animate()
            .fadeIn(duration: 600.ms)
            .scale(delay: 200.ms, duration: 800.ms, curve: Curves.elasticOut)
            .shake(delay: 1000.ms),
      ],
    );
  }

  // --------------------------------------------------
  // TITLE
  // --------------------------------------------------

  Widget _title(String title) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: GoogleFonts.outfit(
        fontSize: 30,
        fontWeight: FontWeight.w800,
        color: AppColors.textDark,
      ),
    )
        .animate()
        .fadeIn(delay: 400.ms)
        .slideY(begin: 0.3);
  }

  // --------------------------------------------------
  // MESSAGE
  // --------------------------------------------------

  Widget _message(String message) {
    return Text(
      message,
      textAlign: TextAlign.center,
      style: GoogleFonts.poppins(
        fontSize: 15,
        height: 1.6,
        color: AppColors.textLight,
      ),
    )
        .animate()
        .fadeIn(delay: 600.ms)
        .slideY(begin: 0.3);
  }

  // --------------------------------------------------
  // ERROR CODE
  // --------------------------------------------------

  Widget _errorCode() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),

      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [

          Icon(Icons.code_rounded,
              size: 16,
              color: AppColors.textLight),

          const SizedBox(width: 6),

          Text(
            "Error Code: $errorCode",
            style: GoogleFonts.robotoMono(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textLight,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 800.ms);
  }

  // --------------------------------------------------
  // BUTTONS
  // --------------------------------------------------

  Widget _actionButtons(BuildContext context, Color color) {
    return Column(
      children: [

        if (onRetry != null)
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text("Try Again"),
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),

        const SizedBox(height: 16),

        OutlinedButton.icon(
          onPressed: () {
            Navigator.of(context)
                .popUntil((route) => route.isFirst);
          },
          icon: const Icon(Icons.home_rounded),
          label: const Text("Back to Home"),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: color, width: 2),
            padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ],
    ).animate().fadeIn(delay: 1000.ms);
  }

  // --------------------------------------------------
  // SUPPORT CARD
  // --------------------------------------------------

  Widget _supportCard() {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [

          Icon(Icons.support_agent_rounded,
              color: Colors.blue.shade700),

          const SizedBox(width: 12),

          Text(
            "Need help? Contact support",
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.blue.shade900,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 1200.ms);
  }

  // --------------------------------------------------
  // SWIPE HINT
  // --------------------------------------------------

  Widget _swipeHint() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        Icon(
          Icons.arrow_back_ios_rounded,
          size: 16,
          color: AppColors.textLight.withValues(alpha: 0.5),
        ),

        const SizedBox(width: 12),

        Text(
          "Swipe right to go back",
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.textLight,
          ),
        ),
      ],
    )
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .fadeIn(duration: 1000.ms)
        .then()
        .fadeOut(duration: 1000.ms);
  }

  // --------------------------------------------------
  // ERROR CONFIG
  // --------------------------------------------------

  Map<String, dynamic> _getErrorConfig() {

    switch (errorType) {

      case ErrorType.network:
        return {
          "icon": Icons.wifi_off_rounded,
          "title": "No Internet Connection",
          "message":
          "Please check your internet connection and try again.",
          "color": Colors.orange,
        };

      case ErrorType.server:
        return {
          "icon": Icons.cloud_off_rounded,
          "title": "Server Error",
          "message":
          "Our servers are currently experiencing issues.",
          "color": Colors.red,
        };

      case ErrorType.notFound:
        return {
          "icon": Icons.search_off_rounded,
          "title": "Page Not Found",
          "message":
          "The page you're looking for doesn't exist.",
          "color": const Color(0xFF6B73FF),
        };

      case ErrorType.permission:
        return {
          "icon": Icons.lock_rounded,
          "title": "Permission Denied",
          "message":
          "You don't have permission to access this content.",
          "color": Colors.deepOrange,
        };

      case ErrorType.timeout:
        return {
          "icon": Icons.timer_off_rounded,
          "title": "Request Timeout",
          "message":
          "The request took too long to complete.",
          "color": Colors.amber,
        };

      default:
        return {
          "icon": Icons.error_outline_rounded,
          "title": "Oops! Something Went Wrong",
          "message":
          "An unexpected error occurred. Please try again.",
          "color": AppColors.primary,
        };
    }
  }
}
