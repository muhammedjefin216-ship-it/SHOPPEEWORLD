import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff080C0D),
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(.06),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.25),
            blurRadius: 20,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 12),
          child: Row(
            children: [
              // ======================================================
              // ADD TO CART
              // ======================================================

              Expanded(
                child: OutlinedButton.icon(
                  onPressed:
                      isOutOfStock ? null : onAddToCart,
                  icon: Icon(
                    Icons.shopping_bag_outlined,
                    color: isOutOfStock
                        ? Colors.white24
                        : Colors.white,
                    size: 19,
                  ),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(54),
                    side: BorderSide(
                      color: isOutOfStock
                          ? Colors.white10
                          : Colors.white.withOpacity(.25),
                      width: 1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    backgroundColor: isOutOfStock
                        ? const Color(0xff111415)
                        : const Color(0xff191D1E),
                    elevation: 0,
                  ),
                  label: Text(
                    isOutOfStock
                        ? "Out of Stock"
                        : "Add to Cart",
                    style: GoogleFonts.outfit(
                      color: isOutOfStock
                          ? Colors.white24
                          : Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // ======================================================
              // BUY NOW
              // ======================================================

              Expanded(
                child: ElevatedButton.icon(
                  onPressed:
                      isOutOfStock ? null : onBuyNow,
                  icon: Icon(
                    Icons.flash_on_rounded,
                    color: isOutOfStock
                        ? Colors.white24
                        : Colors.black,
                    size: 19,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isOutOfStock
                        ? const Color(0xff191D1E)
                        : Colors.white,
                    disabledBackgroundColor:
                        const Color(0xff191D1E),
                    disabledForegroundColor:
                        Colors.white24,
                    foregroundColor: Colors.black,
                    minimumSize: const Size.fromHeight(54),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  label: Text(
                    isOutOfStock
                        ? "Unavailable"
                        : "Buy Now",
                    style: GoogleFonts.outfit(
                      color: isOutOfStock
                          ? Colors.white24
                          : Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
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