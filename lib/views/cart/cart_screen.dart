import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shoppee_world/models/cart/cart_item_model.dart';

import '../../viewmodel/cart/cart_provider.dart';
import '../checkout/checkout_screen.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);

    final cartNotifier = ref.read(cartProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,

      // ============================================================
      // APP BAR
      // ============================================================

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black87,
            size: 20,
          ),
        ),

        centerTitle: true,

        title: Text(
          "My Cart",
          style: GoogleFonts.outfit(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [
          if (cartItems.isNotEmpty)
            IconButton(
              onPressed: () {
                _showClearCartDialog(
                  context,
                  ref,
                );
              },
              icon: const Icon(
                Icons.delete_outline_rounded,
                color: Colors.black87,
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
                    padding: const EdgeInsets.fromLTRB(
                      20,
                      20,
                      20,
                      20,
                    ),

                    itemCount: cartItems.length,

                    separatorBuilder: (_, __) =>
                        const SizedBox(height: 16),

                    itemBuilder: (context, index) {
                      final item = cartItems[index];

                      return _buildCartItem(
                        context,
                        ref,
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
  WidgetRef ref,
  CartItemModel item,
  CartNotifier cartNotifier,
) {
    return Container(
      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(
        color: Colors.grey.shade50,

        borderRadius: BorderRadius.circular(18),

        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),

      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          // ========================================================
          // PRODUCT IMAGE
          // ========================================================

          ClipRRect(
            borderRadius:
                BorderRadius.circular(14),

            child: Image.network(
              item.product.image,

              width: 95,
              height: 110,

              fit: BoxFit.cover,

              errorBuilder:
                  (context, error, stackTrace) {
                return Container(
                  width: 95,
                  height: 110,
                  color: Colors.grey.shade200,

                  child: const Icon(
                    Icons.image_not_supported_outlined,
                    color: Colors.grey,
                  ),
                );
              },
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
                // Product Name
                Text(
                  item.product.name,

                  maxLines: 2,

                  overflow:
                      TextOverflow.ellipsis,

                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight:
                        FontWeight.bold,
                    color:
                        Colors.black87,
                  ),
                ),

                const SizedBox(height: 6),

                // Category
                Text(
                  item.product.category,

                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color:
                        Colors.black54,
                  ),
                ),

                const SizedBox(height: 8),

                // Size
                if (item.selectedSize != null)
                  Text(
                    "Size: ${item.selectedSize}",

                    style:
                        GoogleFonts.outfit(
                      fontSize: 12,
                      color:
                          Colors.black54,
                      fontWeight:
                          FontWeight.w500,
                    ),
                  ),

                // Color
                if (item.selectedColor != null)
                  Text(
                    "Color: ${item.selectedColor}",

                    style:
                        GoogleFonts.outfit(
                      fontSize: 12,
                      color:
                          Colors.black54,
                      fontWeight:
                          FontWeight.w500,
                    ),
                  ),

                const SizedBox(height: 10),

                // Price
                Text(
                  "₹${item.product.price.toStringAsFixed(0)}",

                  style: GoogleFonts.outfit(
                    fontSize: 17,
                    fontWeight:
                        FontWeight.bold,
                    color:
                        Colors.black,
                  ),
                ),

                const SizedBox(height: 10),

                // Quantity Controls
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,

                  children: [
                    _buildQuantityControl(
                      item,
                      cartNotifier,
                    ),

                    // Remove
                    GestureDetector(
                      onTap: () {
                        cartNotifier
                            .removeItem(item);
                      },

                      child: Container(
                        padding:
                            const EdgeInsets.all(
                          8,
                        ),

                        decoration:
                            BoxDecoration(
                          color:
                              Colors.white,

                          shape:
                              BoxShape.circle,

                          border:
                              Border.all(
                            color: Colors
                                .grey
                                .shade200,
                          ),
                        ),

                        child: const Icon(
                          Icons
                              .delete_outline_rounded,
                          size: 18,
                          color:
                              Colors.black54,
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
  // QUANTITY CONTROL
  // ==============================================================

  Widget _buildQuantityControl(
    dynamic item,
    dynamic cartNotifier,
  ) {
    return Container(
      height: 38,

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(20),

        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),

      child: Row(
        children: [
          // Decrease
          IconButton(
            onPressed: () {
              cartNotifier
                  .decreaseQuantity(item);
            },

            padding: EdgeInsets.zero,

            constraints:
                const BoxConstraints(
              minWidth: 38,
              minHeight: 38,
            ),

            icon: const Icon(
              Icons.remove,
              size: 16,
            ),
          ),

          // Quantity
          Text(
            item.quantity.toString(),

            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          // Increase
          IconButton(
            onPressed: () {
              cartNotifier
                  .increaseQuantity(item);
            },

            padding: EdgeInsets.zero,

            constraints:
                const BoxConstraints(
              minWidth: 38,
              minHeight: 38,
            ),

            icon: const Icon(
              Icons.add,
              size: 16,
            ),
          ),
        ],
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
        20,
        20,
        20,
        24,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            const BorderRadius.vertical(
          top: Radius.circular(24),
        ),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(
              0.06,
            ),
            blurRadius: 20,
            offset:
                const Offset(0, -5),
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
            "₹${cartNotifier.deliveryCharge.toStringAsFixed(0)}",
          ),

          const Padding(
            padding:
                EdgeInsets.symmetric(
              vertical: 14,
            ),
            child: Divider(),
          ),

          // Total
          _buildSummaryRow(
            "Total",
            "₹${cartNotifier.total.toStringAsFixed(0)}",
            isTotal: true,
          ),

          const SizedBox(height: 20),

          // ========================================================
          // CHECKOUT BUTTON
          // ========================================================

          SizedBox(
            width: double.infinity,
            height: 55,

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

              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.black,

                foregroundColor:
                    Colors.white,

                elevation: 0,

                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                    16,
                  ),
                ),
              ),

              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.center,

                children: [
                  Text(
                    "Proceed to Checkout",

                    style:
                        GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(width: 8),

                  const Icon(
                    Icons
                        .arrow_forward_rounded,
                    size: 20,
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
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,

      children: [
        Text(
          title,

          style: GoogleFonts.outfit(
            fontSize:
                isTotal ? 18 : 14,

            fontWeight: isTotal
                ? FontWeight.bold
                : FontWeight.w500,

            color: isTotal
                ? Colors.black
                : Colors.black54,
          ),
        ),

        Text(
          value,

          style: GoogleFonts.outfit(
            fontSize:
                isTotal ? 20 : 15,

            fontWeight:
                FontWeight.bold,

            color: Colors.black,
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
        padding:
            const EdgeInsets.all(30),

        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [
            Container(
              width: 100,
              height: 100,

              decoration:
                  BoxDecoration(
                color:
                    Colors.grey.shade100,

                shape:
                    BoxShape.circle,
              ),

              child: const Icon(
                Icons
                    .shopping_bag_outlined,

                size: 50,

                color:
                    Colors.black54,
              ),
            ),

            const SizedBox(height: 24),

            Text(
              "Your Cart is Empty",

              style: GoogleFonts.outfit(
                fontSize: 22,
                fontWeight:
                    FontWeight.bold,
                color:
                    Colors.black87,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              "Looks like you haven't added anything to your cart yet.",

              textAlign:
                  TextAlign.center,

              style: GoogleFonts.outfit(
                fontSize: 14,
                color:
                    Colors.black54,
              ),
            ),

            const SizedBox(height: 28),

            // Continue Shopping
            SizedBox(
              height: 50,

              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(
                    context,
                  );
                },

                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.black,

                  foregroundColor:
                      Colors.white,

                  elevation: 0,

                  padding:
                      const EdgeInsets
                          .symmetric(
                    horizontal: 30,
                  ),

                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      14,
                    ),
                  ),
                ),

                child: Text(
                  "Continue Shopping",

                  style:
                      GoogleFonts.outfit(
                    fontWeight:
                        FontWeight.bold,
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
          title: Text(
            "Clear Cart?",
            style: GoogleFonts.outfit(
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          content: Text(
            "Are you sure you want to remove all items from your cart?",

            style: GoogleFonts.outfit(),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                );
              },

              child: Text(
                "Cancel",

                style:
                    GoogleFonts.outfit(
                  color: Colors.black54,
                ),
              ),
            ),

            TextButton(
              onPressed: () {
                ref
                    .read(
                      cartProvider
                          .notifier,
                    )
                    .clearCart();

                Navigator.pop(
                  context,
                );
              },

              child: Text(
                "Clear",

                style:
                    GoogleFonts.outfit(
                  color: Colors.red,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}