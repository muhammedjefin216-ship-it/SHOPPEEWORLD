// import 'package:flutter/material.dart';

// class CheckoutOrderSummary extends StatelessWidget {
//   final double subtotal;
//   final double deliveryCharge;
//   final double total;

//   const CheckoutOrderSummary({
//     super.key,
//     required this.subtotal,
//     required this.deliveryCharge,
//     required this.total,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(
//           color: Colors.grey.shade200,
//         ),
//       ),
//       child: Column(
//         children: [
//           _row(
//             "Subtotal",
//             "₹${subtotal.toStringAsFixed(0)}",
//           ),

//           const SizedBox(height: 12),

//           _row(
//             "Delivery",
//             deliveryCharge == 0
//                 ? "Free"
//                 : "₹${deliveryCharge.toStringAsFixed(0)}",
//           ),

//           const Divider(height: 30),

//           _row(
//             "Total",
//             "₹${total.toStringAsFixed(0)}",
//             isTotal: true,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _row(
//     String title,
//     String value, {
//     bool isTotal = false,
//   }) {
//     return Row(
//       children: [
//         Text(
//           title,
//           style: TextStyle(
//             fontSize: isTotal ? 18 : 15,
//             fontWeight: isTotal
//                 ? FontWeight.bold
//                 : FontWeight.w500,
//           ),
//         ),

//         const Spacer(),

//         Text(
//           value,
//           style: TextStyle(
//             fontSize: isTotal ? 20 : 15,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ],
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CheckoutOrderSummary extends StatelessWidget {
  final double subtotal;
  final double deliveryCharge;
  final double total;

  const CheckoutOrderSummary({
    super.key,
    required this.subtotal,
    required this.deliveryCharge,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xff191D1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(.06),
        ),
      ),
      child: Column(
        children: [
          // ==========================================================
          // SUBTOTAL
          // ==========================================================

          _row(
            "Subtotal",
            "₹${subtotal.toStringAsFixed(0)}",
          ),

          const SizedBox(height: 12),

          // ==========================================================
          // DELIVERY
          // ==========================================================

          _row(
            "Delivery",
            deliveryCharge == 0
                ? "Free"
                : "₹${deliveryCharge.toStringAsFixed(0)}",
          ),

          const SizedBox(height: 14),

          // ==========================================================
          // DIVIDER
          // ==========================================================

          Divider(
            height: 1,
            color: Colors.white.withOpacity(.10),
          ),

          const SizedBox(height: 14),

          // ==========================================================
          // TOTAL
          // ==========================================================

          _row(
            "Total",
            "₹${total.toStringAsFixed(0)}",
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _row(
    String title,
    String value, {
    bool isTotal = false,
  }) {
    return Row(
      children: [
        Text(
          title,
          style: GoogleFonts.outfit(
            color: isTotal
                ? Colors.white
                : Colors.white54,
            fontSize: isTotal ? 15 : 12,
            fontWeight: isTotal
                ? FontWeight.w700
                : FontWeight.w500,
          ),
        ),

        const Spacer(),

        Text(
          value,
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontSize: isTotal ? 17 : 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}