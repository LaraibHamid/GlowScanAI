import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants.dart';

class EmptyStateScreen extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;

  final VoidCallback? onAction;
  final String? actionLabel;

  final Color? iconColor;
  final String? subtitle;

  final bool showBackButton;

  const EmptyStateScreen({
    super.key,
    required this.title,
    required this.message,
    required this.icon,
    this.onAction,
    this.actionLabel,
    this.iconColor,
    this.subtitle,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {

    final displayIconColor = iconColor ?? AppColors.primary;

    return Scaffold(

      backgroundColor: AppColors.background,

      appBar: showBackButton
          ? AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: const SizedBox(),
      )
          : null,

      body: GestureDetector(

        onHorizontalDragEnd: showBackButton
            ? (details) {
          if (details.primaryVelocity != null &&
              details.primaryVelocity! > 0) {
            Navigator.pop(context);
          }
        }
            : null,

        child: SafeArea(

          child: Center(

            child: SingleChildScrollView(

              padding: const EdgeInsets.all(32),

              child: Column(

                mainAxisAlignment: MainAxisAlignment.center,

                children: [

                  _iconSection(displayIconColor),

                  const SizedBox(height: 48),

                  _titleSection(),

                  if (subtitle != null) _subtitleSection(displayIconColor),

                  const SizedBox(height: 16),

                  _messageSection(),

                  if (onAction != null) _actionButton(displayIconColor),

                  showBackButton
                      ? _swipeHint()
                      : _decorativeDots(displayIconColor),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --------------------------------------------------
  // ICON SECTION
  // --------------------------------------------------

  Widget _iconSection(Color displayIconColor) {

    return Stack(

      alignment: Alignment.center,

      children: [

        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: displayIconColor.withValues(alpha: 0.08),
          ),
        )
            .animate(onPlay: (controller) => controller.repeat())
            .scale(duration: 2000.ms, begin: const Offset(1, 1), end: const Offset(1.1, 1.1))
            .then()
            .scale(duration: 2000.ms, begin: const Offset(1.1, 1.1), end: const Offset(1, 1)),

        Container(
          width: 160,
          height: 160,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: displayIconColor.withValues(alpha: 0.12),
          ),
        )
            .animate(onPlay: (controller) => controller.repeat())
            .scale(duration: 1800.ms, begin: const Offset(1, 1), end: const Offset(1.15, 1.15))
            .then()
            .scale(duration: 1800.ms, begin: const Offset(1.15, 1.15), end: const Offset(1, 1)),

        Container(
          width: 120,
          height: 120,

          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                displayIconColor,
                displayIconColor.withValues(alpha: 0.7)
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: displayIconColor.withValues(alpha: 0.4),
                blurRadius: 35,
                spreadRadius: 5,
                offset: const Offset(0, 12),
              )
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
            .scale(delay: 200.ms, duration: 800.ms, curve: Curves.elasticOut),
      ],
    );
  }

  // --------------------------------------------------
  // TITLE
  // --------------------------------------------------

  Widget _titleSection() {

    return Text(
      title,
      textAlign: TextAlign.center,
      style: GoogleFonts.outfit(
        fontSize: 30,
        fontWeight: FontWeight.w800,
        color: AppColors.textDark,
        letterSpacing: -1,
      ),
    )
        .animate()
        .fadeIn(delay: 400.ms, duration: 600.ms)
        .slideY(begin: 0.3);
  }

  // --------------------------------------------------
  // SUBTITLE
  // --------------------------------------------------

  Widget _subtitleSection(Color color) {

    return Column(
      children: [
        const SizedBox(height: 8),
        Text(
          subtitle!,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        )
            .animate()
            .fadeIn(delay: 500.ms, duration: 600.ms)
            .slideY(begin: 0.3),
      ],
    );
  }

  // --------------------------------------------------
  // MESSAGE
  // --------------------------------------------------

  Widget _messageSection() {

    return Text(
      message,
      textAlign: TextAlign.center,
      style: GoogleFonts.poppins(
        fontSize: 15,
        color: AppColors.textLight,
        height: 1.6,
      ),
    )
        .animate()
        .fadeIn(delay: 600.ms, duration: 600.ms)
        .slideY(begin: 0.3);
  }

  // --------------------------------------------------
  // ACTION BUTTON
  // --------------------------------------------------

  Widget _actionButton(Color color) {

    return Container(

      margin: const EdgeInsets.only(top: 40),

      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withValues(alpha: 0.8)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.4),
            blurRadius: 25,
            offset: const Offset(0, 10),
          )
        ],
      ),

      child: Material(
        color: Colors.transparent,

        child: InkWell(

          borderRadius: BorderRadius.circular(16),

          onTap: onAction,

          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 32,
              vertical: 16,
            ),

            child: Row(
              mainAxisSize: MainAxisSize.min,

              children: [

                const Icon(Icons.add_rounded,
                    color: Colors.white,
                    size: 24),

                const SizedBox(width: 12),

                Text(
                  actionLabel ?? "Get Started",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(delay: 800.ms)
        .slideY(begin: 0.3);
  }

  // --------------------------------------------------
  // SWIPE HINT
  // --------------------------------------------------

  Widget _swipeHint() {

    return Column(
      children: [

        const SizedBox(height: 48),

        Row(
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
                color: AppColors.textLight,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        )
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .fadeIn(duration: 1000.ms)
            .then()
            .fadeOut(duration: 1000.ms),
      ],
    );
  }

  // --------------------------------------------------
  // DOTS
  // --------------------------------------------------

  Widget _decorativeDots(Color color) {

    return Column(
      children: [

        const SizedBox(height: 48),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,

          children: List.generate(
            3,
                (index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
            )
                .animate(onPlay: (controller) => controller.repeat())
                .fadeIn(delay: (index * 200).ms, duration: 600.ms)
                .then()
                .fadeOut(duration: 600.ms),
          ),
        ),
      ],
    );
  }
}
