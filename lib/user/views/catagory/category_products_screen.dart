import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shoppee_world/user/core/theme/app_tokens.dart';
import 'package:shoppee_world/user/viewmodel/product/product_provider.dart';
import 'package:shoppee_world/user/widgets/product/product_card.dart';

class CategoryProductsScreen extends ConsumerWidget {
  final int categoryId;
  final String categoryName;

  const CategoryProductsScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsProvider);

    return Scaffold(
      backgroundColor: AppTokens.background,
      appBar: AppBar(
        backgroundColor: AppTokens.background,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        titleSpacing: 0,
        centerTitle: false,
        leading: IconButton(
          tooltip: 'Back',
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: AppTokens.textPrimary,
            size: 22,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          categoryName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTokens.pageTitle,
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(
            height: 1,
            thickness: 1,
            color: AppTokens.border,
          ),
        ),
      ),
      body: productsAsync.when(
        loading: () {
          return const Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: AppTokens.textSecondary,
                strokeWidth: 2,
              ),
            ),
          );
        },
        error: (error, _) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(AppTokens.s24),
              child: Text(
                "Failed to load products\n$error",
                textAlign: TextAlign.center,
                style: AppTokens.caption,
              ),
            ),
          );
        },
        data: (products) {
          // Only show products that belong to the tapped category.
          final categoryProducts = products
              .where((product) => product.categoryId == categoryId)
              .toList();

          if (categoryProducts.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.search_off_rounded,
                    color: AppTokens.textTertiary,
                    size: 40,
                  ),
                  const SizedBox(height: AppTokens.s16),
                  Text(
                    "No products in this category",
                    style: AppTokens.bodyStrong,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Check back soon",
                    style: AppTokens.caption,
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(AppTokens.gutter),
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: AppTokens.s12,
              mainAxisSpacing: AppTokens.s12,
              childAspectRatio: .68,
            ),
            itemCount: categoryProducts.length,
            itemBuilder: (context, index) {
              return ProductCard(
                product: categoryProducts[index],
              );
            },
          );
        },
      ),
    );
  }
}