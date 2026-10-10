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
import 'package:shoppee_world/user/core/theme/app_tokens.dart';
import 'package:shoppee_world/user/viewmodel/wishlist/wishlist_provider.dart';
import 'package:shoppee_world/user/widgets/product/product_card.dart';

class WishlistScreen extends ConsumerWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlistAsync = ref.watch(wishlistProvider);

    return Scaffold(
      backgroundColor: AppTokens.background,

      // APP BAR

      appBar: AppBar(
        backgroundColor: AppTokens.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          'Wishlist',
          style: AppTokens.headline.copyWith(
            fontSize: 21,
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
                padding: const EdgeInsets.only(
                  right: AppTokens.gutter,
                ),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTokens.s12,
                      vertical: AppTokens.s8,
                    ),
                    decoration: BoxDecoration(
                      color: AppTokens.surface,
                      borderRadius: BorderRadius.circular(
                        AppTokens.radiusLg,
                      ),
                      border: Border.all(
                        color: AppTokens.border,
                      ),
                    ),
                    child: Text(
                      '${products.length} ${products.length == 1 ? 'item' : 'items'}',
                      style: AppTokens.caption.copyWith(
                        color: AppTokens.accent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),

      // BODY

      body: wishlistAsync.when(
        // LOADING

        loading: () {
          return const Center(
            child: CircularProgressIndicator(
              color: AppTokens.accent,
              strokeWidth: 2.5,
            ),
          );
        },

        // ERROR

        error: (error, stack) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(AppTokens.s24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 76,
                    width: 76,
                    decoration: BoxDecoration(
                      color: AppTokens.surface,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppTokens.border,
                      ),
                    ),
                    child: const Icon(
                      Icons.error_outline_rounded,
                      color: AppTokens.accent,
                      size: 34,
                    ),
                  ),

                  const SizedBox(height: AppTokens.s20),

                  Text(
                    'Something went wrong',
                    textAlign: TextAlign.center,
                    style: AppTokens.sectionTitle,
                  ),

                  const SizedBox(height: AppTokens.s8),

                  Text(
                    error.toString(),
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: AppTokens.caption.copyWith(
                      color: AppTokens.textTertiary,
                    ),
                  ),

                  const SizedBox(height: AppTokens.s24),

                  ElevatedButton(
                    onPressed: () {
                      ref.invalidate(wishlistProvider);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTokens.accent,
                      foregroundColor: AppTokens.onAccent,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTokens.s24,
                        vertical: AppTokens.s12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppTokens.radiusButton,
                        ),
                      ),
                    ),
                    child: Text(
                      'Try Again',
                      style: AppTokens.button.copyWith(
                        color: AppTokens.onAccent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },

        // DATA

        data: (products) {
          if (products.isEmpty) {
            return _buildEmptyWishlist(context);
          }

          return RefreshIndicator(
            color: AppTokens.onAccent,
            backgroundColor: AppTokens.accent,
            onRefresh: () async {
              ref.invalidate(wishlistProvider);
            },
            child: GridView.builder(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: const EdgeInsets.fromLTRB(
                AppTokens.gutter,
                AppTokens.s8,
                AppTokens.gutter,
                AppTokens.s32,
              ),
              itemCount: products.length,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: AppTokens.s12,
                mainAxisSpacing: AppTokens.s16,
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

  // EMPTY WISHLIST

  Widget _buildEmptyWishlist(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTokens.s24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // HEART ICON

            Container(
              height: 112,
              width: 112,
              decoration: BoxDecoration(
                color: AppTokens.surface,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTokens.border,
                ),
              ),
              child: const Icon(
                Icons.favorite_border_rounded,
                color: AppTokens.accent,
                size: 48,
              ),
            ),

            const SizedBox(height: AppTokens.s24),

            // TITLE

            Text(
              'Your Wishlist is Empty',
              textAlign: TextAlign.center,
              style: AppTokens.headline.copyWith(
                fontSize: 22,
              ),
            ),

            const SizedBox(height: AppTokens.s12),

            // DESCRIPTION

            Text(
              'Save your favorite products here\nand find them easily later.',
              textAlign: TextAlign.center,
              style: AppTokens.body.copyWith(
                color: AppTokens.textSecondary,
              ),
            ),

            const SizedBox(height: AppTokens.s24),

            // EXPLORE PRODUCTS

            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTokens.accent,
                  foregroundColor: AppTokens.onAccent,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTokens.s24,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      AppTokens.radiusButton,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Explore Products',
                      style: AppTokens.button.copyWith(
                        color: AppTokens.onAccent,
                      ),
                    ),
                    const SizedBox(width: AppTokens.s8),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      size: 18,
                      color: AppTokens.onAccent,
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

