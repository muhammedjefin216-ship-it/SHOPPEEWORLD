// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:shoppee_world/user/viewmodel/catagory/category_provider.dart';
// import 'package:shoppee_world/user/viewmodel/catagory/selected_category_provider.dart';
// import 'package:shoppee_world/user/viewmodel/product/product_provider.dart';
// import 'package:shoppee_world/user/views/catagory/catagory_screen.dart';
// import 'package:shoppee_world/user/widgets/home/banner_slider.dart';
// import 'package:shoppee_world/user/widgets/home/catagory_item.dart';
// import 'package:shoppee_world/user/widgets/home/home_appbar.dart';
// import 'package:shoppee_world/user/widgets/home/search_bar_widget.dart';
// import 'package:shoppee_world/user/widgets/home/section_title.dart';

// import 'package:shoppee_world/user/widgets/product/product_card.dart';

// class HomeScreen extends ConsumerStatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   ConsumerState<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends ConsumerState<HomeScreen> {
//   final TextEditingController _searchController =
//       TextEditingController();

//   String _searchQuery = '';

//   String? _selectedSort;
//   double? _selectedRating;
//   String? _selectedSize;
//   String? _selectedColor;

//   @override
//   void initState() {
//     super.initState();

//     _searchController.addListener(_onSearchChanged);
//   }

//   void _onSearchChanged() {
//     setState(() {
//       _searchQuery =
//           _searchController.text.trim().toLowerCase();
//     });
//   }

//   @override
//   void dispose() {
//     _searchController.removeListener(_onSearchChanged);
//     _searchController.dispose();
//     super.dispose();
//   }

//   void _clearFilters() {
//     setState(() {
//       _selectedSort = null;
//       _selectedRating = null;
//       _selectedSize = null;
//       _selectedColor = null;
//     });
//   }

//   Widget _filterChip({
//     required String label,
//     required bool selected,
//     required VoidCallback onTap,
//   }) {
//     return FilterChip(
//       label: Text(label),
//       selected: selected,
//       onSelected: (_) {
//         onTap();
//       },
//       labelStyle: TextStyle(
//         color: selected ? Colors.black : Colors.white,
//         fontSize: 12,
//         fontWeight: FontWeight.w500,
//       ),
//       backgroundColor: const Color(0xff080C0D),
//       selectedColor: Colors.white,
//       checkmarkColor: Colors.black,
//       side: BorderSide.none,
//     );
//   }

//   void _showFilterSheet(BuildContext context) {
//     String? tempSort = _selectedSort;
//     double? tempRating = _selectedRating;
//     String? tempSize = _selectedSize;
//     String? tempColor = _selectedColor;

