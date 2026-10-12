import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shoppee_world/user/core/theme/app_tokens.dart';
import 'package:shoppee_world/user/viewmodel/catagory/category_provider.dart';
import 'package:shoppee_world/user/viewmodel/catagory/selected_category_provider.dart';
import 'package:shoppee_world/user/views/catagory/category_products_screen.dart';

class CategoriesScreen extends ConsumerStatefulWidget {
  const CategoriesScreen({super.key});

  @override
  ConsumerState<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends ConsumerState<CategoriesScreen> {
  // Neutral tile behind category images (many product images have
  // light backgrounds).
  static const Color _imageTileColor = Color(0xffECE8E1);
  static const Color _imageTileIconColor = Color(0xff6B7377);

  int? _selectedChipId;
  bool _isSearching = false;
  String _searchText = '';

  IconData _getCategoryIcon(String name) {
    switch (name.toLowerCase()) {
      case 'electronics':
      case 'gadgets':
        return Icons.devices_outlined;

      case 'fashion':
      case 'shirt':
      case 'clothing':
        return Icons.checkroom_outlined;

      case 'home':
      case 'home & living':
        return Icons.weekend_outlined;

      case 'beauty':
      case 'beauty & personal care':
        return Icons.face_retouching_natural_outlined;

      case 'sports':
      case 'sports & fitness':
        return Icons.sports_soccer_outlined;

      case 'toys':
      case 'toys & games':
        return Icons.toys_outlined;

      case 'books':
      case 'books & stationery':
        return Icons.menu_book_outlined;

      case 'shoes':
        return Icons.shopping_bag_outlined;

      case 'watches':
        return Icons.watch_outlined;

      case 'shades':
        return Icons.wb_sunny_outlined;

      default:
        return Icons.category_outlined;
    }
  }

  String _getCategorySubtitle(String name) {
    switch (name.toLowerCase()) {
      case 'electronics':
      case 'gadgets':
        return 'Phones, gadgets, accessories';

      case 'fashion':
      case 'clothing':
      case 'shirt':
        return 'Men, Women, Kids';

      case 'home':
      case 'home & living':
        return 'Furniture, Decor, Kitchen';

      case 'beauty':
      case 'beauty & personal care':
        return 'Skincare, Makeup, Haircare';

      case 'sports':
      case 'sports & fitness':
        return 'Equipment, Outdoor';

      case 'toys':
      case 'toys & games':
        return 'Kids, Educational';

      case 'books':
      case 'books & stationery':
        return 'Books, Notebooks, Office';

      default:
        return 'Explore products';
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesProvider);

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

        title: _isSearching
            ? TextField(
                autofocus: true,
                cursorColor: AppTokens.accent,
                style: AppTokens.bodyStrong,
                decoration: InputDecoration(
                  hintText: 'Search categories',
                  hintStyle: AppTokens.body.copyWith(
                    color: AppTokens.textTertiary,
                  ),
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {
                    _searchText = value.toLowerCase();
                  });
                },
              )
            : Text(
                'Categories',
                style: AppTokens.pageTitle,
              ),

        actions: [
          IconButton(
            tooltip: _isSearching ? 'Close search' : 'Search',
            icon: Icon(
              _isSearching ? Icons.close_rounded : Icons.search_rounded,
              color: AppTokens.textPrimary,
              size: 22,
            ),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;

                if (!_isSearching) {
                  _searchText = '';
                }
              });
            },
          ),

          const SizedBox(width: 4),
        ],

        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(
            height: 1,
            thickness: 1,
            color: AppTokens.border,
          ),
        ),
      ),

      body: categoriesAsync.when(
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
                'Failed to load categories\n$error',
                textAlign: TextAlign.center,
                style: AppTokens.caption,
              ),
            ),
          );
        },

        data: (categories) {
          if (categories.isEmpty) {
            return Center(
              child: Text(
                'No categories available',
                style: AppTokens.caption,
              ),
            );
          }

          final filteredCategories = categories.where((category) {
            final matchesSearch = category.name.toLowerCase().contains(
              _searchText,
            );

            final matchesChip =
                _selectedChipId == null || category.id == _selectedChipId;

            return matchesSearch && matchesChip;
          }).toList();

          return Column(
            children: [
              const SizedBox(height: AppTokens.s8),

              // CATEGORY CHIPS
              SizedBox(
                height: 48,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTokens.gutter,
                  ),
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: categories.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      final isSelected = _selectedChipId == null;

                      return _buildChip(
                        title: 'All',
                        isSelected: isSelected,
                        onTap: () {
                          setState(() {
                            _selectedChipId = null;
                          });
                        },
                      );
                    }

                    final category = categories[index - 1];

                    final isSelected = _selectedChipId == category.id;

                    return _buildChip(
                      title: category.name,
                      isSelected: isSelected,
                      onTap: () {
                        setState(() {
                          _selectedChipId = category.id;
                        });
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: AppTokens.s8),

              // CATEGORY LIST
              Expanded(
                child: filteredCategories.isEmpty
                    ? Center(
                        child: Text(
                          'No matching categories',
                          style: AppTokens.caption,
                        ),
                      )
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(
                          AppTokens.gutter,
                          AppTokens.s4,
                          AppTokens.gutter,
                          AppTokens.s24,
                        ),
                        itemCount: filteredCategories.length,
                        itemBuilder: (context, index) {
                          final category = filteredCategories[index];

                          final isSelected =
                              _selectedChipId == category.id;

                          return _buildCategoryCard(
                            context: context,
                            category: category,
                            isSelected: isSelected,
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildChip({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(
          right: AppTokens.s8,
          top: 6,
          bottom: 6,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppTokens.fill : AppTokens.background,
          borderRadius: BorderRadius.circular(AppTokens.radiusMd),
          border: Border.all(
            color: isSelected ? AppTokens.fill : AppTokens.border,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: AppTokens.bodyStrong.copyWith(
            fontSize: 13,
            color: isSelected ? AppTokens.onFill : AppTokens.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard({
    required BuildContext context,
    required dynamic category,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        ref.read(selectedCategoryProvider.notifier).selectCategory(category.id);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CategoryProductsScreen(
              categoryId: category.id,
              categoryName: category.name,
            ),
          ),
        );
      },
      child: Container(
        height: 84,
        margin: const EdgeInsets.only(bottom: AppTokens.s12),
        padding: const EdgeInsets.all(AppTokens.s8),
        decoration: BoxDecoration(
          color: AppTokens.surface,
          borderRadius: BorderRadius.circular(AppTokens.radiusLg),
          border: Border.all(
            color: isSelected ? AppTokens.accent : AppTokens.border,
          ),
        ),
        child: Row(
          children: [
            // CATEGORY IMAGE
            Container(
              height: 68,
              width: 68,
              decoration: BoxDecoration(
                color: _imageTileColor,
                borderRadius: BorderRadius.circular(AppTokens.radiusMd),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppTokens.radiusMd),
                child:
                    category.imageUrl != null && category.imageUrl!.isNotEmpty
                    ? Image.network(
                        category.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.category_outlined,
                            color: _imageTileIconColor,
                            size: 28,
                          );
                        },
                      )
                    : const Icon(
                        Icons.category_outlined,
                        color: _imageTileIconColor,
                        size: 28,
                      ),
              ),
            ),

            const SizedBox(width: AppTokens.s12),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTokens.bodyStrong.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    _getCategorySubtitle(category.name),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTokens.caption,
                  ),
                ],
              ),
            ),

            // ARROW
            const Icon(
              Icons.chevron_right_rounded,
              color: AppTokens.textTertiary,
              size: 22,
            ),

            const SizedBox(width: 4),
          ],
        ),
      ),
    );
  }
}