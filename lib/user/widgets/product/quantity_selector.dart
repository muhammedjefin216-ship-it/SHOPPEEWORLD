import 'package:flutter/material.dart';
import 'package:shoppee_world/user/core/theme/app_tokens.dart';

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
          style: AppTokens.bodyStrong,
        ),

        // ==========================================================
        // QUANTITY CONTROL
        // ==========================================================

        Container(
          height: 44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              AppTokens.radiusMd,
            ),
            border: Border.all(
              color: AppTokens.border,
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
                width: 40,
                alignment: Alignment.center,
                child: Text(
                  quantity.toString(),
                  style: AppTokens.bodyStrong,
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
        borderRadius: BorderRadius.circular(AppTokens.radiusMd),
        onTap: isEnabled ? onTap : null,
        child: SizedBox(
          width: 44,
          height: 44,
          child: Center(
            child: Icon(
              icon,
              size: 18,
              color: isEnabled
                  ? AppTokens.textPrimary
                  : AppTokens.textTertiary,
            ),
          ),
        ),
      ),
    );
  }
}