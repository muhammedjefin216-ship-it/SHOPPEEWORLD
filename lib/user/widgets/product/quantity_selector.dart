import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class QuantitySelector extends StatelessWidget {
  final int quantity;
  final int maxQuantity;
  final ValueChanged<int> onQuantityChanged;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.maxQuantity,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    final canDecrement = quantity > 1;
    final canIncrement = quantity < maxQuantity;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Quantity",
          style: GoogleFonts.outfit(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),

        // ==========================================================
        // QUANTITY CONTROL
        // ==========================================================

        Container(
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xff191D1E),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withOpacity(.08),
            ),
          ),
          child: Row(
            children: [
              // DECREASE
              _buildButton(
                icon: Icons.remove,
                isEnabled: canDecrement,
                onTap: () {
                  if (canDecrement) {
                    onQuantityChanged(quantity - 1);
                  }
                },
              ),

              // QUANTITY
              Container(
                width: 38,
                alignment: Alignment.center,
                child: Text(
                  quantity.toString(),
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),

              // INCREASE
              _buildButton(
                icon: Icons.add,
                isEnabled: canIncrement,
                onTap: () {
                  if (canIncrement) {
                    onQuantityChanged(quantity + 1);
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildButton({
    required IconData icon,
    required bool isEnabled,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: isEnabled ? onTap : null,
        child: SizedBox(
          width: 40,
          height: 42,
          child: Center(
            child: Icon(
              icon,
              size: 17,
              color: isEnabled
                  ? Colors.white
                  : Colors.white24,
            ),
          ),
        ),
      ),
    );
  }
}