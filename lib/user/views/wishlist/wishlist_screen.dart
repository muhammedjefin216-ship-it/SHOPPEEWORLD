// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'package:shoppee_world/user/viewmodel/wishlist/wishlist_provider.dart';
// import 'package:shoppee_world/user/widgets/product/product_card.dart';

// class WishlistScreen extends ConsumerWidget {
//   const WishlistScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final wishlistAsync =
//         ref.watch(wishlistProvider);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Wishlist"),
//         centerTitle: true,
//       ),

//       body: wishlistAsync.when(
//         loading: () => const Center(
//           child: CircularProgressIndicator(),
//         ),

//         error: (error, stack) => Center(
//           child: Text(error.toString()),
//         ),

//         data: (products) {
//           if (products.isEmpty) {
//             return const Center(
//               child: Column(
//                 mainAxisAlignment:
//                     MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     Icons.favorite_border,
//                     size: 80,
//                     color: Colors.grey,
//                   ),
//                   SizedBox(height: 20),
//                   Text(
//                     "Your wishlist is empty",
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight:
//                           FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }

//           return RefreshIndicator(
//             onRefresh: () async {
//               ref.invalidate(
//                 wishlistProvider,
//               );
//             },
//             child: GridView.builder(
//               padding:
//                   const EdgeInsets.all(20),
//               itemCount: products.length,
//               gridDelegate:
//                   const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 crossAxisSpacing: 16,
//                 mainAxisSpacing: 16,
//                 childAspectRatio: .67,
//               ),
//               itemBuilder: (context, index) {
//                 return ProductCard(
//                   product: products[index],
//                 );
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:shoppee_world/user/viewmodel/wishlist/wishlist_provider.dart';
import 'package:shoppee_world/user/widgets/product/product_card.dart';

class WishlistScreen extends ConsumerWidget {
  const WishlistScreen({super.key});

  static const Color backgroundColor = Color(0xff080C0D);
  static const Color cardColor = Color(0xff191D1E);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlistAsync = ref.watch(wishlistProvider);

    return Scaffold(
      backgroundColor: backgroundColor,

      // ============================================================
      // APP BAR
      // ============================================================

      appBar: AppBar(
        backgroundColor: backgroundColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,

        centerTitle: true,

        title: Text(
          "Wishlist",
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),

        actions: [
          wishlistAsync.when(
            loading: () => const SizedBox(),

            error: (_, _) => const SizedBox(),

            data: (products) {
              if (products.isEmpty) {
                return const SizedBox();
              }

              return Padding(
                padding: const EdgeInsets.only(right: 14),

                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),

                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(.06),
                      ),
                    ),

                    child: Text(
                      "${products.length}",
                      style: GoogleFonts.outfit(
                        color: Colors.white70,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),

      // ============================================================
      // BODY
      // ============================================================

      body: wishlistAsync.when(
        // ==========================================================
        // LOADING
        // ==========================================================

        loading: () {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          );
        },

        // ==========================================================
        // ERROR
        // ==========================================================

        error: (error, stack) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(30),

              child: Column(
                mainAxisSize: MainAxisSize.min,

                children: [
                  Container(
                    height: 70,
                    width: 70,

                    decoration: BoxDecoration(
                      color: cardColor,
                      shape: BoxShape.circle,
                    ),

                    child: const Icon(
                      Icons.error_outline_rounded,
                      color: Colors.white54,
                      size: 32,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Text(
                    "Something went wrong",
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    error.toString(),
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      color: Colors.white38,
                      fontSize: 11,
                    ),
                  ),

                  const SizedBox(height: 18),

                  ElevatedButton(
                    onPressed: () {
                      ref.invalidate(wishlistProvider);
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      elevation: 0,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),

                    child: Text(
                      "Try Again",
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },

        // ==========================================================
        // DATA
        // ==========================================================

        data: (products) {
          // ========================================================
          // EMPTY WISHLIST
          // ========================================================

          if (products.isEmpty) {
            return _buildEmptyWishlist(context);
          }

          // ========================================================
          // PRODUCT GRID
          // ========================================================

          return RefreshIndicator(
            color: Colors.black,
            backgroundColor: Colors.white,

            onRefresh: () async {
              ref.invalidate(wishlistProvider);
            },

            child: GridView.builder(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),

              padding: const EdgeInsets.fromLTRB(
                18,
                8,
                18,
                30,
              ),

              itemCount: products.length,

              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,

                crossAxisSpacing: 14,

                mainAxisSpacing: 16,

                childAspectRatio: .67,
              ),

              itemBuilder: (context, index) {
                return ProductCard(
                  product: products[index],
                );
              },
            ),
          );
        },
      ),
    );
  }

  // ==============================================================
  // EMPTY WISHLIST
  // ==============================================================

  Widget _buildEmptyWishlist(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            // ======================================================
            // HEART ICON
            // ======================================================

            Container(
              height: 105,
              width: 105,

              decoration: BoxDecoration(
                color: cardColor,
                shape: BoxShape.circle,

                border: Border.all(
                  color: Colors.white.withOpacity(.06),
                ),
              ),

              child: const Icon(
                Icons.favorite_border_rounded,
                color: Colors.white54,
                size: 48,
              ),
            ),

            const SizedBox(height: 24),

            // ======================================================
            // TITLE
            // ======================================================

            Text(
              "Your Wishlist is Empty",

              style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 21,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 8),

            // ======================================================
            // DESCRIPTION
            // ======================================================

            Text(
              "Save your favorite products here\nand find them easily later.",

              textAlign: TextAlign.center,

              style: GoogleFonts.outfit(
                color: Colors.white38,
                fontSize: 12,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 25),

            // ======================================================
            // EXPLORE PRODUCTS
            // ======================================================

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

                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                  ),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                ),

                child: Row(
                  mainAxisSize: MainAxisSize.min,

                  children: [
                    Text(
                      "Explore Products",
                      style: GoogleFonts.outfit(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(width: 7),

                    const Icon(
                      Icons.arrow_forward_rounded,
                      size: 17,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}