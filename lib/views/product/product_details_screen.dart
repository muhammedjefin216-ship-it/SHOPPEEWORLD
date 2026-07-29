import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:shoppee_world/models/product/product_model.dart';
import 'package:shoppee_world/viewmodel/cart/cart_provider.dart';
import 'package:shoppee_world/views/cart/cart_screen.dart';
import 'package:shoppee_world/views/checkout/checkout_screen.dart';

import '../../core/data/dummy_products.dart';

import '../../widgets/product/product image.dart';
import '../../widgets/product/bottom_action_bar.dart';
import '../../widgets/product/color_selector.dart';
import '../../widgets/product/product_description.dart';
import '../../widgets/product/product_info.dart';
import '../../widgets/product/quantity_selector.dart';
import '../../widgets/product/size_selector.dart';
import '../../widgets/product/product_card.dart';

class ProductDetailsScreen
    extends ConsumerStatefulWidget {
  final ProductModel product;

  const ProductDetailsScreen({
    super.key,
    required this.product,
  });

  @override
  ConsumerState<ProductDetailsScreen>
      createState() =>
          _ProductDetailsScreenState();
}

class _ProductDetailsScreenState
    extends ConsumerState<ProductDetailsScreen> {

  // ================================================================
  // SELECTED PRODUCT OPTIONS
  // ================================================================

  String? selectedSize;

  String? selectedColor;

  int quantity = 1;

  @override
  Widget build(BuildContext context) {

    // Current product
    final product = widget.product;

    // ================================================================
    // RELATED PRODUCTS
    // ================================================================

    final relatedProducts =
        dummyProducts
            .where(
              (p) => p.id != product.id,
            )
            .toList();

    return Scaffold(
      backgroundColor: Colors.white,

      // ==============================================================
      // BODY
      // ==============================================================

      body: CustomScrollView(
        physics:
            const BouncingScrollPhysics(),

        slivers: [

          // ==========================================================
          // APP BAR
          // ==========================================================

          SliverAppBar(
            pinned: true,

            backgroundColor:
                Colors.white,

            elevation: 0,

            surfaceTintColor:
                Colors.transparent,

            leading: Padding(
              padding:
                  const EdgeInsets.all(8.0),

              child: Container(
                decoration:
                    BoxDecoration(
                  color:
                      Colors.grey.shade50,

                  shape:
                      BoxShape.circle,

                  border:
                      Border.all(
                    color:
                        Colors.grey.shade200,
                  ),
                ),

                child: IconButton(
                  padding:
                      EdgeInsets.zero,

                  onPressed: () {
                    Navigator.pop(
                      context,
                    );
                  },

                  icon:
                      const Icon(
                    Icons
                        .arrow_back_ios_new_rounded,

                    color:
                        Colors.black87,

                    size: 18,
                  ),
                ),
              ),
            ),

            title: Text(
              "Product Details",

              style:
                  GoogleFonts.outfit(
                color:
                    Colors.black87,

                fontWeight:
                    FontWeight.bold,

                fontSize: 18,
              ),
            ),

            centerTitle: true,

            actions: [
              Padding(
                padding:
                    const EdgeInsets.only(
                  right: 8.0,
                ),

                child: Container(
                  decoration:
                      BoxDecoration(
                    color:
                        Colors.grey.shade50,

                    shape:
                        BoxShape.circle,

                    border:
                        Border.all(
                      color:
                          Colors.grey.shade200,
                    ),
                  ),

                  child:
                      IconButton(
                    onPressed: () {
                      ScaffoldMessenger
                          .of(context)
                          .showSnackBar(
                        SnackBar(
                          content:
                              Text(
                            "Product link copied to clipboard!",
                            style:
                                GoogleFonts.outfit(),
                          ),

                          behavior:
                              SnackBarBehavior
                                  .floating,

                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius
                                    .circular(
                              10,
                            ),
                          ),
                        ),
                      );
                    },

                    icon:
                        const Icon(
                      Icons
                          .share_outlined,

                      color:
                          Colors.black87,

                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // ==========================================================
          // PRODUCT CONTENT
          // ==========================================================

          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.fromLTRB(
                20,
                10,
                20,
                20,
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  // ==================================================
                  // PRODUCT IMAGE
                  // ==================================================

                  ProductImage(
                    image:
                        product.image,

                    productId:
                        product.id,

                    initialFavorite:
                        product.isFavorite,
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                  // ==================================================
                  // PRODUCT INFO
                  // ==================================================

                  ProductInfo(
                    product:
                        product,
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                  // ==================================================
                  // TRUST BADGES
                  // ==================================================

                  _buildTrustBadges(),

                  const SizedBox(
                    height: 28,
                  ),

                  // ==================================================
                  // SIZE SELECTOR
                  // ==================================================

                  SizeSelector(
                    selectedSize:
                        selectedSize,

                    onSizeSelected:
                        (size) {
                      setState(() {
                        selectedSize =
                            size;
                      });
                    },
                  ),

                  const SizedBox(
                    height: 28,
                  ),

                  // ==================================================
                  // COLOR SELECTOR
                  // ==================================================

                  ColorSelector(
                    selectedColor:
                        selectedColor,

                    onColorSelected:
                        (color) {
                      setState(() {
                        selectedColor =
                            color;
                      });
                    },
                  ),

                  const SizedBox(
                    height: 28,
                  ),

                  // ==================================================
                  // QUANTITY SELECTOR
                  // ==================================================

                  QuantitySelector(
                    quantity:
                        quantity,

                    onQuantityChanged:
                        (newQuantity) {
                      setState(() {
                        quantity =
                            newQuantity;
                      });
                    },
                  ),

                  const SizedBox(
                    height: 28,
                  ),

                  // ==================================================
                  // DESCRIPTION
                  // ==================================================

                  ProductDescription(
                    description:
                        "Experience premium quality with this stylish ${product.name}. Designed for everyday comfort and durability, it's perfect for both casual and active lifestyles. Crafted with attention to detail, high-grade materials, and a modern aesthetic finish to suit your daily trends.",
                  ),

                  const SizedBox(
                    height: 40,
                  ),

                  // ==================================================
                  // RELATED PRODUCTS
                  // ==================================================

                  if (relatedProducts
                      .isNotEmpty) ...[
                    Text(
                      "You May Also Like",

                      style:
                          GoogleFonts.outfit(
                        fontSize: 18,

                        fontWeight:
                            FontWeight.bold,

                        color:
                            Colors.black87,
                      ),
                    ),

                    const SizedBox(
                      height: 16,
                    ),

                    SizedBox(
                      height: 270,

                      child:
                          ListView.separated(
                        scrollDirection:
                            Axis.horizontal,

                        itemCount:
                            relatedProducts
                                .length,

                        separatorBuilder:
                            (_, __) =>
                                const SizedBox(
                          width: 16,
                        ),

                        itemBuilder:
                            (context, index) {
                          return SizedBox(
                            width: 170,

                            child:
                                ProductCard(
                              product:
                                  relatedProducts[
                                      index],
                            ),
                          );
                        },
                      ),
                    ),
                  ],

                  const SizedBox(
                    height: 100,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // ==============================================================
      // BOTTOM ACTION BAR
      // ==============================================================

      bottomNavigationBar:
          BottomActionBar(

        // ==========================================================
        // ADD TO CART
        // ==========================================================

        onAddToCart: () {
          _addToCart(
            product,
          );
        },

        // ==========================================================
        // BUY NOW
        // ==========================================================

        onBuyNow: () {
          _buyNow(
            product,
          );
        },
      ),
    );
  }

  // ================================================================
  // ADD TO CART
  // ================================================================

  void _addToCart(
  ProductModel product,
) {
  ref
      .read(cartProvider.notifier)
      .addToCart(
        product: product,
        quantity: quantity,
        selectedSize: selectedSize,
        selectedColor: selectedColor,
      );

  ScaffoldMessenger.of(context)
      .showSnackBar(
    SnackBar(
      content: Text(
        "${product.name} added to cart",
        style: GoogleFonts.outfit(
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.black87,
      behavior: SnackBarBehavior.floating,
      action: SnackBarAction(
        label: "VIEW CART",
        textColor: Colors.amber,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  const CartScreen(),
            ),
          );
        },
      ),
    ),
  );
}

  // ================================================================
  // BUY NOW
  // ================================================================

  void _buyNow(
  ProductModel product,
) {
  // Add product to cart
  ref
      .read(cartProvider.notifier)
      .addToCart(
        product: product,
        quantity: quantity,
        selectedSize: selectedSize,
        selectedColor: selectedColor,
      );

  // Go directly to checkout
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) =>
          const CheckoutScreen(),
    ),
  );
}

  // ================================================================
  // TRUST BADGES
  // ================================================================

  Widget _buildTrustBadges() {

    final badgeItems = [
      {
        "icon":
            Icons.local_shipping_outlined,
        "text":
            "Free Delivery",
      },
      {
        "icon":
            Icons.autorenew_outlined,
        "text":
            "10 Days Return",
      },
      {
        "icon":
            Icons.verified_user_outlined,
        "text":
            "Secure Checkout",
      },
    ];

    return Container(
      padding:
          const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 12,
      ),

      decoration:
          BoxDecoration(
        color:
            Colors.grey.shade50,

        borderRadius:
            BorderRadius.circular(
          16,
        ),

        border:
            Border.all(
          color:
              Colors.grey.shade100,
        ),
      ),

      child: Row(
        mainAxisAlignment:
            MainAxisAlignment
                .spaceAround,

        children:
            badgeItems.map(
          (item) {
            return Row(
              children: [
                Icon(
                  item["icon"]
                      as IconData,

                  size: 16,

                  color:
                      Colors.black54,
                ),

                const SizedBox(
                  width: 6,
                ),

                Text(
                  item["text"]
                      as String,

                  style:
                      GoogleFonts.outfit(
                    fontSize: 12,

                    fontWeight:
                        FontWeight.w600,

                    color:
                        Colors.black54,
                  ),
                ),
              ],
            );
          },
        ).toList(),
      ),
    );
  }
}