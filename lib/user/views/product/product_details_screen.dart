// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_fonts/google_fonts.dart';

// import 'package:shoppee_world/user/models/product/product_model.dart';
// import 'package:shoppee_world/user/repositories/product_repository.dart';
// import 'package:shoppee_world/user/viewmodel/cart/cart_provider.dart';

// import 'package:shoppee_world/user/views/cart/cart_screen.dart';
// import 'package:shoppee_world/user/views/checkout/checkout_screen.dart';

// import '../../widgets/product/product image.dart';
// import '../../widgets/product/product_info.dart';
// import '../../widgets/product/product_description.dart';
// import '../../widgets/product/quantity_selector.dart';
// import '../../widgets/product/size_selector.dart';
// import '../../widgets/product/color_selector.dart';
// import '../../widgets/product/bottom_action_bar.dart';
// import '../../widgets/product/product_card.dart';

// class ProductDetailsScreen extends ConsumerStatefulWidget {
//   final ProductModel product;

//   const ProductDetailsScreen({
//     super.key,
//     required this.product,
//   });

//   @override
//   ConsumerState<ProductDetailsScreen> createState() =>
//       _ProductDetailsScreenState();
// }

// class _ProductDetailsScreenState
//     extends ConsumerState<ProductDetailsScreen>
//     with SingleTickerProviderStateMixin {

//       List<String> selectedProductImages = [];
//   // ==========================================================
//   // PRODUCT OPTIONS
//   // ==========================================================

//   String? selectedSize;
//   String? selectedColor;
//   int quantity = 1;

//   // ==========================================================
//   // ANIMATION
//   // ==========================================================

//   late AnimationController _controller;
//   late Animation<double> _fadeAnimation;
//   late Animation<Offset> _slideAnimation;

//   // ==========================================================
//   // RELATED PRODUCTS
//   // ==========================================================

//   final ProductRepository _repository = ProductRepository();

//   List<ProductModel> relatedProducts = [];

//   bool isLoadingRelated = true;

//   @override
//   void initState() {
//     super.initState();

//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 700),
//     );

//     _fadeAnimation = CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeOut,
//     );

//     _slideAnimation = Tween<Offset>(
//       begin: const Offset(0, .08),
//       end: Offset.zero,
//     ).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: Curves.easeOutCubic,
//       ),
//     );

//     _controller.forward();

//     loadRelatedProducts();
//   }

//   Future<void> loadRelatedProducts() async {
//     final products = await _repository.getProducts(
//       categoryId: widget.product.categoryId,
//     );

//     relatedProducts = products
//         .where(
//           (e) => e.id != widget.product.id,
//         )
//         .take(6)
//         .toList();

//     if (mounted) {
//       setState(() {
//         isLoadingRelated = false;
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final product = widget.product;

//     return Scaffold(
//       backgroundColor: const Color(0xff080C0D),

//       body: FadeTransition(
//         opacity: _fadeAnimation,
//         child: SlideTransition(
//           position: _slideAnimation,
//           child: CustomScrollView(
//             physics: const BouncingScrollPhysics(),
//             slivers: [
//               // ======================================================
//               // APP BAR
//               // ======================================================

//               SliverAppBar(
//                 pinned: true,
//                 backgroundColor: const Color(0xff080C0D),
//                 surfaceTintColor: Colors.transparent,
//                 elevation: 0,

//                 leading: Padding(
//                   padding: const EdgeInsets.all(8),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: const Color(0xff191D1E),
//                       shape: BoxShape.circle,
//                     ),
//                     child: IconButton(
//                       icon: const Icon(
//                         Icons.arrow_back_ios_new_rounded,
//                         size: 17,
//                         color: Colors.white,
//                       ),
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                     ),
//                   ),
//                 ),

//                 centerTitle: true,

//                 title: Text(
//                   "Product Details",
//                   style: GoogleFonts.outfit(
//                     color: Colors.white,
//                     fontWeight: FontWeight.w700,
//                     fontSize: 17,
//                   ),
//                 ),

//                 actions: [
//                   Padding(
//                     padding: const EdgeInsets.only(right: 10),
//                     child: Container(
//                       decoration: const BoxDecoration(
//                         color: Color(0xff191D1E),
//                         shape: BoxShape.circle,
//                       ),
//                       child: IconButton(
//                         icon: const Icon(
//                           Icons.share_outlined,
//                           color: Colors.white,
//                           size: 19,
//                         ),
//                         onPressed: () {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(
//                               behavior: SnackBarBehavior.floating,
//                               content: Text(
//                                 "Share feature coming soon",
//                                 style: GoogleFonts.outfit(),
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ),
//                 ],
//               ),

