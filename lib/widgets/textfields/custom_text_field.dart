import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final String? Function(String?)? validator;
  final List<String>? autofillHints;
  final VoidCallback? onEditingComplete;
  final bool readOnly;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.validator,
    this.autofillHints,
    this.onEditingComplete,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.textFieldHeight,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        validator: validator,
        autofillHints: autofillHints,
        readOnly: readOnly,
        onEditingComplete: onEditingComplete,
        cursorColor: AppColors.primary,
        decoration: InputDecoration(
          hintText: hintText,

          prefixIcon: Icon(
            prefixIcon,
            color: AppColors.textSecondary,
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