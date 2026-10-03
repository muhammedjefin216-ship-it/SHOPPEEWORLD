import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shoppee_world/user/viewmodel/catagory/category_provider.dart';
import 'package:shoppee_world/user/viewmodel/catagory/selected_category_provider.dart';
import 'package:shoppee_world/user/viewmodel/product/product_provider.dart';
import 'package:shoppee_world/user/views/catagory/catagory_screen.dart';

import 'package:shoppee_world/user/widgets/home/banner_slider.dart';
import 'package:shoppee_world/user/widgets/home/catagory_item.dart';
import 'package:shoppee_world/user/widgets/home/home_appbar.dart';
import 'package:shoppee_world/user/widgets/home/search_bar_widget.dart';
import 'package:shoppee_world/user/widgets/home/section_title.dart';

import 'package:shoppee_world/user/widgets/product/product_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsProvider);
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      backgroundColor: const Color(0xff080C0D),

      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ==================================================
            // TOP SECTION
            // ==================================================
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 18),

              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // APP BAR
                  const HomeAppBar(),

                  const SizedBox(height: 20),

                  // SEARCH
                  const SearchBarWidget(),

                  const SizedBox(height: 18),

                  // BANNER
                  const BannerSlider(),

                  const SizedBox(height: 22),

                  // ==================================================
                  // CATEGORIES TITLE
                  // ==================================================
SectionTitle(
  title: "Categories",
  onSeeAll: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CategoriesScreen(),
      ),
    );
  },
),

                  const SizedBox(height: 14),

                  // ==================================================
                  // CATEGORIES
                  // ==================================================
                  SizedBox(
                    height: 105,
                    child: categoriesAsync.when(
                      loading: () => const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),

                      error: (error, _) => Center(
                        child: Text(
                          error.toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),

                      data: (categories) {
                        final selectedCategory = ref.watch(
                          selectedCategoryProvider,
                        );

                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            final category = categories[index];

                            return CategoryItem(
  name: category.name,
  imageUrl: category.imageUrl,
  isSelected: selectedCategory == category.id,
  onTap: () {
    ref
        .read(selectedCategoryProvider.notifier)
        .selectCategory(category.id);
  },
);
                          },
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 22),

                  // ==================================================
                  // TRENDING PRODUCTS TITLE
                  // ==================================================
                  SectionTitle(title: "Trending Products", onSeeAll: () {}),

                  const SizedBox(height: 18),
                ]),
              ),
            ),

            // ==========================================================
            // PRODUCTS
            // ==========================================================
            productsAsync.when(
              // ========================================================
              // LOADING
              // ========================================================
              loading: () {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(40),

                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  ),
                );
              },

              // ========================================================
              // ERROR
              // ========================================================
              error: (error, stack) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),

                      child: Text(
                        "Failed to load products\n$error",
                        textAlign: TextAlign.center,

                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                );
              },

              // ========================================================
              // SUCCESS
              // ========================================================
              data: (products) {
  if (products.isEmpty) {
    return const SliverToBoxAdapter(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: Text(
            "No products available",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  // ======================================================
  // VERTICAL PRODUCT LIST
  // ======================================================

  return  SliverPadding(
  padding: const EdgeInsets.symmetric(horizontal: 18),
  sliver: SliverList(
    delegate: SliverChildBuilderDelegate(
      (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: SizedBox(
            height: 245,
            width: double.infinity,
            child: ProductCard(
              product: products[index],
            ),
          ),
        );
      },
      childCount: products.length,
    ),
  ),
);
},
            ),

            // ==========================================================
            // BOTTOM SPACE
            // ==========================================================
            const SliverToBoxAdapter(child: SizedBox(height: 30)),
          ],
        ),
      ),
    );
  }
}
