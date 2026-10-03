import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:shoppee_world/user/models/product/product_model.dart';
import 'package:shoppee_world/user/repositories/product_repository.dart';
import 'package:shoppee_world/user/viewmodel/cart/cart_provider.dart';

import 'package:shoppee_world/user/views/cart/cart_screen.dart';
import 'package:shoppee_world/user/views/checkout/checkout_screen.dart';

import '../../widgets/product/product image.dart';
import '../../widgets/product/product_info.dart';
import '../../widgets/product/product_description.dart';
import '../../widgets/product/quantity_selector.dart';
import '../../widgets/product/size_selector.dart';
import '../../widgets/product/color_selector.dart';
import '../../widgets/product/bottom_action_bar.dart';
import '../../widgets/product/product_card.dart';

class ProductDetailsScreen extends ConsumerStatefulWidget {
  final ProductModel product;

  const ProductDetailsScreen({
    super.key,
    required this.product,
  });

  @override
  ConsumerState<ProductDetailsScreen> createState() =>
      _ProductDetailsScreenState();
}

class _ProductDetailsScreenState
    extends ConsumerState<ProductDetailsScreen>
    with SingleTickerProviderStateMixin {
  // ==========================================================
  // PRODUCT OPTIONS
  // ==========================================================

  String? selectedSize;
  String? selectedColor;
  int quantity = 1;

  // ==========================================================
  // ANIMATION
  // ==========================================================

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // ==========================================================
  // RELATED PRODUCTS
  // ==========================================================

  final ProductRepository _repository = ProductRepository();

  List<ProductModel> relatedProducts = [];

  bool isLoadingRelated = true;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, .08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    _controller.forward();

    loadRelatedProducts();
  }

  Future<void> loadRelatedProducts() async {
    final products = await _repository.getProducts(
      categoryId: widget.product.categoryId,
    );

    relatedProducts = products
        .where(
          (e) => e.id != widget.product.id,
        )
        .take(6)
        .toList();

    if (mounted) {
      setState(() {
        isLoadingRelated = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      backgroundColor: const Color(0xff080C0D),

      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ======================================================
              // APP BAR
              // ======================================================

              SliverAppBar(
                pinned: true,
                backgroundColor: const Color(0xff080C0D),
                surfaceTintColor: Colors.transparent,
                elevation: 0,

                leading: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xff191D1E),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 17,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),

                centerTitle: true,

                title: Text(
                  "Product Details",
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                  ),
                ),

                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xff191D1E),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.share_outlined,
                          color: Colors.white,
                          size: 19,
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              content: Text(
                                "Share feature coming soon",
                                style: GoogleFonts.outfit(),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),

              // ======================================================
              // BODY
              // ======================================================

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // PRODUCT IMAGE
                      ProductImage(
                        image: product.image,
                        productId: product.id,
                        initialFavorite: product.isFavorite,
                      ),
 
                      const SizedBox(height: 24),

                      // PRODUCT INFO
                      ProductInfo(
                        product: product,
                      ),

                      const SizedBox(height: 22),

                      // TRUST BADGES
                      _buildTrustBadges(),

                      const SizedBox(height: 26),

                      // SIZE
                     if (product.availableSizes.isNotEmpty)
  SizeSelector(
    sizes: product.availableSizes,
    selectedSize: selectedSize,
    onSizeSelected: (value) {
      setState(() {
        selectedSize = value;
      });
    },
  ),

                      const SizedBox(height: 26),

                      // COLOR
                     if (product.availableColors.isNotEmpty)
  ColorSelector(
    colors: product.availableColors,
    selectedColor: selectedColor,
    onColorSelected: (value) {
      setState(() {
        selectedColor = value;
      });
    },
  ),

                      const SizedBox(height: 26),

                      // QUANTITY
 QuantitySelector(
  quantity: quantity,
  maxQuantity: product.stockQuantity,
  onQuantityChanged: (value) {
    setState(() {
      quantity = value;
    });
  },
),

                      const SizedBox(height: 26),

                      // DESCRIPTION
                     if (product.description.isNotEmpty)
  ProductDescription(
    description: product.description,
  ),

                      const SizedBox(height: 34),

                      // ==================================================
                      // RELATED PRODUCTS
                      // ==================================================

                      Text(
                        "You May Also Like",
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 16),

                      if (isLoadingRelated)
                        SizedBox(
                          height: 265,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: 4,
                            separatorBuilder: (_, _) =>
                                const SizedBox(width: 14),
                            itemBuilder: (_, index) {
                              return Container(
                                width: 170,
                                decoration: BoxDecoration(
                                  color: const Color(0xff191D1E),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              );
                            },
                          ),
                        )
                      else if (relatedProducts.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                              "No related products found",
                              style: GoogleFonts.outfit(
                                color: Colors.white54,
                              ),
                            ),
                          ),
                        )
                      else
                        SizedBox(
                          height: 270,
                          child: ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: relatedProducts.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(width: 14),
                            itemBuilder: (_, index) {
                              return SizedBox(
                                width: 170,
                                child: ProductCard(
                                  product: relatedProducts[index],
                                ),
                              );
                            },
                          ),
                        ),

                      const SizedBox(height: 110),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // ==========================================================
      // BOTTOM ACTION BAR
      // ==========================================================

    bottomNavigationBar: BottomActionBar(
  isOutOfStock: product.stockQuantity <= 0,
  onAddToCart: () => _addToCart(product),
  onBuyNow: () => _buyNow(product),
),
    );
  }

  // ==========================================================
  // ADD TO CART
  // ==========================================================

  void _addToCart(ProductModel product) {
    ref.read(cartProvider.notifier).addToCart(
          product: product,
          quantity: quantity,
          selectedSize: selectedSize,
          selectedColor: selectedColor,
        );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xff191D1E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        content: Text(
          "${product.name} added to cart",
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        action: SnackBarAction(
          label: "VIEW",
          textColor: Colors.white,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const CartScreen(),
              ),
            );
          },
        ),
      ),
    );
  }

  // ==========================================================
  // BUY NOW
  // ==========================================================

  void _buyNow(ProductModel product) {
    ref.read(cartProvider.notifier).addToCart(
          product: product,
          quantity: quantity,
          selectedSize: selectedSize,
          selectedColor: selectedColor,
        );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CheckoutScreen(),
      ),
    );
  }

  // ==========================================================
  // TRUST BADGES
  // ==========================================================

  Widget _buildTrustBadges() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: const Color(0xff191D1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(.06),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTrustItem(
              icon: Icons.local_shipping_outlined,
              title: "Free Delivery",
              subtitle: "On eligible orders",
            ),
          ),

          Container(
            width: 1,
            height: 38,
            color: Colors.white.withOpacity(.08),
          ),

          Expanded(
            child: _buildTrustItem(
              icon: Icons.verified_outlined,
              title: "Secure Payment",
              subtitle: "100% protected",
            ),
          ),

          Container(
            width: 1,
            height: 38,
            color: Colors.white.withOpacity(.08),
          ),

          Expanded(
            child: _buildTrustItem(
              icon: Icons.refresh_rounded,
              title: "Easy Returns",
              subtitle: "Hassle-free",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrustItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),

        const SizedBox(height: 6),

        Text(
          title,
          textAlign: TextAlign.center,
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontSize: 9,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 2),

        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: GoogleFonts.outfit(
            color: Colors.white38,
            fontSize: 8,
          ),
        ),
      ],
    );
  }
}