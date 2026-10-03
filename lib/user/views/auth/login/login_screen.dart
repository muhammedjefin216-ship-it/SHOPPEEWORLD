import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shoppee_world/admin/repositories/admin_respositery.dart'; // Consider fixing spelling to admin_repository.dart
import 'package:shoppee_world/admin/views/dashboard/admin_dashboard_screen.dart';
import 'package:shoppee_world/user/main_screen.dart';
import 'package:shoppee_world/user/viewmodel/auth/auth_provider.dart';
import 'package:shoppee_world/user/views/auth/signup/signup_screen.dart';
import 'package:shoppee_world/user/widgets/textfields/password_field.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../widgets/auth/auth_divider.dart';
import '../../../widgets/auth/auth_header.dart';
import '../../../widgets/auth/bottom_auth_text.dart';
import '../../../widgets/buttons/google_button.dart';
import '../../../widgets/buttons/primary_button.dart';
import '../../../widgets/textfields/custom_text_field.dart';

final adminRepositoryProvider = Provider<AdminRepository>((ref) {
  return AdminRepository();
});

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool rememberMe = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // =========================================================
  // LOGIN
  // =========================================================

  Future<void> login() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final email = emailController.text.trim();
    final password = passwordController.text;

    // Start loading state via Riverpod
    ref.read(authLoadingProvider.notifier).state = true;

    try {
      // 1. CHECK ADMIN
      final adminRepository = ref.read(adminRepositoryProvider);
      final isAdmin = await adminRepository.loginAdmin(
        email: email,
        password: password,
      );

      if (!mounted) return;

      if (isAdmin) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const AdminDashboardScreen(),
          ),
        );
        return;
      }

      // 2. NORMAL USER LOGIN
      final authRepository = ref.read(authRepositoryProvider);
      await authRepository.login(
        email: email,
        password: password,
      );

      if (!mounted) return;

      // 3. NAVIGATION ON SUCCESS
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const MainScreen(),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      final message = _parseLoginError(e);

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(message),
            behavior: SnackBarBehavior.floating,
          ),
        );
    } finally {
      if (mounted) {
        ref.read(authLoadingProvider.notifier).state = false;
      }
    }
  }

  String _parseLoginError(Object e) {
    final error = e.toString().toLowerCase();

    if (error.contains("invalid login credentials")) {
      return "Invalid email or password";
    }
    if (error.contains("email not confirmed")) {
      return "Please verify your email before logging in";
    }
    if (error.contains("network")) {
      return "Please check your internet connection";
    }

    return e.toString().replaceFirst("Exception: ", "");
  }

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authLoadingProvider);

    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                "assets/images/login.png",
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(color: Colors.grey.shade200),
              ),
            ),
          ),

          // White Overlay
          Positioned.fill(
            child: Container(
              color: Colors.white.withValues(alpha: 0.3),
            ),
          ),

          // Main Form Content
          SafeArea(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(
                  left: AppSizes.screenPadding,
                  right: AppSizes.screenPadding,
                  top: 20,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                ),
                child: Form(
                  key: _formKey,
                  child: AutofillGroup(
                    child: Column(
                      children: [
                        const SizedBox(height: 30),

                        const AuthHeader(
                          title: "Welcome Back",
                          subtitle: "Sign in to continue shopping",
                        ),

                        const SizedBox(height: 50),

                        // Email Field
                        CustomTextField(
                          controller: emailController,
                          hintText: "Email Address",
                          prefixIcon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          autofillHints: const [AutofillHints.email],
                          validator: (value) {
                            final email = value?.trim() ?? "";
                            if (email.isEmpty) {
                              return "Email is required";
                            }
                            if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
                              return "Enter a valid email address";
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 20),

                        // Password Field
                        PasswordTextField(
                          controller: passwordController,
                          autofillHints: const [AutofillHints.password],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Password is required";
                            }
                            if (value.length < 6) {
                              return "Minimum 6 characters";
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 12),

                        // Remember Me & Forgot Password
                        Row(
                          children: [
                            Checkbox(
                              value: rememberMe,
                              activeColor: Colors.black,
                              onChanged: isLoading
                                  ? null
                                  : (value) {
                                      setState(() {
                                        rememberMe = value ?? false;
                                      });
                                    },
                            ),
                            const Text("Remember Me"),
                            const Spacer(),
                            TextButton(
                              onPressed: isLoading
                                  ? null
                                  : () {
                                      // Trigger Forgot Password flow
                                    },
                              child: const Text(
                                "Forgot Password?",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 15),

                        // Login Button
                        PrimaryButton(
                          text: isLoading ? "LOGGING IN..." : "LOGIN",
                          onPressed: isLoading ? null : login,
                        ),

                        const SizedBox(height: 30),

                        const AuthDivider(),

                        const SizedBox(height: 30),

                        // Google Auth Button
                        GoogleButton(
                          onPressed: () {
                            if (isLoading) return;
                            // Trigger Google Login
                          },
                        ),

                        const SizedBox(height: 35),

                        // Sign Up Prompt
                        BottomAuthText(
                          title: "Don't have an account?",
                          buttonText: "Sign Up",
                          onTap: () {
                            if (isLoading) return;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SignupScreen(),
                              ),
                            );
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

          // Loading Overlay
          if (isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withValues(alpha: 0.08),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}