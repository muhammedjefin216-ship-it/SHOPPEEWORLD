import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:shoppee_world/user/viewmodel/catagory/category_provider.dart';
import 'package:shoppee_world/user/viewmodel/catagory/selected_category_provider.dart';
import 'package:shoppee_world/user/views/catagory/category_products_screen.dart';

class CategoriesScreen extends ConsumerStatefulWidget {
  const CategoriesScreen({super.key});

  @override
  ConsumerState<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends ConsumerState<CategoriesScreen> {
  static const Color backgroundColor = Color(0xff080C0D);
  static const Color cardColor = Color(0xff191D1E);

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

        title: _isSearching
            ? TextField(
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Search categories',
                  hintStyle: TextStyle(color: Colors.white38),
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
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),

        actions: [
          IconButton(
            icon: Icon(
              _isSearching ? Icons.close : Icons.search_rounded,
              color: Colors.white,
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

          const SizedBox(width: 6),
        ],
      ),

      body: categoriesAsync.when(
        loading: () {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        },

        error: (error, _) {
          return Center(
            child: Text(
              'Failed to load categories\n$error',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
            ),
          );
        },

        data: (categories) {
          if (categories.isEmpty) {
            return const Center(
              child: Text(
                'No categories available',
                style: TextStyle(color: Colors.white54),
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
              // CATEGORY CHIPS
              SizedBox(
                height: 48,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  scrollDirection: Axis.horizontal,
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

              const SizedBox(height: 10),

              // CATEGORY LIST
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(18, 4, 18, 24),
                  itemCount: filteredCategories.length,
                  itemBuilder: (context, index) {
                    final category = filteredCategories[index];

                    final isSelected = _selectedChipId == category.id;

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
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : const Color(0xff191D1E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(.05)),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white70,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
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
        height: 88,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? Colors.white.withOpacity(.25)
                : Colors.white.withOpacity(.05),
          ),
        ),
        child: Row(
          children: [
            // CATEGORY ICON
            // CATEGORY IMAGE
            // CATEGORY IMAGE
            Container(
              height: 68,
              width: 68,
              decoration: BoxDecoration(
                color: const Color(0xffE7E7E7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child:
                    category.imageUrl != null && category.imageUrl!.isNotEmpty
                    ? Image.network(
                        category.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          print("CATEGORY IMAGE ERROR: $error");

                          return const Icon(
                            Icons.category_outlined,
                            color: Colors.black87,
                            size: 28,
                          );
                        },
                      )
                    : const Icon(
                        Icons.category_outlined,
                        color: Colors.black87,
                        size: 28,
                      ),
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    _getCategorySubtitle(category.name),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white54, fontSize: 10),
                  ),
                ],
              ),
            ),

            // ARROW
            const Icon(
              Icons.chevron_right_rounded,
              color: Colors.white54,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