//     showModalBottomSheet(
//       context: context,
//       backgroundColor: const Color(0xff191D1E),
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(
//           top: Radius.circular(24),
//         ),
//       ),
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setSheetState) {
//             return Padding(
//               padding: const EdgeInsets.all(20),
//               child: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment:
//                           MainAxisAlignment.spaceBetween,
//                       children: [
//                         const Text(
//                           "Filters",
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         TextButton(
//                           onPressed: () {
//                             setSheetState(() {
//                               tempSort = null;
//                               tempRating = null;
//                               tempSize = null;
//                               tempColor = null;
//                             });
//                           },
//                           child: const Text(
//                             "Clear",
//                             style: TextStyle(
//                               color: Colors.white70,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),

//                     const SizedBox(height: 20),

//                     const Text(
//                       "Sort By",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),

//                     const SizedBox(height: 10),

//                     Wrap(
//                       spacing: 8,
//                       runSpacing: 8,
//                       children: [
//                         _filterChip(
//                           label: "Relevance",
//                           selected:
//                               tempSort == "Relevance",
//                           onTap: () {
//                             setSheetState(() {
//                               tempSort =
//                                   tempSort == "Relevance"
//                                       ? null
//                                       : "Relevance";
//                             });
//                           },
//                         ),
//                         _filterChip(
//                           label: "Price Low → High",
//                           selected:
//                               tempSort ==
//                                   "Price Low → High",
//                           onTap: () {
//                             setSheetState(() {
//                               tempSort =
//                                   tempSort ==
//                                           "Price Low → High"
//                                       ? null
//                                       : "Price Low → High";
//                             });
//                           },
//                         ),
//                         _filterChip(
//                           label: "Price High → Low",
//                           selected:
//                               tempSort ==
//                                   "Price High → Low",
//                           onTap: () {
//                             setSheetState(() {
//                               tempSort =
//                                   tempSort ==
//                                           "Price High → Low"
//                                       ? null
//                                       : "Price High → Low";
//                             });
//                           },
//                         ),
//                         _filterChip(
//                           label: "Rating",
//                           selected:
//                               tempSort == "Rating",
//                           onTap: () {
//                             setSheetState(() {
//                               tempSort =
//                                   tempSort == "Rating"
//                                       ? null
//                                       : "Rating";
//                             });
//                           },
//                         ),
//                       ],
//                     ),

//                     const SizedBox(height: 24),

//                     const Text(
//                       "Rating",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),

//                     const SizedBox(height: 10),

//                     Wrap(
//                       spacing: 8,
//                       children: [
//                         _filterChip(
//                           label: "4★ & above",
//                           selected:
//                               tempRating == 4,
//                           onTap: () {
//                             setSheetState(() {
//                               tempRating =
//                                   tempRating == 4
//                                       ? null
//                                       : 4;
//                             });
//                           },
//                         ),
//                         _filterChip(
//                           label: "3★ & above",
//                           selected:
//                               tempRating == 3,
//                           onTap: () {
//                             setSheetState(() {
//                               tempRating =
//                                   tempRating == 3
//                                       ? null
//                                       : 3;
//                             });
//                           },
//                         ),
//                       ],
//                     ),

//                     const SizedBox(height: 24),

//                     const Text(
//                       "Size",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),

//                     const SizedBox(height: 10),

//                     Wrap(
//                       spacing: 8,
//                       runSpacing: 8,
//                       children: [
//                         "S",
//                         "M",
//                         "L",
//                         "XL",
//                         "XXL",
//                       ].map((size) {
//                         return _filterChip(
//                           label: size,
//                           selected:
//                               tempSize == size,
//                           onTap: () {
//                             setSheetState(() {
//                               tempSize =
//                                   tempSize == size
//                                       ? null
//                                       : size;
//                             });
//                           },
//                         );
//                       }).toList(),
//                     ),

//                     const SizedBox(height: 24),

//                     const Text(
//                       "Color",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),

//                     const SizedBox(height: 10),

//                     Wrap(
//                       spacing: 8,
//                       runSpacing: 8,
//                       children: [
//                         "Black",
//                         "White",
//                         "Blue",
//                         "Red",
//                         "Green",
//                       ].map((color) {
//                         return _filterChip(
//                           label: color,
//                           selected:
//                               tempColor == color,
//                           onTap: () {
//                             setSheetState(() {
//                               tempColor =
//                                   tempColor == color
//                                       ? null
//                                       : color;
//                             });
//                           },
//                         );
//                       }).toList(),
//                     ),

//                     const SizedBox(height: 30),

//                     SizedBox(
//                       width: double.infinity,
//                       height: 48,
//                       child: ElevatedButton(
//                         onPressed: () {
//                           setState(() {
//                             _selectedSort = tempSort;
//                             _selectedRating = tempRating;
//                             _selectedSize = tempSize;
//                             _selectedColor = tempColor;
//                           });

//                           Navigator.pop(context);
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.white,
//                           foregroundColor: Colors.black,
//                           shape: RoundedRectangleBorder(
//                             borderRadius:
//                                 BorderRadius.circular(14),
//                           ),
//                         ),
//                         child: const Text(
//                           "Apply Filters",
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),

//                     const SizedBox(height: 10),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final productsAsync = ref.watch(productsProvider);
//     final categoriesAsync = ref.watch(categoriesProvider);
//     final selectedCategory =
//         ref.watch(selectedCategoryProvider);

//     return Scaffold(
//       backgroundColor: const Color(0xff080C0D),
//       body: SafeArea(
//         child: CustomScrollView(
//           physics: const BouncingScrollPhysics(),
//           slivers: [
//             SliverPadding(
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 18),
//               sliver: SliverList(
//                 delegate: SliverChildListDelegate([
//                   const HomeAppBar(),

//                   const SizedBox(height: 20),

