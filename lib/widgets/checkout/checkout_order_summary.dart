import 'package:flutter/material.dart';

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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(
        children: [
          _row(
            "Subtotal",
            "₹${subtotal.toStringAsFixed(0)}",
          ),

          const SizedBox(height: 12),

          _row(
            "Delivery",
            deliveryCharge == 0
                ? "Free"
                : "₹${deliveryCharge.toStringAsFixed(0)}",
          ),

          const Divider(height: 30),

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
          style: TextStyle(
            fontSize: isTotal ? 18 : 15,
            fontWeight: isTotal
                ? FontWeight.bold
                : FontWeight.w500,
          ),
        ),

        const Spacer(),

        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 20 : 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}