//               // ======================================================
//               // BODY
//               // ======================================================

//               SliverToBoxAdapter(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 18,
//                     vertical: 10,
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // PRODUCT IMAGE
//                       ProductImage(
//   image: product.image,
//   productId: product.id,
//   initialFavorite: product.isFavorite,
//   onImagesSelected: (images) {
//     setState(() {
//       selectedProductImages = images;
//     });
//   },
// ),
 
//                       const SizedBox(height: 24),

//                       // PRODUCT INFO
//                       ProductInfo(
//                         product: product,
//                       ),

//                       const SizedBox(height: 22),

//                       // TRUST BADGES
//                       _buildTrustBadges(),

//                       const SizedBox(height: 26),

//                       // SIZE
//                      if (product.availableSizes.isNotEmpty)
//   SizeSelector(
//     sizes: product.availableSizes,
//     selectedSize: selectedSize,
//     onSizeSelected: (value) {
//       setState(() {
//         selectedSize = value;
//       });
//     },
//   ),

//                       const SizedBox(height: 26),

//                       // COLOR
//                      if (product.availableColors.isNotEmpty)
//   ColorSelector(
//     colors: product.availableColors,
//     selectedColor: selectedColor,
//     onColorSelected: (value) {
//       setState(() {
//         selectedColor = value;
//       });
//     },
//   ),

//                       const SizedBox(height: 26),

//                       // QUANTITY
//  QuantitySelector(
//   quantity: quantity,
//   maxQuantity: product.stockQuantity,
//   onQuantityChanged: (value) {
//     setState(() {
//       quantity = value;
//     });
//   },
// ),

//                       const SizedBox(height: 26),

//                       // DESCRIPTION
//                      if (product.description.isNotEmpty)
//   ProductDescription(
//     description: product.description,
//   ),

//                       const SizedBox(height: 34),

//                       // ==================================================
//                       // RELATED PRODUCTS
//                       // ==================================================

//                       Text(
//                         "You May Also Like",
//                         style: GoogleFonts.outfit(
//                           color: Colors.white,
//                           fontSize: 18,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),

//                       const SizedBox(height: 16),

//                       if (isLoadingRelated)
//                         SizedBox(
//                           height: 265,
//                           child: ListView.separated(
//                             scrollDirection: Axis.horizontal,
//                             itemCount: 4,
//                             separatorBuilder: (_, _) =>
//                                 const SizedBox(width: 14),
//                             itemBuilder: (_, index) {
//                               return Container(
//                                 width: 170,
//                                 decoration: BoxDecoration(
//                                   color: const Color(0xff191D1E),
//                                   borderRadius: BorderRadius.circular(18),
//                                 ),
//                               );
//                             },
//                           ),
//                         )
//                       else if (relatedProducts.isEmpty)
//                         Center(
//                           child: Padding(
//                             padding: const EdgeInsets.all(20),
//                             child: Text(
//                               "No related products found",
//                               style: GoogleFonts.outfit(
//                                 color: Colors.white54,
//                               ),
//                             ),
//                           ),
//                         )
//                       else
//                         SizedBox(
//                           height: 270,
//                           child: ListView.separated(
//                             physics: const BouncingScrollPhysics(),
//                             scrollDirection: Axis.horizontal,
//                             itemCount: relatedProducts.length,
//                             separatorBuilder: (_, _) =>
//                                 const SizedBox(width: 14),
//                             itemBuilder: (_, index) {
//                               return SizedBox(
//                                 width: 170,
//                                 child: ProductCard(
//                                   product: relatedProducts[index],
//                                 ),
//                               );
//                             },
//                           ),
//                         ),

//                       const SizedBox(height: 110),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),

//       // ==========================================================
//       // BOTTOM ACTION BAR
//       // ==========================================================

//     bottomNavigationBar: BottomActionBar(
//   isOutOfStock: product.stockQuantity <= 0,
//   onAddToCart: () => _addToCart(product),
//   onBuyNow: () => _buyNow(product),
// ),
//     );
//   }

//   // ==========================================================
//   // ADD TO CART
//   // ==========================================================

