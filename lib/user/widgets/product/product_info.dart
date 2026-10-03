import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shoppee_world/user/models/product/product_model.dart';

class ProductInfo extends StatelessWidget {
  final ProductModel product;

  const ProductInfo({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    // Actual DB prices
    final sellingPrice =
        product.offerPrice > 0 ? product.offerPrice : product.price;

    final originalPrice = product.originalPrice;

    // Calculate actual discount percentage
    int discountPercent = 0;

    if (originalPrice > 0 &&
        sellingPrice > 0 &&
        originalPrice > sellingPrice) {
      discountPercent =
          (((originalPrice - sellingPrice) / originalPrice) * 100)
              .round();
    }

    final bool inStock = product.stockQuantity > 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ==========================================================
        // CATEGORY + STOCK
        // ==========================================================

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              product.category.toUpperCase(),
              style: GoogleFonts.outfit(
                color: Colors.white54,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 9,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: inStock
                    ? const Color(0xff18251F)
                    : const Color(0xff2A1919),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: inStock
                      ? const Color(0xff275C48)
                      : const Color(0xff633333),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: inStock
                          ? const Color(0xff35D399)
                          : const Color(0xffF87171),
                      shape: BoxShape.circle,
                    ),
                  ),

                  const SizedBox(width: 5),

                  Text(
                    inStock
                        ? "In Stock"
                        : "Out of Stock",
                    style: GoogleFonts.outfit(
                      color: inStock
                          ? const Color(0xff6EE7B7)
                          : const Color(0xffFCA5A5),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        // ==========================================================
        // PRODUCT NAME
        // ==========================================================

        Text(
          product.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.w800,
            height: 1.1,
          ),
        ),

        const SizedBox(height: 9),

        // ==========================================================
        // RATING
        // ==========================================================

        Row(
          children: [
            const Icon(
              Icons.star_rounded,
              color: Colors.white,
              size: 17,
            ),

            const SizedBox(width: 4),

            Text(
              product.rating.toStringAsFixed(1),
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        // ==========================================================
        // PRICE
        // ==========================================================

        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "₹${sellingPrice.toStringAsFixed(0)}",
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 29,
                fontWeight: FontWeight.w800,
              ),
            ),

            // Show original price only when available
            if (originalPrice > sellingPrice) ...[
              const SizedBox(width: 10),

              Text(
                "₹${originalPrice.toStringAsFixed(0)}",
                style: GoogleFonts.outfit(
                  color: Colors.white38,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            ],

            // Show discount only when there is an actual discount
            if (discountPercent > 0) ...[
              const SizedBox(width: 10),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xff191D1E),
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(
                    color: Colors.white24,
                  ),
                ),
                child: Text(
                  "$discountPercent% OFF",
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ],
        ),

        const SizedBox(height: 8),

        // ==========================================================
        // STOCK COUNT
        // ==========================================================

        if (inStock)
          Text(
            "${product.stockQuantity} items available",
            style: GoogleFonts.outfit(
              color: Colors.white38,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
      ],
    );
  }
}