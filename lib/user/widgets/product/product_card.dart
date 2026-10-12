// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:shoppee_world/user/models/product/product_model.dart';
// import 'package:shoppee_world/user/views/product/product_details_screen.dart';
// import '../common/app_network_image.dart';

// class ProductCard extends ConsumerStatefulWidget {
//   final ProductModel product;

//   const ProductCard({super.key, required this.product});

//   @override
//   ConsumerState<ProductCard> createState() => _ProductCardState();
// }

// class _ProductCardState extends ConsumerState<ProductCard>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _scaleAnimation;

//   @override
//   void initState() {
//     super.initState();

//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 120),
//       lowerBound: .95,
//       upperBound: 1,
//     );

//     _scaleAnimation = CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeOut,
//     );

//     _controller.forward();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   void _tapDown(_) {
//     _controller.reverse();
//   }

//   void _tapUp(_) {
//     _controller.forward();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final product = widget.product;

//     return ScaleTransition(
//       scale: _scaleAnimation,
//       child: GestureDetector(
//         onTapDown: _tapDown,
//         onTapUp: _tapUp,
//         onTapCancel: () {
//           _controller.forward();
//         },
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => ProductDetailsScreen(product: product),
//             ),
//           );
//         },
//         child: Container(
//           decoration: BoxDecoration(
//             color: const Color(0xff191D1E),
//             borderRadius: BorderRadius.circular(18),
//             border: Border.all(color: Colors.white.withOpacity(.06)),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // IMAGE
//               Expanded(
//                 flex: 6,
//                 child: Stack(
//                   children: [
//                     Positioned.fill(
//                       child: ClipRRect(
//                         borderRadius: const BorderRadius.vertical(
//                           top: Radius.circular(18),
//                         ),
//                         child: AppNetworkImage(
//                           imageUrl: product.image,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               // DETAILS
//               Expanded(
//                 flex: 4,
//                 child: Padding(
//                   padding: const EdgeInsets.fromLTRB(11, 9, 11, 10),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         product.name,
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.w600,
//                           fontSize: 13,
//                         ),
//                       ),

//                       const SizedBox(height: 4),

//                       Text(
//                         product.category,
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                         style: const TextStyle(
//                           color: Colors.white54,
//                           fontSize: 10,
//                         ),
//                       ),

//                       const Spacer(),

//                       Row(
//                         children: [
//                           Text(
//                             "₹${product.price.toStringAsFixed(0)}",
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.w700,
//                               fontSize: 15,
//                             ),
//                           ),

//                           const Spacer(),

//                           const Icon(
//                             Icons.star_rounded,
//                             color: Colors.white,
//                             size: 15,
//                           ),

//                           const SizedBox(width: 2),

//                           Text(
//                             product.rating.toString(),
//                             style: const TextStyle(
//                               color: Colors.white70,
//                               fontSize: 10,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoppee_world/user/core/theme/app_tokens.dart';
import 'package:shoppee_world/user/models/product/product_model.dart';
import 'package:shoppee_world/user/views/product/product_details_screen.dart';
import '../common/app_network_image.dart';

class ProductCard extends ConsumerStatefulWidget {
  final ProductModel product;

  const ProductCard({super.key, required this.product});

  @override
  ConsumerState<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends ConsumerState<ProductCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.97,
      upperBound: 1,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _tapDown(TapDownDetails details) {
    _controller.reverse();
  }

  void _tapUp(TapUpDetails details) {
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTapDown: _tapDown,
        onTapUp: _tapUp,
        onTapCancel: () => _controller.forward(),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProductDetailsScreen(product: product),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: AppTokens.surface,
            borderRadius: BorderRadius.circular(AppTokens.radiusLg),
            border: Border.all(color: AppTokens.border, width: 1),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // PRODUCT IMAGE
              // Takes whatever height is left after the details block,
              // so the card can never overflow.
              Expanded(
                child: SizedBox(
                  width: double.infinity,
                  child: AppNetworkImage(
                    imageUrl: product.image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // PRODUCT DETAILS (sized by its own content)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppTokens.s12,
                  AppTokens.s12,
                  AppTokens.s12,
                  AppTokens.s12,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // PRODUCT NAME
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTokens.bodyStrong.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                        letterSpacing: -0.1,
                      ),
                    ),

                    const SizedBox(height: 4),

                    // CATEGORY
                    Text(
                      product.category,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTokens.caption,
                    ),

                    const SizedBox(height: AppTokens.s8),

                    // PRICE + RATING
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '₹${product.price.toStringAsFixed(0)}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTokens.bodyStrong.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppTokens.s8),
                        const Icon(
                          Icons.star_rounded,
                          color: AppTokens.accent,
                          size: 16,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          product.rating.toStringAsFixed(1),
                          style: AppTokens.bodyStrong.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}