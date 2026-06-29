import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final double? width;
  final bool filled;
  final bool isLoading;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width,
    this.filled = true,
    this.isLoading = false,
    this.icon,
    this.backgroundColor,
    this.textColor,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
    with SingleTickerProviderStateMixin {

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 140),
    );

    _scaleAnimation = Tween(begin: 1.0, end: 0.94).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails d) => _animationController.forward();
  void _onTapUp(TapUpDetails d) => _animationController.reverse();
  void _onTapCancel() => _animationController.reverse();

  @override
  Widget build(BuildContext context) {
    final Color bgColor = widget.backgroundColor ??
        (widget.filled ? AppColors.primary : Colors.transparent);

    final Color txtColor = widget.textColor ??
        (widget.filled ? Colors.white : AppColors.primary);

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapCancel: _onTapCancel,
      onTapUp: _onTapUp,
      onTap: widget.isLoading ? null : widget.onPressed,

      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (_, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              height: 56,
              width: widget.width ?? double.infinity,

              decoration: BoxDecoration(
                gradient: widget.filled && widget.backgroundColor == null
                    ? const LinearGradient(
                  colors: [
                    AppColors.primary,
                    Color(0xFFFFB3C6),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )
                    : null,
                color: widget.filled && widget.backgroundColor != null
                    ? bgColor
                    : null,
                borderRadius: BorderRadius.circular(AppRadii.medium),

                border: !widget.filled
                    ? Border.all(color: AppColors.primary, width: 2)
                    : null,

                boxShadow: widget.filled
                    ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ]
                    : null,
              ),

              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppRadii.medium),
                  onTap: widget.isLoading ? null : widget.onPressed,

                  child: Center(
                    child: widget.isLoading
                        ? SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(txtColor),
                      ),
                    )
                        : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.icon != null) ...[
                          Icon(widget.icon, size: 20, color: txtColor),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          widget.text,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: txtColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.15);
  }
}
