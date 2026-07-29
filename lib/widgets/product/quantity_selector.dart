import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class QuantitySelector extends StatelessWidget {
  final int quantity;
  final ValueChanged<int> onQuantityChanged;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    final canDecrement = quantity > 1;

    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Quantity",
          style: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),

        Container(
          height: 44,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius:
                BorderRadius.circular(22),
            border: Border.all(
              color: Colors.grey.shade200,
            ),
          ),

          child: Row(
            children: [
              // ======================================================
              // DECREASE
              // ======================================================

              _buildButton(
                icon: Icons.remove,
                isEnabled: canDecrement,
                onTap: () {
                  if (canDecrement) {
                    onQuantityChanged(
                      quantity - 1,
                    );
                  }
                },
              ),

              // ======================================================
              // QUANTITY
              // ======================================================

              Container(
                width: 40,
                alignment: Alignment.center,

                child: Text(
                  quantity.toString(),

                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight:
                        FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),

              // ======================================================
              // INCREASE
              // ======================================================

              _buildButton(
                icon: Icons.add,
                isEnabled: true,
                onTap: () {
                  onQuantityChanged(
                    quantity + 1,
                  );
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
        borderRadius:
            BorderRadius.circular(22),

        onTap: isEnabled
            ? onTap
            : null,

        child: Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,

          child: Icon(
            icon,
            size: 18,

            color: isEnabled
                ? Colors.black87
                : Colors.grey.shade400,
          ),
        ),
      ),
    );
  }
}