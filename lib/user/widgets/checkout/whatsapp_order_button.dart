// import 'package:flutter/material.dart';

// class WhatsAppOrderButton extends StatelessWidget {
//   final VoidCallback onPressed;

//   const WhatsAppOrderButton({
//     super.key,
//     required this.onPressed,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: double.infinity,
//       height: 58,
//       child: ElevatedButton.icon(
//         onPressed: onPressed,
//         icon: const Icon(
//           Icons.chat,
//         ),
//         label: const Text(
//           "Order via WhatsApp",
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.black,
//           foregroundColor: Colors.white,
//           elevation: 0,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WhatsAppOrderButton extends StatelessWidget {
  final VoidCallback onPressed;

  const WhatsAppOrderButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: onPressed,

        // ==========================================================
        // WHATSAPP ICON
        // ==========================================================

        icon: const Icon(
          Icons.chat_rounded,
          size: 20,
          color: Colors.black,
        ),

        // ==========================================================
        // BUTTON TEXT
        // ==========================================================

        label: Text(
          "Order via WhatsApp",
          style: GoogleFonts.outfit(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),

        // ==========================================================
        // BUTTON STYLE
        // ==========================================================

        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}