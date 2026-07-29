import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../widgets/auth/auth_header.dart';
import '../../../widgets/buttons/primary_button.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> controllers =
      List.generate(6, (_) => TextEditingController());

  final List<FocusNode> focusNodes =
      List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (final controller in controllers) {
      controller.dispose();
    }

    for (final node in focusNodes) {
      node.dispose();
    }

    super.dispose();
  }

  Widget otpBox(int index) {
    return SizedBox(
      width: 52,
      height: 60,
      child: TextField(
        controller: controllers[index],
        focusNode: focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,

        decoration: InputDecoration(
          counterText: "",
          filled: true,
          fillColor: const Color(0xffF8F8F8),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Colors.grey.shade300,
            ),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Colors.black,
              width: 1.5,
            ),
          ),
        ),

        onChanged: (value) {
          if (value.isNotEmpty && index < 5) {
            FocusScope.of(context).requestFocus(
              focusNodes[index + 1],
            );
          }

          if (value.isEmpty && index > 0) {
            FocusScope.of(context).requestFocus(
              focusNodes[index - 1],
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.screenPadding,
            vertical: 20,
          ),
          child: Column(
            children: [
              const SizedBox(height: 40),

              const AuthHeader(
                title: "Verify OTP",
                subtitle:
                    "Enter the 6-digit code sent to your email.",
              ),

              const SizedBox(height: 50),

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: List.generate(
                  6,
                  (index) => otpBox(index),
                ),
              ),

              const SizedBox(height: 35),

              Text(
                "Didn't receive the code?",
                style: Theme.of(context).textTheme.bodyMedium,
              ),

              TextButton(
                onPressed: () {},
                child: const Text(
                  "Resend Code",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              PrimaryButton(
                text: "VERIFY",
                onPressed: () {
                  // Navigate to Home or Reset Password
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}