//   void _addToCart(ProductModel product) {
//     ref.read(cartProvider.notifier).addToCart(
//           product: product,
//           quantity: quantity,
//           selectedSize: selectedSize,
//           selectedColor: selectedColor,
//         );

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         behavior: SnackBarBehavior.floating,
//         backgroundColor: const Color(0xff191D1E),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(14),
//         ),
//         content: Text(
//           "${product.name} added to cart",
//           style: GoogleFonts.outfit(
//             color: Colors.white,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         action: SnackBarAction(
//           label: "VIEW",
//           textColor: Colors.white,
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (_) => const CartScreen(),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   // ==========================================================
//   // BUY NOW
//   // ==========================================================

//   void _buyNow(ProductModel product) {
//   ref.read(cartProvider.notifier).addToCart(
//         product: product,
//         quantity: quantity,
//         selectedSize: selectedSize,
//         selectedColor: selectedColor,
//       );

//   final imagesToShare = selectedProductImages.isEmpty
//       ? [product.image]
//       : selectedProductImages;

//   Navigator.push(
//     context,
//     MaterialPageRoute(
//       builder: (_) => CheckoutScreen(
//         selectedProductImages: imagesToShare,
//       ),
//     ),
//   );
// }

//   // ==========================================================
//   // TRUST BADGES
//   // ==========================================================

//   Widget _buildTrustBadges() {
//     return Container(
//       padding: const EdgeInsets.symmetric(
//         horizontal: 10,
//         vertical: 14,
//       ),
//       decoration: BoxDecoration(
//         color: const Color(0xff191D1E),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: Colors.white.withOpacity(.06),
//         ),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: _buildTrustItem(
//               icon: Icons.local_shipping_outlined,
//               title: "Free Delivery",
//               subtitle: "On eligible orders",
//             ),
//           ),

//           Container(
//             width: 1,
//             height: 38,
//             color: Colors.white.withOpacity(.08),
//           ),

//           Expanded(
//             child: _buildTrustItem(
//               icon: Icons.verified_outlined,
//               title: "Secure Payment",
//               subtitle: "100% protected",
//             ),
//           ),

//           Container(
//             width: 1,
//             height: 38,
//             color: Colors.white.withOpacity(.08),
//           ),