//                   SearchBarWidget(
//                     controller: _searchController,
//                     onFilterTap: () {
//                       _showFilterSheet(context);
//                     },
//                   ),

//                   const SizedBox(height: 18),

//                   if (_searchQuery.isEmpty)
//                     const BannerSlider(),

//                   if (_searchQuery.isEmpty)
//                     const SizedBox(height: 22),

//                   if (_searchQuery.isEmpty)
//                     SectionTitle(
//                       title: "Categories",
//                       onSeeAll: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) =>
//                                 const CategoriesScreen(),
//                           ),
//                         );
//                       },
//                     ),

//                   if (_searchQuery.isEmpty)
//                     const SizedBox(height: 14),

//                   if (_searchQuery.isEmpty)
//                     SizedBox(
//                       height: 105,
//                       child: categoriesAsync.when(
//                         loading: () {
//                           return const Center(
//                             child:
//                                 CircularProgressIndicator(
//                               color: Colors.white,
//                             ),
//                           );
//                         },
//                         error: (error, _) {
//                           return Center(
//                             child: Text(
//                               error.toString(),
//                               style: const TextStyle(
//                                 color: Colors.white,
//                               ),
//                             ),
//                           );
//                         },
//                         data: (categories) {
//                           return ListView.builder(
//                             scrollDirection:
//                                 Axis.horizontal,
//                             physics:
//                                 const BouncingScrollPhysics(),
//                             itemCount: categories.length,
//                             itemBuilder:
//                                 (context, index) {
//                               final category =
//                                   categories[index];

//                               return CategoryItem(
//                                 name: category.name,
//                                 imageUrl:
//                                     category.imageUrl,
//                                 isSelected:
//                                     selectedCategory ==
//                                         category.id,
//                                 onTap: () {
//                                   ref
//                                       .read(
//                                         selectedCategoryProvider
//                                             .notifier,
//                                       )
//                                       .selectCategory(
//                                         category.id,
//                                       );

//                                   _searchController.clear();
//                                 },
//                               );
//                             },
//                           );
//                         },
//                       ),
//                     ),

//                   if (_searchQuery.isEmpty)
//                     const SizedBox(height: 22),

//                   SectionTitle(
//                     title: _searchQuery.isNotEmpty
//                         ? "Search Results"
//                         : selectedCategory != null
//                             ? "Category Products"
//                             : "Trending Products",
//                     onSeeAll: () {
//                       _searchController.clear();

//                       ref
//                           .read(
//                             selectedCategoryProvider
//                                 .notifier,
//                           )
//                           .clearCategory();

//                       _clearFilters();
//                     },
//                   ),

//                   const SizedBox(height: 18),
//                 ]),
//               ),
//             ),

//             productsAsync.when(
//               loading: () {
//                 return const SliverToBoxAdapter(
//                   child: Center(
//                     child: Padding(
//                       padding: EdgeInsets.all(40),
//                       child:
//                           CircularProgressIndicator(
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 );
//               },

//               error: (error, stack) {
//                 return SliverToBoxAdapter(
//                   child: Center(
//                     child: Padding(
//                       padding: const EdgeInsets.all(20),
//                       child: Text(
//                         "Failed to load products\n$error",
//                         textAlign: TextAlign.center,
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 12,
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               },

//               data: (products) {
//                 var filteredProducts = products;

//                 // CATEGORY
//                 if (selectedCategory != null) {
//                   filteredProducts = filteredProducts
//                       .where(
//                         (product) =>
//                             product.categoryId ==
//                             selectedCategory,
//                       )
//                       .toList();
//                 }

//                 // SEARCH
//                 if (_searchQuery.isNotEmpty) {
//                   filteredProducts = filteredProducts
//                       .where((product) {
//                     final name =
//                         product.name.toLowerCase();
//                     final category =
//                         product.category.toLowerCase();

//                     return name.contains(_searchQuery) ||
//                         category.contains(_searchQuery);
//                   }).toList();
//                 }

//                 // RATING
//                 if (_selectedRating != null) {
//                   filteredProducts = filteredProducts
//                       .where(
//                         (product) =>
//                             product.rating >=
//                             _selectedRating!,
//                       )
//                       .toList();
//                 }

