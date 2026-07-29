import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shoppee_world/main_screen.dart';
import 'package:shoppee_world/views/auth/signup/signup_screen.dart';
import 'package:shoppee_world/widgets/textfields/password_field.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../widgets/auth/auth_divider.dart';
import '../../../widgets/auth/auth_header.dart';
import '../../../widgets/auth/bottom_auth_text.dart';
import '../../../widgets/buttons/google_button.dart';
import '../../../widgets/buttons/primary_button.dart';
import '../../../widgets/textfields/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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

  void login() {
    if (_formKey.currentState!.validate()) {
      debugPrint("Email : ${emailController.text}");
      debugPrint("Password : ${passwordController.text}");
      debugPrint("Remember : $rememberMe");

      // TODO:
      // Supabase Login
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Image.asset("assets/images/login.png"),
          Positioned.fill(
  child: Opacity(
    opacity:1.0, // 0.0 = fully transparent, 1.0 = fully visible
    child: ColorFiltered(
      colorFilter: const ColorFilter.matrix(<double>[
        0.2126, 0.7152, 0.0722, 0, 0,
        0.2126, 0.7152, 0.0722, 0, 0,
        0.2126, 0.7152, 0.0722, 0, 0,
        0, 0, 0, 1, 0,
      ]),
      child: Image.asset(
        "assets/images/login.png",
        fit: BoxFit.fill,
      ),
    ),
  ),
),
          Positioned.fill(
            child: Container(color: Colors.white.withOpacity(0.3)),
          ),
          SafeArea(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
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

                        CustomTextField(
                          controller: emailController,
                          hintText: "Email Address",
                          prefixIcon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          autofillHints: const [AutofillHints.email],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Email is required";
                            }

                            if (!value.contains("@")) {
                              return "Enter a valid email";
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 20),

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

                        Row(
                          children: [
                            Checkbox(
                              value: rememberMe,
                              activeColor: Colors.black,
                              onChanged: (value) {
                                setState(() {
                                  rememberMe = value!;
                                });
                              },
                            ),

                            const Text("Remember Me"),

                            const Spacer(),

                            TextButton(
                              onPressed: () {
                                // Forgot Password
                              },
                              child: const Text(
                                "Forgot Password?",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 15),

                        PrimaryButton(text: "LOGIN", onPressed: login),

                        const SizedBox(height: 30),

                        const AuthDivider(),

                        const SizedBox(height: 30),

                        GoogleButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => MainScreen()),
                            );
                          },
                        ),

                        const SizedBox(height: 35),

                        BottomAuthText(
                          title: "Don't have an account?",
                          buttonText: "Sign Up",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => SignupScreen()),
                            );
                          },
                        ),
                      ],
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
