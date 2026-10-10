
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppee_world/user/core/theme/app_tokens.dart';
import 'package:shoppee_world/user/viewmodel/product/product_provider.dart';
import 'package:shoppee_world/user/widgets/product/product_card.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController =
      TextEditingController();

  static const String _recentSearchesKey = 'recent_searches';

  List<String> recentSearches = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();

    _loadRecentSearches();

    _searchController.addListener(() {
      setState(() {
        searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
  }

  // LOAD RECENT SEARCHES

  Future<void> _loadRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    final searches = prefs.getStringList(_recentSearchesKey) ?? [];

    if (!mounted) return;

    setState(() {
      recentSearches = searches;
    });
  }

  // SAVE SEARCH

  Future<void> _saveSearch(String search) async {
    final value = search.trim();

    if (value.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();

    List<String> searches =
        prefs.getStringList(_recentSearchesKey) ?? [];

    searches.removeWhere(
      (item) => item.toLowerCase() == value.toLowerCase(),
    );

    searches.insert(0, value);

    if (searches.length > 5) {
      searches = searches.take(5).toList();
    }

    await prefs.setStringList(_recentSearchesKey, searches);

    if (!mounted) return;

    setState(() {
      recentSearches = searches;
    });
  }

  // DELETE ONE SEARCH

  Future<void> _deleteSearch(String search) async {
    final prefs = await SharedPreferences.getInstance();

    recentSearches.remove(search);

    await prefs.setStringList(
      _recentSearchesKey,
      recentSearches,
    );

    if (!mounted) return;

    setState(() {});
  }

  // CLEAR ALL SEARCHES

  Future<void> _clearRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_recentSearchesKey);

    if (!mounted) return;

    setState(() {
      recentSearches.clear();
    });
  }

  // SELECT RECENT SEARCH

  void _selectRecentSearch(String search) {
    _searchController.text = search;

    _searchController.selection = TextSelection.fromPosition(
      TextPosition(
        offset: _searchController.text.length,
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productsProvider);

    return Scaffold(
      backgroundColor: AppTokens.background,
      appBar: AppBar(
        backgroundColor: AppTokens.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: AppTokens.gutter,
        title: Text(
          'Search',
          style: AppTokens.headline.copyWith(
            fontSize: 22,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTokens.gutter,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SEARCH FIELD

              Container(
                decoration: BoxDecoration(
                  color: AppTokens.surface,
                  borderRadius: BorderRadius.circular(
                    AppTokens.radiusLg,
                  ),
                  border: Border.all(
                    color: AppTokens.border,
                  ),
                ),
                child: TextField(
                  controller: _searchController,
                  style: AppTokens.bodyStrong,
                  cursorColor: AppTokens.accent,
                  textInputAction: TextInputAction.search,
                  onSubmitted: (value) {
                    _saveSearch(value);
                  },
                  decoration: InputDecoration(
                    hintText: 'Search products or categories',
                    hintStyle: AppTokens.body.copyWith(
                      color: AppTokens.textTertiary,
                    ),
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: AppTokens.accent,
                      size: 23,
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            onPressed: _searchController.clear,
                            tooltip: 'Clear search',
                            icon: const Icon(
                              Icons.close_rounded,
                              color: AppTokens.textSecondary,
                              size: 20,
                            ),
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.transparent,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppTokens.s16,
                      vertical: AppTokens.s16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppTokens.radiusLg,
                      ),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppTokens.radiusLg,
                      ),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppTokens.radiusLg,
                      ),
                      borderSide: const BorderSide(
                        color: AppTokens.accent,
                        width: 1.2,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppTokens.s24),

              // CONTENT

              Expanded(
                child: searchQuery.isEmpty
                    ? _buildRecentSearches()
                    : _buildSearchResults(productsAsync),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // RECENT SEARCHES

  Widget _buildRecentSearches() {
    if (recentSearches.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 76,
              width: 76,
              decoration: BoxDecoration(
                color: AppTokens.surface,
                borderRadius: BorderRadius.circular(
                  AppTokens.radiusSheet,
                ),
                border: Border.all(
                  color: AppTokens.border,
                ),
              ),
              child: const Icon(
                Icons.search_rounded,
                color: AppTokens.accent,
                size: 34,
              ),
            ),
            const SizedBox(height: AppTokens.s16),
            Text(
              'Find something you love',
              style: AppTokens.sectionTitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTokens.s8),
            Text(
              'Search for products and categories.',
              style: AppTokens.body,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // SECTION HEADER

        Row(
          children: [
            Text(
              'Recent Searches',
              style: AppTokens.sectionTitle,
            ),
            const Spacer(),
            TextButton(
              onPressed: _clearRecentSearches,
              style: TextButton.styleFrom(
                foregroundColor: AppTokens.textSecondary,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTokens.s8,
                  vertical: AppTokens.s4,
                ),
              ),
              child: Text(
                'Clear all',
                style: AppTokens.caption.copyWith(
                  color: AppTokens.accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: AppTokens.s8),

        // SEARCH HISTORY

        Expanded(
          child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(
              bottom: AppTokens.s24,
            ),
            itemCount: recentSearches.length,
            separatorBuilder: (_, _) =>
                const SizedBox(height: AppTokens.s8),
            itemBuilder: (context, index) {
              final search = recentSearches[index];

              return Container(
                decoration: BoxDecoration(
                  color: AppTokens.surface,
                  borderRadius: BorderRadius.circular(
                    AppTokens.radiusLg,
                  ),
                  border: Border.all(
                    color: AppTokens.border,
                  ),
                ),
                child: ListTile(
                  onTap: () {
                    _selectRecentSearch(search);
                  },
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppTokens.s16,
                    vertical: AppTokens.s4,
                  ),
                  leading: const Icon(
                    Icons.history_rounded,
                    color: AppTokens.textTertiary,
                    size: 21,
                  ),
                  title: Text(
                    search,
                    style: AppTokens.bodyStrong,
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      _deleteSearch(search);
                    },
                    tooltip: 'Remove search',
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(
                      Icons.close_rounded,
                      color: AppTokens.textTertiary,
                      size: 19,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // SEARCH RESULTS

  Widget _buildSearchResults(AsyncValue productsAsync) {
    return productsAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(
          color: AppTokens.accent,
          strokeWidth: 2.5,
        ),
      ),
      error: (error, stack) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: AppTokens.textTertiary,
              size: 42,
            ),
            const SizedBox(height: AppTokens.s12),
            Text(
              'Something went wrong',
              style: AppTokens.bodyStrong,
            ),
          ],
        ),
      ),
      data: (products) {
        final filteredProducts = products.where((product) {
          return product.name.toLowerCase().contains(searchQuery) ||
              product.category.toLowerCase().contains(searchQuery);
        }).toList();

        if (filteredProducts.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.search_off_rounded,
                  color: AppTokens.textTertiary,
                  size: 48,
                ),
                const SizedBox(height: AppTokens.s16),
                Text(
                  'No products found',
                  style: AppTokens.sectionTitle,
                ),
                const SizedBox(height: AppTokens.s8),
                Text(
                  'Try a different product or category.',
                  style: AppTokens.body,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(
            bottom: AppTokens.s24,
          ),
          itemCount: filteredProducts.length,
          separatorBuilder: (_, _) =>
              const SizedBox(height: AppTokens.s12),
          itemBuilder: (context, index) {
            final product = filteredProducts[index];

            return SizedBox(
              height: 245,
              width: double.infinity,
              child: ProductCard(
                product: product,
              ),
            );
          },
        );
      },
    );
  }
}