//                 // SIZE
//                 if (_selectedSize != null) {
//                   filteredProducts = filteredProducts
//                       .where(
//                         (product) => product
//                             .availableSizes
//                             .any(
//                               (size) =>
//                                   size.toLowerCase() ==
//                                   _selectedSize!
//                                       .toLowerCase(),
//                             ),
//                       )
//                       .toList();
//                 }

//                 // COLOR
//                 if (_selectedColor != null) {
//                   filteredProducts = filteredProducts
//                       .where(
//                         (product) => product
//                             .availableColors
//                             .any(
//                               (color) =>
//                                   color.toLowerCase() ==
//                                   _selectedColor!
//                                       .toLowerCase(),
//                             ),
//                       )
//                       .toList();
//                 }

//                 // SORT
//                 if (_selectedSort ==
//                     "Price Low → High") {
//                   filteredProducts.sort(
//                     (a, b) =>
//                         a.price.compareTo(b.price),
//                   );
//                 }

//                 if (_selectedSort ==
//                     "Price High → Low") {
//                   filteredProducts.sort(
//                     (a, b) =>
//                         b.price.compareTo(a.price),
//                   );
//                 }

//                 if (_selectedSort == "Rating") {
//                   filteredProducts.sort(
//                     (a, b) =>
//                         b.rating.compareTo(a.rating),
//                   );
//                 }

//                 if (filteredProducts.isEmpty) {
//                   return const SliverToBoxAdapter(
//                     child: Padding(
//                       padding: EdgeInsets.all(40),
//                       child: Center(
//                         child: Column(
//                           children: [
//                             Icon(
//                               Icons.search_off_rounded,
//                               color: Colors.white38,
//                               size: 45,
//                             ),
//                             SizedBox(height: 12),
//                             Text(
//                               "No products found",
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 14,
//                                 fontWeight:
//                                     FontWeight.w600,
//                               ),
//                             ),
//                             SizedBox(height: 5),
//                             Text(
//                               "Try different filters",
//                               style: TextStyle(
//                                 color: Colors.white38,
//                                 fontSize: 11,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 }

//                 return SliverPadding(
//                   padding:
//                       const EdgeInsets.symmetric(
//                     horizontal: 18,
//                   ),
//                   sliver: SliverList(
//                     delegate:
//                         SliverChildBuilderDelegate(
//                       (context, index) {
//                         return Padding(
//                           padding:
//                               const EdgeInsets.only(
//                             bottom: 16,
//                           ),
//                           child: SizedBox(
//                             height: 245,
//                             width: double.infinity,
//                             child: ProductCard(
//                               product:
//                                   filteredProducts[index],
//                             ),
//                           ),
//                         );
//                       },
//                       childCount:
//                           filteredProducts.length,
//                     ),
//                   ),
//                 );
//               },
//             ),

//             const SliverToBoxAdapter(
//               child: SizedBox(height: 30),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }






