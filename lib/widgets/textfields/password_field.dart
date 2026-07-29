import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';

class PasswordTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputAction textInputAction;
  final String? Function(String?)? validator;
  final List<String>? autofillHints;
  final VoidCallback? onEditingComplete;

  const PasswordTextField({
  super.key,
  required this.controller,
  this.hintText = "Password",
  this.textInputAction = TextInputAction.done,
  this.validator,
  this.autofillHints,
  this.onEditingComplete,
});

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscureText = true;

  void _togglePassword() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.textFieldHeight,
      child: TextFormField(
        controller: widget.controller,
        obscureText: _obscureText,
        textInputAction: widget.textInputAction,
        validator: widget.validator,
        autofillHints: widget.autofillHints,
        onEditingComplete: widget.onEditingComplete,
        cursorColor: AppColors.primary,
        decoration: InputDecoration(
          hintText: widget.hintText,

          prefixIcon: const Icon(
            Icons.lock_outline,
            color: AppColors.textSecondary,
          ),

          suffixIcon: IconButton(
            splashRadius: 20,
            onPressed: _togglePassword,
            icon: Icon(
              _obscureText
                  ? CupertinoIcons.eye_slash
                  : CupertinoIcons.eye,
              color: AppColors.textSecondary,
            ),
          ),

          filled: true,
          fillColor: AppColors.surface,

          contentPadding: const EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 16,
          ),

          border: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(AppSizes.borderRadius),
            borderSide: BorderSide.none,
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(AppSizes.borderRadius),
            borderSide: const BorderSide(
              color: AppColors.border,
            ),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(AppSizes.borderRadius),
            borderSide: const BorderSide(
              color: AppColors.primary,
              width: 1.5,
            ),
          ),

          errorBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(AppSizes.borderRadius),
            borderSide: const BorderSide(
              color: AppColors.error,
            ),
          ),

          focusedErrorBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(AppSizes.borderRadius),
            borderSide: const BorderSide(
              color: AppColors.error,
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}