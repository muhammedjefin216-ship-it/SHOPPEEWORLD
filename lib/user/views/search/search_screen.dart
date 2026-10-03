import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:shoppee_world/user/viewmodel/product/product_provider.dart';
import 'package:shoppee_world/user/widgets/product/product_card.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';

  @override
  void initState() {
    super.initState();

    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.trim().toLowerCase();
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productsProvider);

    return Scaffold(
      backgroundColor: const Color(0xff080C0D),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 20, 18, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 22),
                    _buildSearchBar(),
                    const SizedBox(height: 25),
                  ],
                ),
              ),
            ),

            productsAsync.when(
              loading: () {
                return const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(top: 80),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              },

              error: (error, stack) {
                return SliverToBoxAdapter(
                  child: _buildError(),
                );
              },

              data: (products) {
                final filteredProducts = products.where((product) {
                  if (_searchQuery.isEmpty) {
                    return false;
                  }

                  final productName =
                      product.name.toLowerCase();

                  final category =
                      product.category.toLowerCase();

                  return productName.contains(_searchQuery) ||
                      category.contains(_searchQuery);
                }).toList();

                if (_searchQuery.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: SizedBox(),
                  );
                }

                if (filteredProducts.isEmpty) {
                  return SliverToBoxAdapter(
                    child: _buildNoResults(),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                  ),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return ProductCard(
                          product: filteredProducts[index],
                        );
                      },
                      childCount: filteredProducts.length,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 16,
                      childAspectRatio: .68,
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

  Widget _buildHeader() {
    return Row(
      children: [
        Text(
          "Search",
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),

        const Spacer(),

        Container(
          height: 42,
          width: 42,
          decoration: BoxDecoration(
            color: const Color(0xff191D1E),
            borderRadius: BorderRadius.circular(13),
            border: Border.all(
              color: Colors.white.withOpacity(.06),
            ),
          ),
          child: const Icon(
            Icons.tune_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    final hasText =
        _searchController.text.trim().isNotEmpty;

    return Container(
      height: 54,
      decoration: BoxDecoration(
        color: const Color(0xff191D1E),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: Colors.white.withOpacity(.06),
        ),
      ),
      child: TextField(
        controller: _searchController,
        style: GoogleFonts.outfit(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        cursorColor: Colors.white,
        decoration: InputDecoration(
          border: InputBorder.none,

          hintText:
              "Search products, brands and more...",

          hintStyle: GoogleFonts.outfit(
            color: Colors.white38,
            fontSize: 12,
          ),

          prefixIcon: const Icon(
            Icons.search_rounded,
            color: Colors.white70,
            size: 22,
          ),

          suffixIcon: hasText
              ? IconButton(
                  onPressed: () {
                    _searchController.clear();
                  },
                  icon: const Icon(
                    Icons.close_rounded,
                    color: Colors.white54,
                    size: 19,
                  ),
                )
              : null,

          contentPadding:
              const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  Widget _buildNoResults() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 50,
        left: 18,
        right: 18,
      ),
      child: Column(
        children: [
          Container(
            height: 65,
            width: 65,
            decoration: const BoxDecoration(
              color: Color(0xff191D1E),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.search_off_rounded,
              color: Colors.white38,
              size: 30,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            "No products found",
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            "Try searching with a different keyword",
            style: GoogleFonts.outfit(
              color: Colors.white38,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Padding(
      padding: const EdgeInsets.only(top: 60),
      child: Center(
        child: Column(
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: Colors.white38,
              size: 40,
            ),

            const SizedBox(height: 12),

            Text(
              "Failed to load products",
              style: GoogleFonts.outfit(
                color: Colors.white70,
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 12),

            TextButton(
              onPressed: () {
                ref.invalidate(productsProvider);
              },
              child: Text(
                "Try Again",
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}