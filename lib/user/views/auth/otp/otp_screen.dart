import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shoppee_world/user/main_screen.dart';
import 'package:shoppee_world/user/viewmodel/auth/auth_provider.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../widgets/auth/auth_header.dart';
import '../../../widgets/buttons/primary_button.dart';

class OtpScreen extends ConsumerStatefulWidget {
  final String email;

  const OtpScreen({
    super.key,
    required this.email,
  });

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  // 8 OTP fields
  final List<TextEditingController> controllers =
      List.generate(8, (_) => TextEditingController());

  final List<FocusNode> focusNodes =
      List.generate(8, (_) => FocusNode());

  Timer? _resendTimer;
  int _resendCountdown = 30;
  bool _canResend = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    _resendTimer?.cancel();

    for (final controller in controllers) {
      controller.dispose();
    }

    for (final node in focusNodes) {
      node.dispose();
    }

    super.dispose();
  }

  void _startResendTimer() {
    setState(() {
      _resendCountdown = 30;
      _canResend = false;
    });

    _resendTimer?.cancel();

    _resendTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (_resendCountdown > 1) {
          setState(() => _resendCountdown--);
        } else {
          _resendTimer?.cancel();

          setState(() {
            _canResend = true;
          });
        }
      },
    );
  }

  String get _otpCode {
    return controllers.map((controller) => controller.text).join();
  }

  void _handlePasteOrInput(String value, int index) {
    // Handle pasted OTP
    if (value.length > 1) {
      final digits = value
          .replaceAll(RegExp(r'\D'), '')
          .split('');

      for (int i = 0; i < 8; i++) {
        controllers[i].text =
            i < digits.length ? digits[i] : '';
      }

      if (digits.length >= 8) {
        focusNodes[7].unfocus();
        _verifyOtp();
      } else if (digits.isNotEmpty) {
        final nextIndex = digits.length.clamp(0, 7);
        focusNodes[nextIndex].requestFocus();
      }

      return;
    }

    // Handle normal typing
    if (value.isNotEmpty) {
      if (index < 7) {
        focusNodes[index + 1].requestFocus();
      } else {
        focusNodes[index].unfocus();
        _verifyOtp();
      }
    }
  }

  Future<void> _verifyOtp() async {
    final otp = _otpCode;

    if (otp.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter the full 8-digit code"),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ref.read(authRepositoryProvider).verifySignupOtp(
            email: widget.email,
            token: otp,
          );

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const MainScreen(),
        ),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Verification failed: "
            "${e.toString().replaceFirst('Exception: ', '')}",
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _resendCode() async {
    if (!_canResend || _isLoading) return;

    _startResendTimer();

    try {
      await ref.read(authRepositoryProvider).resendSignupOtp(
            email: widget.email,
          );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "A new code has been sent to ${widget.email}",
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Failed to resend code: "
            "${e.toString().replaceFirst('Exception: ', '')}",
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // =========================================================
  // OTP BOX
  // =========================================================

  Widget _buildOtpBox(int index) {
    return SizedBox(
      width: 40,
      height: 58,
      child: KeyboardListener(
        focusNode: focusNodes[index],
        onKeyEvent: (event) {
          if (event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.backspace) {
            if (controllers[index].text.isEmpty && index > 0) {
              controllers[index - 1].clear();
              focusNodes[index - 1].requestFocus();
            }
          }
        },
        child: TextField(
          controller: controllers[index],
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          autofillHints:
              index == 0 ? const [AutofillHints.oneTimeCode] : null,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(
            counterText: "",
            filled: true,
            fillColor: const Color(0xffF8F8F8),
            contentPadding: EdgeInsets.zero,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.grey.shade300,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Colors.black,
                width: 2,
              ),
            ),
          ),
          onChanged: (value) {
            _handlePasteOrInput(value, index);
          },
        ),
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
          child: AutofillGroup(
            child: Column(
              children: [
                const SizedBox(height: 40),

                AuthHeader(
                  title: "Verify OTP",
                  subtitle:
                      "Enter the code sent to ${widget.email}",
                ),

                const SizedBox(height: 50),

                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    8,
                    (index) => _buildOtpBox(index),
                  ),
                ),

                const SizedBox(height: 35),

                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Didn't receive code? ",
                      style:
                          Theme.of(context).textTheme.bodyMedium,
                    ),
                    TextButton(
                      onPressed:
                          _canResend ? _resendCode : null,
                      child: Text(
                        _canResend
                            ? "Resend Code"
                            : "Resend in ${_resendCountdown}s",
                        style: TextStyle(
                          color: _canResend
                              ? Colors.black
                              : Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // Verify Button
                PrimaryButton(
                  text: _isLoading
                      ? "VERIFYING..."
                      : "VERIFY",
                  onPressed:
                      _isLoading ? null : _verifyOtp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}