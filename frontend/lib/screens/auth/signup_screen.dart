import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../widgets/custom_textfield.dart';
import '../../constants.dart';
import '../../routes.dart';

// ======================================================
// GlowScanAI Signup Screen
// Clean UI (matching Login screen design)
// ======================================================

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with SingleTickerProviderStateMixin {

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _loading = false;
  bool _agree = false;
  bool _obscure1 = true;
  bool _obscure2 = true;

  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    _slide = Tween(
      begin: const Offset(0, 0.10),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    _controller.dispose();
    super.dispose();
  }

  // ======================================================
  // TERMS MODAL
  // ======================================================

  void _showTerms() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(26),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              Text(
                "Terms & Conditions",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 18),

              Text(
                "• Provide accurate information\n"
                    "• Allow GlowScanAI to process scan data\n"
                    "• Do not misuse AI results\n"
                    "• Follow our privacy policy\n"
                    "• Must be 13+ to register",
                style: GoogleFonts.poppins(fontSize: 14, height: 1.5),
              ),

              const SizedBox(height: 22),

              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  "I Understand",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ======================================================
  // PASSWORD VALIDATION
  // ======================================================

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return "Password required";

    final hasUpper = RegExp(r'[A-Z]').hasMatch(value);
    final hasLower = RegExp(r'[a-z]').hasMatch(value);
    final hasDigit = RegExp(r'[0-9]').hasMatch(value);
    final hasSpecial = RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(value);

    if (value.length < 8) return "Minimum 8 characters required";
    if (!hasUpper) return "Add 1 uppercase letter";
    if (!hasLower) return "Add 1 lowercase letter";
    if (!hasDigit) return "Add 1 number";
    if (!hasSpecial) return "Add 1 special character";

    return null;
  }

  // ======================================================
  // SIGNUP
  // ======================================================

  Future<void> _signup() async {

    if (!_agree) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please accept Terms & Conditions")),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {

      final cred = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final user = cred.user;
      if (user == null) throw Exception("Signup failed");

      await user.updateDisplayName(nameController.text.trim());

      if (!mounted) return;

      Navigator.pushReplacementNamed(
        context,
        AppRoutes.profileSetup,
      );

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );

    }

    setState(() => _loading = false);
  }

  // ======================================================
  // UI
  // ======================================================

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(

        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFFF1F8),
              Color(0xFFFFE5EF),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 26,
              vertical: 20,
            ),

            child: AnimatedBuilder(
              animation: _controller,

              builder: (_, child) => Opacity(
                opacity: _fade.value,
                child: SlideTransition(
                  position: _slide,
                  child: child,
                ),
              ),

              child: Column(
                children: [

                  const SizedBox(height: 40),

                  // HEADER

                  Text(
                    "Create Account",
                    style: GoogleFonts.outfit(
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "Join GlowScanAI for personalized skincare",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: AppColors.textLight,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // FORM CARD

                  Container(
                    padding: const EdgeInsets.all(22),

                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        )
                      ],
                    ),

                    child: Form(
                      key: _formKey,

                      child: Column(
                        children: [

                          CustomTextField(
                            controller: nameController,
                            label: "Full Name",
                            hint: "Your name",
                            validator: (v) =>
                            v == null || v.isEmpty
                                ? "Name required"
                                : null,
                          ),

                          const SizedBox(height: 18),

                          CustomTextField(
                            controller: emailController,
                            label: "Email Address",
                            hint: "you@example.com",
                            validator: (v) =>
                            v!.contains("@")
                                ? null
                                : "Enter valid email",
                          ),

                          const SizedBox(height: 18),

                          CustomTextField(
                            controller: passwordController,
                            label: "Password",
                            hint: "Enter password",
                            obscure: _obscure1,
                            prefix: Icon(Icons.lock_rounded,
                                color: AppColors.primary),

                            suffix: IconButton(
                              icon: Icon(
                                _obscure1
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () =>
                                  setState(() => _obscure1 = !_obscure1),
                            ),

                            validator: validatePassword,
                          ),

                          const SizedBox(height: 18),

                          CustomTextField(
                            controller: confirmPasswordController,
                            label: "Confirm Password",
                            hint: "Re-enter password",
                            obscure: _obscure2,
                            prefix: Icon(Icons.lock_rounded,
                                color: AppColors.primary),

                            suffix: IconButton(
                              icon: Icon(
                                _obscure2
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () =>
                                  setState(() => _obscure2 = !_obscure2),
                            ),

                            validator: (v) =>
                            v != passwordController.text
                                ? "Passwords do not match"
                                : null,
                          ),

                          const SizedBox(height: 16),

                          // TERMS

                          Row(
                            children: [

                              Checkbox(
                                value: _agree,
                                activeColor: AppColors.primary,
                                onChanged: (v) =>
                                    setState(() => _agree = v!),
                              ),

                              Expanded(
                                child: GestureDetector(
                                  onTap: _showTerms,

                                  child: Text.rich(
                                    TextSpan(
                                      text: "I agree to the ",
                                      style: GoogleFonts.poppins(fontSize: 14),

                                      children: [
                                        TextSpan(
                                          text: "Terms & Conditions",
                                          style: GoogleFonts.poppins(
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.w600,
                                            decoration:
                                            TextDecoration.underline,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 18),

                          // CREATE ACCOUNT BUTTON

                          SizedBox(
                            width: double.infinity,
                            height: 54,

                            child: ElevatedButton(
                              onPressed: _loading ? null : _signup,

                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),

                              child: _loading
                                  ? const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              )
                                  : Text(
                                "Create Account",
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // LOGIN CTA

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Text(
                        "Already have an account?",
                        style: GoogleFonts.poppins(
                          color: AppColors.textLight,
                        ),
                      ),

                      TextButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, AppRoutes.login),

                        child: Text(
                          "Login",
                          style: GoogleFonts.poppins(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
