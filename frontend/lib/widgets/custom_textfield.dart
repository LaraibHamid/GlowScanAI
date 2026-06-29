import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String hint;
  final String? label;
  final bool obscure;
  final TextInputType keyboardType;
  final Widget? suffix;
  final Widget? prefix;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final bool readOnly;
  final int? maxLines;
  final int? maxLength;
  final FocusNode? focusNode;

  const CustomTextField({
    super.key,
    this.controller,
    required this.hint,
    this.label,
    this.obscure = false,
    this.keyboardType = TextInputType.text,
    this.suffix,
    this.prefix,
    this.validator,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.maxLines = 1,
    this.maxLength,
    this.focusNode,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _focusAnimation;
  late FocusNode _focusNode;

  bool _isFocused = false;

  @override
  void initState() {
    super.initState();

    _focusNode = widget.focusNode ?? FocusNode();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );

    _focusAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _focusNode.addListener(_handleFocus);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    _animationController.dispose();
    super.dispose();
  }

  void _handleFocus() {
    setState(() => _isFocused = _focusNode.hasFocus);

    if (_isFocused) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: GoogleFonts.poppins(
              color: AppColors.textDark,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ).animate().fadeIn(duration: 250.ms).slideX(begin: -0.2),
          const SizedBox(height: 8),
        ],

        AnimatedBuilder(
          animation: _focusAnimation,
          builder: (_, __) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadii.medium),
                boxShadow: [
                  BoxShadow(
                    color: _isFocused
                        ? AppColors.primary.withOpacity(0.22)
                        : Colors.black.withOpacity(0.06),
                    blurRadius: _isFocused ? 12 : 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextFormField(
                controller: widget.controller,
                focusNode: _focusNode,
                obscureText: widget.obscure,
                keyboardType: widget.keyboardType,
                validator: widget.validator,
                onChanged: widget.onChanged,
                onTap: widget.onTap,
                readOnly: widget.readOnly,
                maxLines: widget.maxLines,
                maxLength: widget.maxLength,
                style: GoogleFonts.poppins(
                  color: AppColors.textDark,
                  fontSize: 16,
                ),

                decoration: InputDecoration(
                  hintText: widget.hint,
                  hintStyle: GoogleFonts.poppins(
                    color: AppColors.textLight,
                    fontSize: 15,
                  ),
                  filled: true,
                  fillColor: AppColors.white,
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 16),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadii.medium),
                    borderSide: BorderSide.none,
                  ),

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadii.medium),
                    borderSide: BorderSide(color: AppColors.secondary, width: 1),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadii.medium),
                    borderSide: BorderSide(color: AppColors.primary, width: 2),
                  ),

                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadii.medium),
                    borderSide: BorderSide(color: AppColors.error, width: 1),
                  ),

                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadii.medium),
                    borderSide: BorderSide(color: AppColors.error, width: 2),
                  ),

                  suffixIcon: widget.suffix,
                  prefixIcon: widget.prefix,
                  counterText: widget.maxLength != null ? '' : null,
                ),
              ),
            );
          },
        ).animate().fadeIn(duration: 280.ms).slideY(begin: 0.15),
      ],
    );
  }
}