//           Expanded(
//             child: _buildTrustItem(
//               icon: Icons.refresh_rounded,
//               title: "Easy Returns",
//               subtitle: "Hassle-free",
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTrustItem({
//     required IconData icon,
//     required String title,
//     required String subtitle,
//   }) {
//     return Column(
//       children: [
//         Icon(
//           icon,
//           color: Colors.white,
//           size: 20,
//         ),

//         const SizedBox(height: 6),

//         Text(
//           title,
//           textAlign: TextAlign.center,
//           style: GoogleFonts.outfit(
//             color: Colors.white,
//             fontSize: 9,
//             fontWeight: FontWeight.w600,
//           ),
//         ),

//         const SizedBox(height: 2),

//         Text(
//           subtitle,
//           textAlign: TextAlign.center,
//           style: GoogleFonts.outfit(
//             color: Colors.white38,
//             fontSize: 8,
//           ),
//         ),
//       ],
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:shoppee_world/user/core/theme/app_tokens.dart';

// import 'package:shoppee_world/user/models/product/product_model.dart';
// import 'package:shoppee_world/user/repositories/product_repository.dart';
// import 'package:shoppee_world/user/viewmodel/cart/cart_provider.dart';

// import 'package:shoppee_world/user/views/cart/cart_screen.dart';
// import 'package:shoppee_world/user/views/checkout/checkout_screen.dart';
// import 'package:shoppee_world/user/widgets/product/product%20image.dart';

// import '../../widgets/product/product_info.dart';
// import '../../widgets/product/product_description.dart';
// import '../../widgets/product/quantity_selector.dart';
// import '../../widgets/product/size_selector.dart';
// import '../../widgets/product/color_selector.dart';
// import '../../widgets/product/bottom_action_bar.dart';
// import '../../widgets/product/product_card.dart';

// class ProductDetailsScreen extends ConsumerStatefulWidget {
//   final ProductModel product;

//   const ProductDetailsScreen({
//     super.key,
//     required this.product,
//   });

//   @override
//   ConsumerState<ProductDetailsScreen> createState() =>
//       _ProductDetailsScreenState();
// }

// class _ProductDetailsScreenState
//     extends ConsumerState<ProductDetailsScreen>
//     with SingleTickerProviderStateMixin {
//   List<String> selectedProductImages = [];

//   // ==========================================================
//   // PRODUCT OPTIONS
//   // ==========================================================

//   String? selectedSize;
//   String? selectedColor;
//   int quantity = 1;

//   // ==========================================================
//   // ANIMATION
//   // ==========================================================

//   late AnimationController _controller;
//   late Animation<double> _fadeAnimation;

//   // ==========================================================
//   // RELATED PRODUCTS
//   // ==========================================================

//   final ProductRepository _repository = ProductRepository();

//   List<ProductModel> relatedProducts = [];

//   bool isLoadingRelated = true;

//   @override
//   void initState() {
//     super.initState();

//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 250),
//     );

//     _fadeAnimation = CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeOut,
//     );

//     _controller.forward();

//     loadRelatedProducts();
//   }

//   Future<void> loadRelatedProducts() async {
//     try {
//       final products = await _repository.getProducts(
//         categoryId: widget.product.categoryId,
//       );

//       relatedProducts = products
//           .where(
//             (e) => e.id != widget.product.id,
//           )
//           .take(6)
//           .toList();
//     } catch (_) {
//       // If the request fails, fall back to the empty state
//       // instead of showing the loading skeleton forever.
//       relatedProducts = [];
//     }

//     if (mounted) {
//       setState(() {
//         isLoadingRelated = false;
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final product = widget.product;

//     final topInset = MediaQuery.of(context).padding.top;

//     return Scaffold(
//       backgroundColor: AppTokens.background,

//       body: AnnotatedRegion<SystemUiOverlayStyle>(
//         value: SystemUiOverlayStyle.light,
//         child: FadeTransition(
//           opacity: _fadeAnimation,
//           child: Stack(
//             children: [
//               CustomScrollView(
//                 physics: const BouncingScrollPhysics(),
//                 slivers: [
//                   SliverToBoxAdapter(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // ==============================================
//                         // PRODUCT IMAGE (full-bleed)
//                         // ==============================================

//                         ProductImage(
//                           image: product.image,
//                           productId: product.id,
//                           initialFavorite: product.isFavorite,
//                           onImagesSelected: (images) {
//                             setState(() {
//                               selectedProductImages = images;
//                             });
//                           },
//                         ),

//                         // ==============================================
//                         // DETAILS
//                         // ==============================================

//                         Padding(
//                           padding: const EdgeInsets.fromLTRB(
//                             AppTokens.gutter,
//                             AppTokens.s16,
//                             AppTokens.gutter,
//                             AppTokens.s16,
//                           ),
//                           child: Column(
//                             crossAxisAlignment:
//                                 CrossAxisAlignment.start,
//                             children: [
//                               // PRODUCT INFO
//                               ProductInfo(
//                                 product: product,
//                               ),

//                               const SizedBox(height: AppTokens.s24),

//                               const Divider(
//                                 height: 1,
//                                 thickness: 1,
//                                 color: AppTokens.border,
//                               ),

//                               const SizedBox(height: AppTokens.s24),

//                               // SIZE
//                               if (product.availableSizes.isNotEmpty) ...[
//                                 SizeSelector(
//                                   sizes: product.availableSizes,
//                                   selectedSize: selectedSize,
//                                   onSizeSelected: (value) {
//                                     setState(() {
//                                       selectedSize = value;
//                                     });
//                                   },
//                                 ),
//                                 const SizedBox(height: AppTokens.s24),
//                               ],

//                               // COLOR
//                               if (product.availableColors.isNotEmpty) ...[
//                                 ColorSelector(
//                                   colors: product.availableColors,
//                                   selectedColor: selectedColor,
//                                   onColorSelected: (value) {
//                                     setState(() {
//                                       selectedColor = value;
//                                     });
//                                   },
//                                 ),
//                                 const SizedBox(height: AppTokens.s24),
//                               ],

//                               // QUANTITY
//                               QuantitySelector(
//                                 quantity: quantity,
//                                 maxQuantity: product.stockQuantity,
//                                 onQuantityChanged: (value) {
//                                   setState(() {
//                                     quantity = value;
//                                   });
//                                 },
//                               ),

//                               const SizedBox(height: AppTokens.s24),

//                               // DELIVERY STRIP
//                               _buildDeliveryStrip(),

//                               const SizedBox(height: AppTokens.s24),

//                               // DESCRIPTION
//                               if (product.description.isNotEmpty) ...[
//                                 ProductDescription(
//                                   description: product.description,
//                                 ),
//                                 const SizedBox(height: AppTokens.s24),
//                               ],

//                               const Divider(
//                                 height: 1,
//                                 thickness: 1,
//                                 color: AppTokens.border,
//                               ),

//                               const SizedBox(height: AppTokens.s24),

//                               // ==========================================
//                               // RELATED PRODUCTS
//                               // ==========================================

//                               Text(
//                                 "Related products",
//                                 style: AppTokens.sectionTitle,
//                               ),

//                               const SizedBox(height: AppTokens.s16),

//                               if (isLoadingRelated)
//                                 SizedBox(
//                                   height: 265,
//                                   child: ListView.separated(
//                                     scrollDirection: Axis.horizontal,
//                                     itemCount: 4,
//                                     separatorBuilder: (_, _) =>
//                                         const SizedBox(width: 12),
//                                     itemBuilder: (_, index) {
//                                       return _buildRelatedSkeleton();
//                                     },
//                                   ),
//                                 )
//                               else if (relatedProducts.isEmpty)
//                                 Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                     vertical: AppTokens.s8,
//                                   ),
//                                   child: Text(
//                                     "No related products found",
//                                     style: AppTokens.caption,
//                                   ),
//                                 )
//                               else
//                                 SizedBox(
//                                   height: 270,
//                                   child: ListView.separated(
//                                     physics:
//                                         const BouncingScrollPhysics(),
//                                     scrollDirection: Axis.horizontal,
//                                     itemCount: relatedProducts.length,
//                                     separatorBuilder: (_, _) =>
//                                         const SizedBox(width: 12),
//                                     itemBuilder: (_, index) {
//                                       return SizedBox(
//                                         width: 170,
//                                         child: ProductCard(
//                                           product:
//                                               relatedProducts[index],
//                                         ),
//                                       );
//                                     },
//                                   ),
//                                 ),

//                               const SizedBox(height: AppTokens.s32),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),

//               // ======================================================
//               // FLOATING BACK BUTTON
//               // ======================================================

//               Positioned(
//                 top: topInset + 8,
//                 left: AppTokens.gutter,
//                 child: Material(
//                   color: AppTokens.background,
//                   shape: const CircleBorder(),
//                   child: InkWell(
//                     customBorder: const CircleBorder(),
//                     onTap: () {
//                       Navigator.pop(context);
//                     },
//                     child: const SizedBox(
//                       height: 40,
//                       width: 40,
//                       child: Tooltip(
//                         message: "Back",
//                         child: Icon(
//                           Icons.arrow_back_rounded,
//                           size: 20,
//                           color: AppTokens.textPrimary,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),

//       // ==========================================================
//       // BOTTOM ACTION BAR
//       // ==========================================================

//       bottomNavigationBar: BottomActionBar(
//         isOutOfStock: product.stockQuantity <= 0,
//         onAddToCart: () => _addToCart(product),
//         onBuyNow: () => _buyNow(product),
//       ),
//     );
//   }

//   // ==========================================================
//   // ADD TO CART
//   // ==========================================================

//   void _addToCart(ProductModel product) {
//     ref.read(cartProvider.notifier).addToCart(
//           product: product,
//           quantity: quantity,
//           selectedSize: selectedSize,
//           selectedColor: selectedColor,
//         );

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         behavior: SnackBarBehavior.floating,
//         backgroundColor: AppTokens.surface,
//         elevation: 0,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(AppTokens.radiusLg),
//           side: const BorderSide(color: AppTokens.borderStrong),
//         ),
//         content: Text(
//           "${product.name} added to cart",
//           maxLines: 2,
//           overflow: TextOverflow.ellipsis,
//           style: AppTokens.bodyStrong,
//         ),
//         action: SnackBarAction(
//           label: "View cart",
//           textColor: AppTokens.accent,
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (_) => const CartScreen(),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   // ==========================================================
//   // BUY NOW
//   // ==========================================================

//   void _buyNow(ProductModel product) {
//     ref.read(cartProvider.notifier).addToCart(
//           product: product,
//           quantity: quantity,
//           selectedSize: selectedSize,
//           selectedColor: selectedColor,
//         );

//     final imagesToShare = selectedProductImages.isEmpty
//         ? [product.image]
//         : selectedProductImages;

//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => CheckoutScreen(
//           selectedProductImages: imagesToShare,
//         ),
//       ),
//     );
//   }

//   // ==========================================================
//   // RELATED PRODUCTS SKELETON
//   // ==========================================================

//   Widget _skeletonBar({double? height, double? width}) {
//     return Container(
//       height: height,
//       width: width,
//       decoration: BoxDecoration(
//         color: AppTokens.border,
//         borderRadius: BorderRadius.circular(4),
//       ),
//     );
//   }

//   Widget _buildRelatedSkeleton() {
//     return Container(
//       width: 170,
//       padding: const EdgeInsets.all(AppTokens.s12),
//       decoration: BoxDecoration(
//         color: AppTokens.surface,
//         borderRadius: BorderRadius.circular(AppTokens.radiusLg),
//         border: Border.all(color: AppTokens.border),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             child: _skeletonBar(width: double.infinity),
//           ),
//           const SizedBox(height: AppTokens.s12),
//           _skeletonBar(height: 10, width: 120),
//           const SizedBox(height: AppTokens.s8),
//           _skeletonBar(height: 10, width: 70),
//         ],
//       ),
//     );
//   }

//   // ==========================================================
//   // DELIVERY STRIP
//   // ==========================================================

//   Widget _buildDeliveryStrip() {
//     return Container(
//       padding: const EdgeInsets.all(AppTokens.s12),
//       decoration: BoxDecoration(
//         color: AppTokens.surface,
//         borderRadius: BorderRadius.circular(AppTokens.radiusLg),
//       ),
//       child: Row(
//         children: [
//           const Icon(
//             Icons.local_shipping_outlined,
//             color: AppTokens.textPrimary,
//             size: 20,
//           ),

//           const SizedBox(width: 10),

//           Expanded(
//             child: Text(
//               "Free delivery on eligible orders · Secure payment · Easy returns",
//               style: AppTokens.caption.copyWith(fontSize: 13),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoppee_world/user/core/theme/app_tokens.dart';

import 'package:shoppee_world/user/models/product/product_model.dart';
import 'package:shoppee_world/user/repositories/product_repository.dart';
import 'package:shoppee_world/user/viewmodel/cart/cart_provider.dart';

import 'package:shoppee_world/user/views/cart/cart_screen.dart';
import 'package:shoppee_world/user/views/checkout/checkout_screen.dart';

import '../../widgets/product/product_image.dart';
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
  List<String> selectedProductImages = [];

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
      duration: const Duration(milliseconds: 250),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _controller.forward();

    loadRelatedProducts();
  }

  Future<void> loadRelatedProducts() async {
    try {
      final products = await _repository.getProducts(
        categoryId: widget.product.categoryId,
      );

      relatedProducts = products
          .where(
            (e) => e.id != widget.product.id,
          )
          .take(6)
          .toList();
    } catch (_) {
      // If the request fails, fall back to the empty state
      // instead of showing the loading skeleton forever.
      relatedProducts = [];
    }

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

    final topInset = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppTokens.background,

      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Stack(
            children: [
              CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ==============================================
                        // PRODUCT IMAGE (full-bleed)
                        // ==============================================

                        ProductImage(
                          image: product.image,
                          productId: product.id,
                          initialFavorite: product.isFavorite,
                          onImagesSelected: (images) {
                            setState(() {
                              selectedProductImages = images;
                            });
                          },
                        ),

                        // ==============================================
                        // DETAILS
                        // ==============================================

                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                            AppTokens.gutter,
                            AppTokens.s16,
                            AppTokens.gutter,
                            AppTokens.s16,
                          ),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              // PRODUCT INFO
                              ProductInfo(
                                product: product,
                              ),

                              const SizedBox(height: AppTokens.s24),

                              const Divider(
                                height: 1,
                                thickness: 1,
                                color: AppTokens.border,
                              ),

                              const SizedBox(height: AppTokens.s24),

                              // SIZE
                              if (product.availableSizes.isNotEmpty) ...[
                                SizeSelector(
                                  sizes: product.availableSizes,
                                  selectedSize: selectedSize,
                                  onSizeSelected: (value) {
                                    setState(() {
                                      selectedSize = value;
                                    });
                                  },
                                ),
                                const SizedBox(height: AppTokens.s24),
                              ],

                              // COLOR
                              if (product.availableColors.isNotEmpty) ...[
                                ColorSelector(
                                  colors: product.availableColors,
                                  selectedColor: selectedColor,
                                  onColorSelected: (value) {
                                    setState(() {
                                      selectedColor = value;
                                    });
                                  },
                                ),
                                const SizedBox(height: AppTokens.s24),
                              ],

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

                              const SizedBox(height: AppTokens.s24),

                              // DELIVERY STRIP
                              _buildDeliveryStrip(),

                              const SizedBox(height: AppTokens.s24),

                              // DESCRIPTION
                              if (product.description.isNotEmpty) ...[
                                ProductDescription(
                                  description: product.description,
                                ),
                                const SizedBox(height: AppTokens.s24),
                              ],

                              const Divider(
                                height: 1,
                                thickness: 1,
                                color: AppTokens.border,
                              ),

                              const SizedBox(height: AppTokens.s24),

                              // ==========================================
                              // RELATED PRODUCTS
                              // ==========================================

                              Text(
                                "Related products",
                                style: AppTokens.sectionTitle,
                              ),

                              const SizedBox(height: AppTokens.s16),

                              if (isLoadingRelated)
                                SizedBox(
                                  height: 284,
                                  child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: 4,
                                    separatorBuilder: (_, _) =>
                                        const SizedBox(width: 12),
                                    itemBuilder: (_, index) {
                                      return _buildRelatedSkeleton();
                                    },
                                  ),
                                )
                              else if (relatedProducts.isEmpty)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: AppTokens.s8,
                                  ),
                                  child: Text(
                                    "No related products found",
                                    style: AppTokens.caption,
                                  ),
                                )
                              else
                                SizedBox(
                                  height: 284,
                                  child: ListView.separated(
                                    physics:
                                        const BouncingScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: relatedProducts.length,
                                    separatorBuilder: (_, _) =>
                                        const SizedBox(width: 12),
                                    itemBuilder: (_, index) {
                                      return SizedBox(
                                        width: 170,
                                        child: ProductCard(
                                          product:
                                              relatedProducts[index],
                                        ),
                                      );
                                    },
                                  ),
                                ),

                              const SizedBox(height: AppTokens.s32),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // ======================================================
              // FLOATING BACK BUTTON
              // ======================================================

              Positioned(
                top: topInset + 8,
                left: AppTokens.gutter,
                child: Material(
                  color: AppTokens.background,
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const SizedBox(
                      height: 40,
                      width: 40,
                      child: Tooltip(
                        message: "Back",
                        child: Icon(
                          Icons.arrow_back_rounded,
                          size: 20,
                          color: AppTokens.textPrimary,
                        ),
                      ),
                    ),
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
        backgroundColor: AppTokens.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTokens.radiusLg),
          side: const BorderSide(color: AppTokens.borderStrong),
        ),
        content: Text(
          "${product.name} added to cart",
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTokens.bodyStrong,
        ),
        action: SnackBarAction(
          label: "View cart",
          textColor: AppTokens.accent,
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

    final imagesToShare = selectedProductImages.isEmpty
        ? [product.image]
        : selectedProductImages;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CheckoutScreen(
          selectedProductImages: imagesToShare,
        ),
      ),
    );
  }

  // ==========================================================
  // RELATED PRODUCTS SKELETON
  // ==========================================================

  Widget _skeletonBar({double? height, double? width}) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: AppTokens.border,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildRelatedSkeleton() {
    return Container(
      width: 170,
      padding: const EdgeInsets.all(AppTokens.s12),
      decoration: BoxDecoration(
        color: AppTokens.surface,
        borderRadius: BorderRadius.circular(AppTokens.radiusLg),
        border: Border.all(color: AppTokens.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _skeletonBar(width: double.infinity),
          ),
          const SizedBox(height: AppTokens.s12),
          _skeletonBar(height: 10, width: 120),
          const SizedBox(height: AppTokens.s8),
          _skeletonBar(height: 10, width: 70),
        ],
      ),
    );
  }

  // ==========================================================
  // DELIVERY STRIP
  // ==========================================================

  Widget _buildDeliveryStrip() {
    return Container(
      padding: const EdgeInsets.all(AppTokens.s12),
      decoration: BoxDecoration(
        color: AppTokens.surface,
        borderRadius: BorderRadius.circular(AppTokens.radiusLg),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.local_shipping_outlined,
            color: AppTokens.textPrimary,
            size: 20,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              "Free delivery on eligible orders · Secure payment · Easy returns",
              style: AppTokens.caption.copyWith(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}