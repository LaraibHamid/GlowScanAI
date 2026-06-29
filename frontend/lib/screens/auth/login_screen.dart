import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../routes.dart';
import '../../constants.dart';
import '../../widgets/custom_textfield.dart';

// ======================================================
// GlowScanAI Login Screen
// Clean + Professional UI
// ======================================================

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _loading = false;
  bool _obscure = true;

  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
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
    emailController.dispose();
    passwordController.dispose();
    _controller.dispose();
    super.dispose();
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
  // EMAIL LOGIN
  // ======================================================

  Future<void> _login() async {

    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (!mounted) return;

      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.dashboard,
            (route) => false,
      );

    } on FirebaseAuthException catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? "Login failed"),
          backgroundColor: Colors.redAccent,
        ),
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
              Color(0xFFFDF3FF),
              Color(0xFFFFEAF4),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 20),

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

                  // ==============================
                  // HEADER
                  // ==============================

                  Text(
                    "Welcome",
                    style: GoogleFonts.outfit(
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "Login to continue your skincare journey",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: AppColors.textLight,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // ==============================
                  // FORM CARD
                  // ==============================

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
                            controller: emailController,
                            label: "Email Address",
                            hint: "you@example.com",
                            keyboardType: TextInputType.emailAddress,
                            prefix: Icon(Icons.email_rounded,
                                color: AppColors.primary),
                            validator: (v) =>
                            v == null || v.isEmpty ? "Email required" : null,
                          ),

                          const SizedBox(height: 18),

                          CustomTextField(
                            controller: passwordController,
                            label: "Password",
                            hint: "Enter your password",
                            obscure: _obscure,
                            prefix: Icon(Icons.lock_rounded,
                                color: AppColors.primary),

                            suffix: IconButton(
                              icon: Icon(
                                _obscure
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () =>
                                  setState(() => _obscure = !_obscure),
                            ),

                            validator: validatePassword,
                          ),

                          const SizedBox(height: 8),

                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () => Navigator.pushNamed(
                                  context, AppRoutes.forgotPassword),

                              child: Text(
                                "Forgot Password?",
                                style: GoogleFonts.poppins(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // LOGIN BUTTON

                          SizedBox(
                            width: double.infinity,
                            height: 54,

                            child: ElevatedButton(
                              onPressed: _loading ? null : _login,

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
                                "Login",
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

                  const SizedBox(height: 26),

                  // ==============================
                  // SIGNUP CTA
                  // ==============================

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Text(
                        "Don't have an account?",
                        style: GoogleFonts.poppins(
                          color: AppColors.textLight,
                        ),
                      ),

                      TextButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, AppRoutes.signup),

                        child: Text(
                          "Sign Up",
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

