import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../constants.dart';

// ======================================================
// GlowScanAI Forgot Password Screen
// Clean UI (matching Login & Signup design)
// ======================================================

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with SingleTickerProviderStateMixin {

  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();

  bool _loading = false;
  bool _sent = false;
  String? _error;

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
    _email.dispose();
    _controller.dispose();
    super.dispose();
  }

  // ======================================================
  // SEND RESET EMAIL
  // ======================================================

  Future<void> _sendResetEmail() async {

    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    final email = _email.text.trim().toLowerCase();

    try {

      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      setState(() {
        _sent = true;
        _loading = false;
      });

    } on FirebaseAuthException catch (e) {

      setState(() {
        _loading = false;

        if (e.code == "user-not-found") {
          _error = "No account found with this email.";
        } else if (e.code == "invalid-email") {
          _error = "Invalid email format.";
        } else {
          _error = e.message ?? "Something went wrong.";
        }
      });

    } catch (_) {

      setState(() {
        _loading = false;
        _error = "Something went wrong. Try again.";
      });

    }
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
              Color(0xFFFDF2FF),
              Color(0xFFFFE8F7),
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
                    "Reset Password",
                    style: GoogleFonts.outfit(
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "Enter your email to receive a reset link",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: AppColors.textLight,
                    ),
                  ),

                  const SizedBox(height: 40),

                  if (_error != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        _error!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                        ),
                      ),
                    ),

                  // =================================================
                  // BEFORE EMAIL SENT
                  // =================================================

                  if (!_sent)
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

                            TextFormField(
                              controller: _email,
                              keyboardType: TextInputType.emailAddress,

                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey.shade50,
                                labelText: "Email Address",

                                prefixIcon: const Icon(
                                  Icons.email_rounded,
                                  color: AppColors.primary,
                                ),

                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),

                              validator: (v) {
                                if (v == null || v.trim().isEmpty) {
                                  return "Please enter your email";
                                }
                                if (!v.contains("@")) return "Invalid email";
                                return null;
                              },
                            ),

                            const SizedBox(height: 22),

                            SizedBox(
                              width: double.infinity,
                              height: 54,

                              child: ElevatedButton(
                                onPressed: _loading ? null : _sendResetEmail,

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
                                  "Send Reset Link",
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // =================================================
                  // AFTER EMAIL SENT
                  // =================================================

                  if (_sent)
                    Column(
                      children: [

                        const SizedBox(height: 20),

                        Icon(
                          Icons.mark_email_read_rounded,
                          size: 90,
                          color: AppColors.success,
                        ),

                        const SizedBox(height: 20),

                        Text(
                          "Reset link sent!\nCheck your email.",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textDark,
                          ),
                        ),

                        const SizedBox(height: 24),

                        TextButton(
                          onPressed: () => Navigator.pop(context),

                          child: Text(
                            "Back to Login",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
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
