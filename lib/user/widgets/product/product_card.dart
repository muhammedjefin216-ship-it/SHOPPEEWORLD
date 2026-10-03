// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:shoppee_world/user/models/product/product_model.dart';
// import 'package:shoppee_world/user/viewmodel/wishlist/wishlist_provider.dart';
// import 'package:shoppee_world/user/views/product/product_details_screen.dart';
// import '../common/app_network_image.dart';

// class ProductCard extends ConsumerStatefulWidget {
//   final ProductModel product;

//   const ProductCard({
//     super.key,
//     required this.product,
//   });

//   @override
//   ConsumerState<ProductCard> createState() =>
//       _ProductCardState();
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
//       duration:
//           const Duration(milliseconds: 120),
//       lowerBound: .95,
//       upperBound: 1,
//     );

//     _scaleAnimation =
//         CurvedAnimation(
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
//               builder: (_) =>
//                   ProductDetailsScreen(
//                 product: product,
//               ),
//             ),
//           );
//         },
//         child: Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius:
//                 BorderRadius.circular(22),
//             border: Border.all(
//               color: Colors.grey.shade200,
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black
//                     .withOpacity(.06),
//                 blurRadius: 20,
//                 offset: const Offset(0, 10),
//               ),
//             ],
//           ),
//           child: Column(
//             crossAxisAlignment:
//                 CrossAxisAlignment.start,
//             children: [

//               //------------------------------------------------
//               // IMAGE
//               //------------------------------------------------

//               Expanded(
//                 flex: 6,
//                 child: Stack(
//                   children: [

//                     Positioned.fill(
//                       child: Hero(
//                         tag:
//                             "product-image-${product.id}",
//                         child: ClipRRect(
//                           borderRadius:
//                               const BorderRadius
//                                   .vertical(
//                             top:
//                                 Radius.circular(
//                                     22),
//                           ),
//                           child: AppNetworkImage(
//                             imageUrl:
//                                 product.image,
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                       ),
//                     ),

//                     Positioned(
//   top: 12,
//   right: 12,
//   child: FutureBuilder<bool>(
//     future: ref
//         .read(wishlistNotifierProvider)
//         .isFavorite(product.id),
//     builder: (context, snapshot) {
//       final isFavorite = snapshot.data ?? false;

//       return Container(
//         height: 38,
//         width: 38,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           shape: BoxShape.circle,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(.08),
//               blurRadius: 8,
//             ),
//           ],
//         ),
//        child: IconButton(
//   splashRadius: 22,
//   onPressed: () async {
//     await ref
//         .read(wishlistNotifierProvider)
//         .toggleFavorite(
//           productId: product.id,
//         );

//     setState(() {});
//   },
//   icon: AnimatedSwitcher(
//     duration: const Duration(milliseconds: 250),
//     transitionBuilder: (child, animation) {
//       return ScaleTransition(
//         scale: animation,
//         child: child,
//       );
//     },
//     child: Icon(
//       isFavorite
//           ? Icons.favorite
//           : Icons.favorite_border,
//       key: ValueKey(isFavorite),
//       color: Colors.red,
//       size: 20,
//     ),
//   ),
// ),
//       );
//     },
//   ),
// ),
//                   ],
//                 ),
//               ),

//               //------------------------------------------------
//               // DETAILS
//               //------------------------------------------------

//               Expanded(
//                 flex: 4,
//                 child: Padding(
//                   padding:
//                       const EdgeInsets.all(12),
//                   child: Column(
//                     crossAxisAlignment:
//                         CrossAxisAlignment
//                             .start,
//                     children: [

//                       Text(
//                         product.name,
//                         maxLines: 1,
//                         overflow:
//                             TextOverflow
//                                 .ellipsis,
//                         style:
//                             const TextStyle(
//                           fontWeight:
//                               FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),

//                       const SizedBox(
//                           height: 4),

//                       Text(
//                         product.category,
//                         style: TextStyle(
//                           color: Colors
//                               .grey.shade600,
//                           fontSize: 13,
//                         ),
//                       ),

//                       const Spacer(),

//                       Row(
//                         children: [

//                           Text(
//                             "₹${product.price.toStringAsFixed(0)}",
//                             style:
//                                 const TextStyle(
//                               fontWeight:
//                                   FontWeight
//                                       .bold,
//                               fontSize: 19,
//                             ),
//                           ),

//                           const Spacer(),

//                           const Icon(
//                             Icons.star_rounded,
//                             color: Colors.amber,
//                             size: 18,
//                           ),

//                           const SizedBox(
//                               width: 3),

//                           Text(
//                             product.rating
//                                 .toString(),
//                             style:
//                                 const TextStyle(
//                               fontWeight:
//                                   FontWeight
//                                       .bold,
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
      lowerBound: .95,
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

  void _tapDown(_) {
    _controller.reverse();
  }

  void _tapUp(_) {
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
        onTapCancel: () {
          _controller.forward();
        },
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
            color: const Color(0xff191D1E),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withOpacity(.06)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // IMAGE
              Expanded(
                flex: 6,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(18),
                        ),
                        child: AppNetworkImage(
                          imageUrl: product.image,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // DETAILS
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(11, 9, 11, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        product.category,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 10,
                        ),
                      ),

                      const Spacer(),

                      Row(
                        children: [
                          Text(
                            "₹${product.price.toStringAsFixed(0)}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),

                          const Spacer(),

                          const Icon(
                            Icons.star_rounded,
                            color: Colors.white,
                            size: 15,
                          ),

                          const SizedBox(width: 2),

                          Text(
                            product.rating.toString(),
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
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