import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shoppee_world/user/core/theme/app_tokens.dart';
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

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _searchController =
      TextEditingController();

  String _searchQuery = '';

  String? _selectedSort;
  double? _selectedRating;
  String? _selectedSize;
  String? _selectedColor;

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

  void _clearFilters() {
    setState(() {
      _selectedSort = null;
      _selectedRating = null;
      _selectedSize = null;
      _selectedColor = null;
    });
  }

  Widget _filterChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      labelStyle: AppTokens.caption.copyWith(
        color: selected
            ? AppTokens.onFill
            : AppTokens.textSecondary,
        fontWeight: FontWeight.w500,
      ),
      backgroundColor: AppTokens.background,
      selectedColor: AppTokens.fill,
      checkmarkColor: AppTokens.onFill,
      side: BorderSide(
        color: selected
            ? AppTokens.fill
            : AppTokens.border,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          AppTokens.radiusMd,
        ),
      ),
      showCheckmark: false,
      visualDensity: VisualDensity.compact,
    );
  }

  void _showFilterSheet(BuildContext context) {
    String? tempSort = _selectedSort;
    double? tempRating = _selectedRating;
    String? tempSize = _selectedSize;
    String? tempColor = _selectedColor;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppTokens.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppTokens.radiusSheet),
        ),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            Widget filterHeading(String title) {
              return Text(
                title,
                style: AppTokens.sectionTitle,
              );
            }

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(AppTokens.s20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Filters',
                            style: AppTokens.headline.copyWith(
                              fontSize: 20,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              setSheetState(() {
                                tempSort = null;
                                tempRating = null;
                                tempSize = null;
                                tempColor = null;
                              });
                            },
                            child: Text(
                              'Clear all',
                              style: AppTokens.body,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: AppTokens.s20),

                      filterHeading('Sort by'),
                      const SizedBox(height: AppTokens.s8),
                      Wrap(
                        spacing: AppTokens.s8,
                        runSpacing: AppTokens.s4,
                        children: [
                          'Relevance',
                          'Price Low → High',
                          'Price High → Low',
                          'Rating',
                        ].map((value) {
                          return _filterChip(
                            label: value,
                            selected: tempSort == value,
                            onTap: () {
                              setSheetState(() {
                                tempSort =
                                    tempSort == value ? null : value;
                              });
                            },
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: AppTokens.s20),

                      filterHeading('Rating'),
                      const SizedBox(height: AppTokens.s8),
                      Wrap(
                        spacing: AppTokens.s8,
                        children: [4.0, 3.0].map((rating) {
                          return _filterChip(
                            label: '${rating.toInt()}★ & above',
                            selected: tempRating == rating,
                            onTap: () {
                              setSheetState(() {
                                tempRating =
                                    tempRating == rating
                                        ? null
                                        : rating;
                              });
                            },
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: AppTokens.s20),

                      filterHeading('Size'),
                      const SizedBox(height: AppTokens.s8),
                      Wrap(
                        spacing: AppTokens.s8,
                        runSpacing: AppTokens.s4,
                        children: ['S', 'M', 'L', 'XL', 'XXL']
                            .map((size) {
                          return _filterChip(
                            label: size,
                            selected: tempSize == size,
                            onTap: () {
                              setSheetState(() {
                                tempSize =
                                    tempSize == size ? null : size;
                              });
                            },
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: AppTokens.s20),

                      filterHeading('Color'),
                      const SizedBox(height: AppTokens.s8),
                      Wrap(
                        spacing: AppTokens.s8,
                        runSpacing: AppTokens.s4,
                        children: [
                          'Black',
                          'White',
                          'Blue',
                          'Red',
                          'Green',
                        ].map((color) {
                          return _filterChip(
                            label: color,
                            selected: tempColor == color,
                            onTap: () {
                              setSheetState(() {
                                tempColor =
                                    tempColor == color ? null : color;
                              });
                            },
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: AppTokens.s24),

                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedSort = tempSort;
                              _selectedRating = tempRating;
                              _selectedSize = tempSize;
                              _selectedColor = tempColor;
                            });

                            Navigator.pop(sheetContext);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTokens.accent,
                            foregroundColor: AppTokens.onAccent,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppTokens.radiusButton,
                              ),
                            ),
                          ),
                          child: Text(
                            'Apply filters',
                            style: AppTokens.button.copyWith(
                              color: AppTokens.onAccent,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: AppTokens.s8),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productsProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return Scaffold(
      backgroundColor: AppTokens.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTokens.gutter,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const HomeAppBar(),

                  const SizedBox(height: AppTokens.s20),

                  SearchBarWidget(
                    controller: _searchController,
                    onFilterTap: () {
                      _showFilterSheet(context);
                    },
                  ),

                  const SizedBox(height: AppTokens.s16),

                  if (_searchQuery.isEmpty)
                    const BannerSlider(),

                  if (_searchQuery.isEmpty)
                    const SizedBox(height: AppTokens.s24),

                  if (_searchQuery.isEmpty)
                    SectionTitle(
                      title: 'CATEGORIES',
                      onSeeAll: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CategoriesScreen(),
                          ),
                        );
                      },
                    ),

                  if (_searchQuery.isEmpty)
                    const SizedBox(height: AppTokens.s12),

                  if (_searchQuery.isEmpty)
                    SizedBox(
                      height: 105,
                      child: categoriesAsync.when(
                        loading: () => const Center(
                          child: CircularProgressIndicator(
                            color: AppTokens.accent,
                            strokeWidth: 2,
                          ),
                        ),
                        error: (error, _) => Center(
                          child: Text(
                            'Unable to load categories',
                            style: AppTokens.body,
                          ),
                        ),
                        data: (categories) {
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            itemCount: categories.length,
                            itemBuilder: (context, index) {
                              final category = categories[index];

                              return CategoryItem(
                                name: category.name,
                                imageUrl: category.imageUrl,
                                isSelected:
                                    selectedCategory == category.id,
                                onTap: () {
                                  ref
                                      .read(
                                        selectedCategoryProvider
                                            .notifier,
                                      )
                                      .selectCategory(category.id);

                                  _searchController.clear();
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),

                  if (_searchQuery.isEmpty)
                    const SizedBox(height: AppTokens.s24),

                  SectionTitle(
                    title: _searchQuery.isNotEmpty
                        ? 'Search Results'
                        : selectedCategory != null
                            ? 'CATEGORY PRODUCTS'
                            : 'LATEST PRODUCTS',
                    onSeeAll: () {
                      _searchController.clear();

                      ref
                          .read(selectedCategoryProvider.notifier)
                          .clearCategory();

                      _clearFilters();
                    },
                  ),

                  const SizedBox(height: AppTokens.s16),
                ]),
              ),
            ),

            productsAsync.when(
              loading: () => const SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(AppTokens.s32),
                    child: CircularProgressIndicator(
                      color: AppTokens.accent,
                      strokeWidth: 2,
                    ),
                  ),
                ),
              ),

              error: (error, stack) => SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(AppTokens.s24),
                  child: Center(
                    child: Text(
                      'Failed to load products\n$error',
                      textAlign: TextAlign.center,
                      style: AppTokens.caption.copyWith(
                        color: AppTokens.danger,
                      ),
                    ),
                  ),
                ),
              ),

              data: (products) {
                var filteredProducts = products.toList();

                // Category filter
                if (selectedCategory != null) {
                  filteredProducts = filteredProducts
                      .where(
                        (product) =>
                            product.categoryId == selectedCategory,
                      )
                      .toList();
                }

                // Search filter
                if (_searchQuery.isNotEmpty) {
                  filteredProducts = filteredProducts.where((product) {
                    final name = product.name.toLowerCase();
                    final category = product.category.toLowerCase();

                    return name.contains(_searchQuery) ||
                        category.contains(_searchQuery);
                  }).toList();
                }

                // Rating filter
                if (_selectedRating != null) {
                  filteredProducts = filteredProducts
                      .where(
                        (product) =>
                            product.rating >= _selectedRating!,
                      )
                      .toList();
                }

                // Size filter
                if (_selectedSize != null) {
                  filteredProducts = filteredProducts
                      .where(
                        (product) => product.availableSizes.any(
                          (size) =>
                              size.toLowerCase() ==
                              _selectedSize!.toLowerCase(),
                        ),
                      )
                      .toList();
                }

                // Color filter
                if (_selectedColor != null) {
                  filteredProducts = filteredProducts
                      .where(
                        (product) => product.availableColors.any(
                          (color) =>
                              color.toLowerCase() ==
                              _selectedColor!.toLowerCase(),
                        ),
                      )
                      .toList();
                }

                // Sorting
                if (_selectedSort == 'Price Low → High') {
                  filteredProducts.sort(
                    (a, b) => a.price.compareTo(b.price),
                  );
                } else if (_selectedSort == 'Price High → Low') {
                  filteredProducts.sort(
                    (a, b) => b.price.compareTo(a.price),
                  );
                } else if (_selectedSort == 'Rating') {
                  filteredProducts.sort(
                    (a, b) => b.rating.compareTo(a.rating),
                  );
                }

                if (filteredProducts.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(AppTokens.s32),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.search_off_rounded,
                            color: AppTokens.textTertiary,
                            size: 40,
                          ),
                          const SizedBox(height: AppTokens.s12),
                          Text(
                            'No products found',
                            style: AppTokens.sectionTitle,
                          ),
                          const SizedBox(height: AppTokens.s4),
                          Text(
                            'Try different filters',
                            style: AppTokens.caption,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTokens.gutter,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                            bottom: AppTokens.s16,
                          ),
                           child: SizedBox(
  height: 320,
  width: double.infinity,
  child: ProductCard(
    product: filteredProducts[index],
  ),
),
                        );
                      },
                      childCount: filteredProducts.length,
                    ),
                  ),
                );
              },
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: AppTokens.s32),
            ),
          ],
        ),
      ),
    );
  }
}


