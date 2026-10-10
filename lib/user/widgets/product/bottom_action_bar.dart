


import 'package:flutter/material.dart';
import 'package:shoppee_world/user/core/theme/app_tokens.dart';

class BottomActionBar extends StatelessWidget {
  final VoidCallback onAddToCart;
  final VoidCallback onBuyNow;
  final bool isOutOfStock;

  const BottomActionBar({
    super.key,
    required this.onAddToCart,
    required this.onBuyNow,
    required this.isOutOfStock,
  });

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppTokens.radiusButton),
    );

    return Container(
      decoration: const BoxDecoration(
        color: AppTokens.background,
        border: Border(
          top: BorderSide(
            color: AppTokens.border,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppTokens.gutter,
            AppTokens.s12,
            AppTokens.gutter,
            AppTokens.s12,
          ),
          child: Row(
            children: [
              // ======================================================
              // ADD TO CART
              // ======================================================

              Expanded(
                child: OutlinedButton(
                  onPressed: isOutOfStock ? null : onAddToCart,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    foregroundColor: AppTokens.textPrimary,
                    disabledForegroundColor:
                        AppTokens.textTertiary,
                    side: BorderSide(
                      color: isOutOfStock
                          ? AppTokens.border
                          : AppTokens.borderStrong,
                      width: 1,
                    ),
                    shape: shape,
                    elevation: 0,
                    textStyle: AppTokens.button,
                  ),
                  child: Text(
                    isOutOfStock ? "Out of stock" : "Add to cart",
                  ),
                ),
              ),

              const SizedBox(width: AppTokens.s12),

              // ======================================================
              // BUY NOW
              // ======================================================

              Expanded(
                child: ElevatedButton(
                  onPressed: isOutOfStock ? null : onBuyNow,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTokens.accent,
                    foregroundColor: AppTokens.onAccent,
                    disabledBackgroundColor: AppTokens.surface,
                    disabledForegroundColor:
                        AppTokens.textTertiary,
                    minimumSize: const Size.fromHeight(48),
                    elevation: 0,
                    shape: shape,
                    textStyle: AppTokens.button,
                  ),
                  child: Text(
                    isOutOfStock ? "Unavailable" : "Buy now",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}