import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

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

  static const Color backgroundColor = Color(0xff080C0D);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsProvider);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 18,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text(
          categoryName,
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: productsAsync.when(
        loading: () {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        },
        error: (error, _) {
          return Center(
            child: Text(
              "Failed to load products\n$error",
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          );
        },
        data: (products) {
          if (products.isEmpty) {
            return Center(
              child: Text(
                "No products available",
                style: GoogleFonts.outfit(
                  color: Colors.white54,
                  fontSize: 15,
                ),
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(18),
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 16,
              childAspectRatio: .68,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              return ProductCard(
                product: products[index],
              );
            },
          );
        },
      ),
    );
  }
}