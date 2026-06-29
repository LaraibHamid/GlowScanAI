import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants.dart';

class NoInternetScreen extends StatefulWidget {
  final VoidCallback? onRetry;

  const NoInternetScreen({super.key, this.onRetry});

  @override
  State<NoInternetScreen> createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  bool _isChecking = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _checkConnection() async {

    setState(() => _isChecking = true);

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() => _isChecking = false);

    if (widget.onRetry != null) {
      widget.onRetry!();
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {

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

                  _iconSection()
                      .animate()
                      .fadeIn(duration: 600.ms)
                      .scale(delay: 200.ms, duration: 800.ms),

                  const SizedBox(height: 48),

                  _title(),

                  const SizedBox(height: 16),

                  _description(),

                  const SizedBox(height: 48),

                  _troubleshootingCard(),

                  const SizedBox(height: 32),

                  _actionButtons(),

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

  // ------------------------------------------------
  // ICON SECTION
  // ------------------------------------------------

  Widget _iconSection() {

    return Stack(
      alignment: Alignment.center,
      children: [

        AnimatedBuilder(
          animation: _controller,
          builder: (_, child) {
            return Transform.rotate(
              angle: _controller.value * 2 * 3.14159,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.orange.withValues(alpha: 0.2),
                    width: 2,
                  ),
                ),
                child: CustomPaint(
                  painter: _DashedCirclePainter(
                    color: Colors.orange.withValues(alpha: 0.3),
                  ),
                ),
              ),
            );
          },
        ),

        Container(
          width: 160,
          height: 160,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.orange.withValues(alpha: 0.12),
          ),
        )
            .animate(onPlay: (c) => c.repeat())
            .scale(duration: 2000.ms, begin: const Offset(1, 1), end: const Offset(1.15, 1.15))
            .then()
            .scale(duration: 2000.ms, begin: const Offset(1.15, 1.15), end: const Offset(1, 1)),

        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Colors.orange, Colors.deepOrange],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.orange.withValues(alpha: 0.4),
                blurRadius: 35,
                spreadRadius: 5,
                offset: const Offset(0, 12),
              ),
            ],
          ),

          child: Stack(
            alignment: Alignment.center,
            children: [

              const Icon(
                Icons.wifi_off_rounded,
                size: 50,
                color: Colors.white,
              ),

              Positioned(
                bottom: 20,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    size: 20,
                    color: Colors.orange,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------
  // TITLE
  // ------------------------------------------------

  Widget _title() {

    return Text(
      "No Internet Connection",
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

  // ------------------------------------------------
  // DESCRIPTION
  // ------------------------------------------------

  Widget _description() {

    return Text(
      "Please check your Wi-Fi or mobile data connection and try again.",
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

  // ------------------------------------------------
  // TROUBLESHOOTING CARD
  // ------------------------------------------------

  Widget _troubleshootingCard() {

    final tips = [
      "Check if Wi-Fi is turned on",
      "Verify mobile data is enabled",
      "Turn off Airplane mode",
      "Check router connection"
    ];

    return Container(

      padding: const EdgeInsets.all(24),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
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
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.info_rounded, color: Colors.blue),
              ),

              const SizedBox(width: 14),

              Text(
                "Troubleshooting Tips",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          ...tips.map(
                (tip) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [

                  const Icon(Icons.circle,
                      size: 8,
                      color: Colors.orange),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Text(
                      tip,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: AppColors.textLight,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------
  // BUTTONS
  // ------------------------------------------------

  Widget _actionButtons() {

    return Column(
      children: [

        ElevatedButton.icon(
          onPressed: _isChecking ? null : _checkConnection,
          icon: _isChecking
              ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white))
              : const Icon(Icons.refresh_rounded),

          label: Text(
            _isChecking ? "Checking..." : "Try Again",
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700),
          ),

          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            padding: const EdgeInsets.symmetric(
                horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------
  // SWIPE HINT
  // ------------------------------------------------

  Widget _swipeHint() {

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        Icon(Icons.arrow_back_ios_rounded,
            size: 16,
            color: AppColors.textLight.withValues(alpha: 0.5)),

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
}

// ------------------------------------------------
// DASHED CIRCLE PAINTER
// ------------------------------------------------

class _DashedCirclePainter extends CustomPainter {

  final Color color;

  _DashedCirclePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final radius = size.width / 2;
    final center = Offset(size.width / 2, size.height / 2);

    const dashWidth = 10.0;
    const dashSpace = 5.0;

    double startAngle = 0;

    while (startAngle < 360) {

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle * (3.14159 / 180),
        dashWidth * (3.14159 / 180),
        false,
        paint,
      );

      startAngle += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
