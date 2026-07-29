import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shoppee_world/widgets/home/home_appbar.dart';
import 'package:shoppee_world/widgets/product/product_card.dart';

import '../../viewmodel/product/product_provider.dart';
import '../../widgets/home/banner_slider.dart';
import '../../widgets/home/category_list.dart';
import '../../widgets/home/search_bar_widget.dart';
import '../../widgets/home/section_title.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get products from Supabase
    final productsAsync = ref.watch(productsProvider);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    const HomeAppBar(),

                    const SizedBox(height: 24),

                    const SearchBarWidget(),

                    const SizedBox(height: 24),

                    const BannerSlider(),

                    const SizedBox(height: 28),

                    SectionTitle(
                      title: "Categories",
                      onSeeAll: () {},
                    ),

                    const SizedBox(height: 16),

                    const CategoryList(),

                    const SizedBox(height: 28),

                    SectionTitle(
                      title: "Popular Products",
                      onSeeAll: () {},
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // ==========================================
            // PRODUCTS FROM SUPABASE
            // ==========================================

            productsAsync.when(
              // Loading
              loading: () {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(40),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                );
              },

              // Error
              error: (error, stack) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        "Failed to load products\n$error",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              },

              // Success
              data: (products) {
                if (products.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(40),
                        child: Text(
                          "No products available",
                        ),
                      ),
                    ),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return ProductCard(
                          product: products[index],
                        );
                      },
                      childCount: products.length,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: .67,
                    ),
                  ),
                );
              },
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 30),
            ),
          ],
        ),
      ),
    );
  }
}