import 'package:flutter/material.dart';

import '../../core/theme/text_styles.dart';

class BottomAuthText extends StatelessWidget {
  final String title;
  final String buttonText;
  final VoidCallback onTap;

  const BottomAuthText({
    super.key,
    required this.title,
    required this.buttonText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: AppTextStyles.body,
        ),

        TextButton(
          onPressed: onTap,
          child: Text(
            buttonText,
            style: AppTextStyles.textButton,
          ),
        ),
      ],
    );
  }
}