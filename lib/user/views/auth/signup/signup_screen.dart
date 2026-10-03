import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:shoppee_world/user/viewmodel/auth/auth_provider.dart';
import 'package:shoppee_world/user/views/auth/otp/otp_screen.dart';
import 'package:shoppee_world/user/widgets/textfields/password_field.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../widgets/auth/auth_divider.dart';
import '../../../widgets/auth/auth_header.dart';
import '../../../widgets/auth/bottom_auth_text.dart';
import '../../../widgets/buttons/google_button.dart';
import '../../../widgets/textfields/custom_text_field.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool agreeTerms = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    fullNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // ==========================================================
  // SIGN UP
  // ==========================================================

  Future<void> createAccount() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!agreeTerms) {
      _showMessage(
        "Please accept Terms & Conditions",
        isError: true,
      );
      return;
    }

    ref.read(authLoadingProvider.notifier).state = true;

    try {
      await ref.read(authRepositoryProvider).signUp(
            name: fullNameController.text.trim(),
            phone: phoneController.text.trim(),
            email: emailController.text.trim(),
            password: passwordController.text,
          );

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OtpScreen(
            email: emailController.text.trim(),
          ),
        ),
      );
    } catch (e) {
      debugPrint("SIGNUP ERROR: $e");

      if (!mounted) return;

      final String message = _getAuthErrorMessage(e);
      _showMessage(message, isError: true);
    } finally {
      if (mounted) {
        ref.read(authLoadingProvider.notifier).state = false;
      }
    }
  }


  String _getAuthErrorMessage(Object error) {
    final message = error.toString().toLowerCase();

    if (message.contains("already registered") ||
        message.contains("already exists") ||
        message.contains("user already registered")) {
      return "This email is already registered.";
    }

    if (message.contains("invalid email")) {
      return "Please enter a valid email address.";
    }

    if (message.contains("password")) {
      return "Password does not meet the requirements.";
    }

    if (message.contains("network")) {
      return "Network error. Please check your internet connection.";
    }

    return "Unable to create account. Please try again.";
  }



  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                isError ? Icons.error_outline : Icons.check_circle_outline,
                color: Colors.white,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          backgroundColor: isError ? Colors.red.shade700 : Colors.black,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      );
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authLoadingProvider);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: ColorFiltered(
              colorFilter: const ColorFilter.matrix([
                0.2126, 0.7152, 0.0722, 0, 0,
                0.2126, 0.7152, 0.0722, 0, 0,
                0.2126, 0.7152, 0.0722, 0, 0,
                0, 0, 0, 1, 0,
              ]),
              child: Image.asset(
                "assets/images/signup.jpg",
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) {
                  return Container(color: Colors.grey.shade100);
                },
              ),
            ),
          ),

          // White Overlay
          Positioned.fill(
            child: Container(
              color: Colors.white.withValues(alpha: 0.78),
            ),
          ),

          // Main Form Content
          SafeArea(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.only(
                      left: AppSizes.screenPadding,
                      right: AppSizes.screenPadding,
                      top: 20,
                      bottom: MediaQuery.of(context).viewInsets.bottom + 30,
                    ),
                    child: Form(
                      key: _formKey,
                      child: AutofillGroup(
                        child: Column(
                          children: [
                            const SizedBox(height: 25),

                            const AuthHeader(
                              title: "Create Account",
                              subtitle: "Create your account to continue",
                            ),

                            const SizedBox(height: 35),

                            // Full Name Field
                            CustomTextField(
                              controller: fullNameController,
                              hintText: "Full Name",
                              prefixIcon: Icons.person_outline,
                              autofillHints: const [AutofillHints.name],
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "Enter your full name";
                                }
                                if (value.trim().length < 3) {
                                  return "Minimum 3 characters";
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 18),

                            // Phone Field
                            CustomTextField(
                              controller: phoneController,
                              hintText: "Phone Number",
                              prefixIcon: Icons.phone_outlined,
                              keyboardType: TextInputType.phone,
                              autofillHints: const [
                                AutofillHints.telephoneNumber,
                              ],
                              validator: (value) {
                                final phone = value?.trim() ?? "";
                                if (phone.isEmpty) {
                                  return "Enter your phone number";
                                }
                                if (!RegExp(r'^[0-9]{10}$').hasMatch(phone)) {
                                  return "Enter a valid 10-digit phone number";
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 18),

                            // Email Field
                            CustomTextField(
                              controller: emailController,
                              hintText: "Email Address",
                              prefixIcon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                              autofillHints: const [AutofillHints.email],
                              validator: (value) {
                                final email = value?.trim() ?? "";
                                if (email.isEmpty) {
                                  return "Enter your email";
                                }
                                final emailRegex = RegExp(
                                  r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                                );
                                if (!emailRegex.hasMatch(email)) {
                                  return "Enter a valid email";
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 18),

                            // Password Field
                            PasswordTextField(
                              controller: passwordController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Enter password";
                                }
                                if (value.length < 6) {
                                  return "Minimum 6 characters";
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 18),

                            // Confirm Password Field
                            PasswordTextField(
                              controller: confirmPasswordController,
                              hintText: "Confirm Password",
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Confirm your password";
                                }
                                if (value != passwordController.text) {
                                  return "Passwords do not match";
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 18),

                            // Terms Checkbox Row
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Checkbox(
                                  value: agreeTerms,
                                  activeColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  onChanged: isLoading
                                      ? null
                                      : (value) {
                                          setState(() {
                                            agreeTerms = value ?? false;
                                          });
                                        },
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 12),
                                    child: RichText(
                                      text: const TextSpan(
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 13,
                                        ),
                                        children: [
                                          TextSpan(text: "I agree to the "),
                                          TextSpan(
                                            text: "Terms & Conditions",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(text: " and "),
                                          TextSpan(
                                            text: "Privacy Policy",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 15),

                            // Create Account Button
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: isLoading ? null : createAccount,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  disabledBackgroundColor: Colors.black54,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(28),
                                  ),
                                ),
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 200),
                                  child: isLoading
                                      ? const SizedBox(
                                          key: ValueKey("loading"),
                                          height: 23,
                                          width: 23,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.5,
                                            color: Colors.white,
                                          ),
                                        )
                                      : Text(
                                          "CREATE ACCOUNT",
                                          key: const ValueKey("text"),
                                          style: GoogleFonts.outfit(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: .5,
                                          ),
                                        ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 28),

                            // Social Auth & Navigation
                            const AuthDivider(),

                            const SizedBox(height: 28),

                            GoogleButton(
                              onPressed: () {
                                if (isLoading) return;
                                // Google Sign Up Implementation
                              },
                            ),

                            const SizedBox(height: 30),

                            BottomAuthText(
                              title: "Already have an account?",
                              buttonText: "Login",
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),

                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}