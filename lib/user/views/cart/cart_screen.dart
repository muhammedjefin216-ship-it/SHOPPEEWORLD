import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shoppee_world/user/models/cart/cart_item_model.dart';

import '../../viewmodel/cart/cart_provider.dart';
import '../checkout/checkout_screen.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  static const Color backgroundColor = Color(0xff080C0D);
  static const Color cardColor = Color(0xff191D1E);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);

    return Scaffold(
      backgroundColor: backgroundColor,

      // ============================================================
      // APP BAR
      // ============================================================

      appBar: AppBar(
        backgroundColor: backgroundColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 19,
          ),
        ),
        title: Text(
          "My Cart",
          style:GoogleFonts.poppins(
            fontSize: 21,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (cartItems.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: IconButton(
                onPressed: () {
                  _showClearCartDialog(
                    context,
                    ref,
                  );
                },
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.white70,
                  size: 22,
                ),
              ),
            ),
        ],
      ),

      // ============================================================
      // BODY
      // ============================================================

      body: cartItems.isEmpty
          ? _buildEmptyCart(context)
          : Column(
              children: [
                // ==================================================
                // CART ITEMS
                // ==================================================

                Expanded(
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(
                      18,
                      10,
                      18,
                      20,
                    ),
                    itemCount: cartItems.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: 14),
                    itemBuilder: (context, index) {
                      final item = cartItems[index];

                      return _buildCartItem(
                        context,
                        item,
                        cartNotifier,
                      );
                    },
                  ),
                ),

                // ==================================================
                // BOTTOM SUMMARY
                // ==================================================

                _buildBottomSummary(
                  context,
                  ref,
                ),
              ],
            ),
    );
  }

  // ==============================================================
  // CART ITEM
  // ==============================================================

  Widget _buildCartItem(
    BuildContext context,
    CartItemModel item,
    CartNotifier cartNotifier,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withOpacity(.06),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ========================================================
          // PRODUCT IMAGE
          // ========================================================

          Container(
            width: 100,
            height: 118,
            decoration: BoxDecoration(
              color: const Color(0xff080C0D),
              borderRadius: BorderRadius.circular(14),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.network(
                item.product.image,
                width: 100,
                height: 118,
                fit: BoxFit.contain,
                errorBuilder:
                    (context, error, stackTrace) {
                  return const Center(
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      color: Colors.white30,
                      size: 28,
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(width: 14),

          // ========================================================
          // PRODUCT DETAILS
          // ========================================================

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                // Product category
                Text(
                  item.product.category.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    color: Colors.white38,
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),

                const SizedBox(height: 5),

                // Product name
                Text(
                  item.product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    height: 1.15,
                  ),
                ),

                const SizedBox(height: 8),

                // ==================================================
                // SIZE / COLOR
                // ==================================================

                if (item.selectedSize != null ||
                    item.selectedColor != null)
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      if (item.selectedSize != null)
                        _buildOptionChip(
                          "Size ${item.selectedSize}",
                        ),
                      if (item.selectedColor != null)
                        _buildOptionChip(
                          item.selectedColor!,
                        ),
                    ],
                  ),

                const SizedBox(height: 9),

                // ==================================================
                // PRICE
                // ==================================================

                Text(
                  "₹${item.product.price.toStringAsFixed(0)}",
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 10),

                // ==================================================
                // QUANTITY + DELETE
                // ==================================================

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    _buildQuantityControl(
                      item,
                      cartNotifier,
                    ),

                    // Delete
                    GestureDetector(
                      onTap: () async {
                        await cartNotifier.removeItem(item);
                      },
                      child: Container(
                        height: 36,
                        width: 36,
                        decoration: BoxDecoration(
                          color: const Color(0xff080C0D),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color:
                                Colors.white.withOpacity(.07),
                          ),
                        ),
                        child: const Icon(
                          Icons.delete_outline_rounded,
                          size: 17,
                          color: Colors.white54,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==============================================================
  // OPTION CHIP
  // ==============================================================

  Widget _buildOptionChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 7,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: const Color(0xff080C0D),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: GoogleFonts.outfit(
          color: Colors.white54,
          fontSize: 9,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // ==============================================================
  // QUANTITY CONTROL
  // ==============================================================

  Widget _buildQuantityControl(
    CartItemModel item,
    CartNotifier cartNotifier,
  ) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: const Color(0xff080C0D),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.white.withOpacity(.07),
        ),
      ),
      child: Row(
        children: [
          // Decrease
          _quantityButton(
            icon: Icons.remove,
            onTap: () async {
              await cartNotifier.decreaseQuantity(item);
            },
          ),

          SizedBox(
            width: 30,
            child: Center(
              child: Text(
                item.quantity.toString(),
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

          // Increase
          _quantityButton(
            icon: Icons.add,
            onTap: () async {
              await cartNotifier.increaseQuantity(item);
            },
          ),
        ],
      ),
    );
  }

  Widget _quantityButton({
    required IconData icon,
    required Future<void> Function() onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          width: 34,
          height: 36,
          child: Center(
            child: Icon(
              icon,
              size: 15,
              color: Colors.white70,
            ),
          ),
        ),
      ),
    );
  }

  // ==============================================================
  // BOTTOM SUMMARY
  // ==============================================================

  Widget _buildBottomSummary(
    BuildContext context,
    WidgetRef ref,
  ) {
    final cartNotifier =
        ref.read(cartProvider.notifier);

    return Container(
      padding: const EdgeInsets.fromLTRB(
        18,
        18,
        18,
        20,
      ),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius:
            const BorderRadius.vertical(
          top: Radius.circular(24),
        ),
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(.06),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.35),
            blurRadius: 25,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Subtotal
          _buildSummaryRow(
            "Subtotal",
            "₹${cartNotifier.subtotal.toStringAsFixed(0)}",
          ),

          const SizedBox(height: 10),

          // Delivery
          _buildSummaryRow(
            "Delivery",
            cartNotifier.deliveryCharge == 0
                ? "Free"
                : "₹${cartNotifier.deliveryCharge.toStringAsFixed(0)}",
          ),

          const SizedBox(height: 14),

          Divider(
            color: Colors.white.withOpacity(.08),
            height: 1,
          ),

          const SizedBox(height: 14),

          // Total
          _buildSummaryRow(
            "Total",
            "₹${cartNotifier.total.toStringAsFixed(0)}",
            isTotal: true,
          ),

          const SizedBox(height: 18),

          // Checkout button
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const CheckoutScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(15),
                ),
              ),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  Text(
                    "Proceed to Checkout",
                    style: GoogleFonts.outfit(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    size: 19,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==============================================================
  // SUMMARY ROW
  // ==============================================================

  Widget _buildSummaryRow(
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
            fontSize: isTotal ? 16 : 12,
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
            fontSize: isTotal ? 18 : 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  // ==============================================================
  // EMPTY CART
  // ==============================================================

  Widget _buildEmptyCart(
    BuildContext context,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            // Icon
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                color: cardColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(.06),
                ),
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                color: Colors.white54,
                size: 45,
              ),
            ),

            const SizedBox(height: 22),

            // Title
            Text(
              "Your Cart is Empty",
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 21,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 8),

            // Description
            Text(
              "Looks like you haven't added\nanything to your cart yet.",
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                color: Colors.white38,
                fontSize: 12,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  elevation: 0,
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 28,
                  ),
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(13),
                  ),
                ),
                child: Text(
                  "Continue Shopping",
                  style: GoogleFonts.outfit(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==============================================================
  // CLEAR CART DIALOG
  // ==============================================================

  void _showClearCartDialog(
    BuildContext context,
    WidgetRef ref,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            "Clear Cart?",
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(
            "Are you sure you want to remove all items from your cart?",
            style: GoogleFonts.outfit(
              color: Colors.white54,
              fontSize: 13,
              height: 1.4,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Cancel",
                style: GoogleFonts.outfit(
                  color: Colors.white54,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                await ref
                    .read(cartProvider.notifier)
                    .clearCart();

                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              child: Text(
                "Clear",
                style: GoogleFonts.outfit(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}