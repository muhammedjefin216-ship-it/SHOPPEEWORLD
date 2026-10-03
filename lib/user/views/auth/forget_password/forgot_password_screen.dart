import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../widgets/auth/auth_header.dart';
import '../../../widgets/auth/bottom_auth_text.dart';
import '../../../widgets/buttons/primary_button.dart';
import '../../../widgets/textfields/custom_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState
    extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void sendResetLink() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Reset link sent successfully."),
        ),
      );

      // Later:
      // Navigate to OTP Screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
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
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  const AuthHeader(
                    title: "Forgot Password",
                    subtitle:
                        "Enter your email to receive a password reset link.",
                  ),

                  const SizedBox(height: 50),

                  CustomTextField(
                    controller: emailController,
                    hintText: "Email Address",
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your email";
                      }

                      if (!value.contains("@")) {
                        return "Enter a valid email";
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 30),

                  PrimaryButton(
                    text: "SEND RESET LINK",
                    onPressed: sendResetLink,
                  ),

                  const SizedBox(height: 40),

                  BottomAuthText(
                    title: "Remember your password?",
                    buttonText: "Login",
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}