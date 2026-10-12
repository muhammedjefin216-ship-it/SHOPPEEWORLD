import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shoppee_world/admin/models/product/product_model.dart';
import 'package:shoppee_world/user/core/theme/app_tokens.dart';

class MyReviewsScreen extends StatefulWidget {
  final List<ProductModel> products;

  const MyReviewsScreen({
    super.key,
    this.products = const [],
  });

  @override
  State<MyReviewsScreen> createState() => _MyReviewsScreenState();
}

class _MyReviewsScreenState extends State<MyReviewsScreen> {
  static const String _boxName = 'product_reviews';

  Box<dynamic>? _reviewBox;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _openReviews();
  }

  Future<void> _openReviews() async {
    try {
      _reviewBox = await Hive.openBox<dynamic>(_boxName);
    } catch (e) {
      debugPrint('Unable to open reviews: $e');
    }

    if (mounted) {
      setState(() => _loading = false);
    }
  }

  List<Map<String, dynamic>> get _reviews {
    final box = _reviewBox;
    if (box == null) return [];

    final reviews = <Map<String, dynamic>>[];

    for (final key in box.keys) {
      final value = box.get(key);

      if (value is Map) {
        reviews.add({
          ...Map<String, dynamic>.from(value),
          'reviewKey': key,
        });
      }
    }

    reviews.sort((a, b) {
      final dateA = DateTime.tryParse(
            a['date']?.toString() ?? '',
          ) ??
          DateTime(2000);

      final dateB = DateTime.tryParse(
            b['date']?.toString() ?? '',
          ) ??
          DateTime(2000);

      return dateB.compareTo(dateA);
    });

    return reviews;
  }

  double get _averageRating {
    if (_reviews.isEmpty) return 0;

    final total = _reviews.fold<double>(
      0,
      (sum, review) =>
          sum + ((review['rating'] as num?)?.toDouble() ?? 0),
    );

    return total / _reviews.length;
  }

  Future<void> _showReviewForm({
    Map<String, dynamic>? existingReview,
  }) async {
    if (_reviewBox == null) return;

    final isEditing = existingReview != null;

    ProductModel? selectedProduct;

    if (isEditing) {
      final productId = existingReview['productId'];
      for (final product in widget.products) {
        if (product.id.toString() == productId.toString()) {
          selectedProduct = product;
          break;
        }
      }
    }

    final productController = TextEditingController(
      text: existingReview?['productName']?.toString() ?? '',
    );

    final commentController = TextEditingController(
      text: existingReview?['comment']?.toString() ?? '',
    );

    double rating =
        (existingReview?['rating'] as num?)?.toDouble() ?? 5;

    final formKey = GlobalKey<FormState>();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTokens.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                AppTokens.gutter,
                24,
                AppTokens.gutter,
                MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 42,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppTokens.borderStrong,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        isEditing ? 'Edit Review' : 'Write a Review',
                        style: AppTokens.headline,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Share your experience with the product.',
                        style: AppTokens.body.copyWith(
                          color: AppTokens.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 24),

                      if (!isEditing && widget.products.isNotEmpty) ...[
                        Text(
                          'Select product',
                          style: AppTokens.bodyStrong,
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<ProductModel>(
                          initialValue: selectedProduct,
                          isExpanded: true,
                          dropdownColor: AppTokens.surface,
                          style: AppTokens.body,
                          decoration: _inputDecoration('Choose a product'),
                          items: widget.products.map((product) {
                            return DropdownMenuItem<ProductModel>(
                              value: product,
                              child: Text(
                                product.name,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                          onChanged: (product) {
                            setSheetState(() {
                              selectedProduct = product;
                              productController.text =
                                  product?.name ?? '';
                            });
                          },
                          validator: (_) {
                            if (selectedProduct == null) {
                              return 'Please select a product';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                      ] else ...[
                        Text(
                          'Product',
                          style: AppTokens.bodyStrong,
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: productController,
                          readOnly: isEditing,
                          style: AppTokens.body,
                          decoration: _inputDecoration('Product name'),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Enter a product name';
                            }
                            return null;
                          },
                        ),
                        if (!isEditing) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Pass your product list to this screen to select products.',
                            style: AppTokens.caption.copyWith(
                              color: AppTokens.textSecondary,
                            ),
                          ),
                        ],
                        const SizedBox(height: 20),
                      ],

                      Text(
                        'Your rating',
                        style: AppTokens.bodyStrong,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: List.generate(5, (index) {
                          final star = index + 1;
                          return IconButton(
                            onPressed: () {
                              setSheetState(() => rating = star.toDouble());
                            },
                            icon: Icon(
                              star <= rating
                                  ? Icons.star_rounded
                                  : Icons.star_outline_rounded,
                              color: AppTokens.accent,
                              size: 34,
                            ),
                          );
                        }),
                      ),
                      Text(
                        '${rating.toStringAsFixed(0)} out of 5 stars',
                        style: AppTokens.caption.copyWith(
                          color: AppTokens.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 20),

                      Text(
                        'Your review',
                        style: AppTokens.bodyStrong,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: commentController,
                        maxLines: 4,
                        maxLength: 500,
                        style: AppTokens.body,
                        decoration: _inputDecoration(
                          'What did you like or dislike?',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please write a short review';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
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
                          onPressed: () async {
                            if (!formKey.currentState!.validate()) {
                              return;
                            }

                            final productId =
                                selectedProduct?.id ??
                                existingReview?['productId'] ??
                                'manual_${DateTime.now().millisecondsSinceEpoch}';

                            final oldKey =
                                existingReview?['reviewKey'];

                            final review = <String, dynamic>{
                              'productId': productId,
                              'productName': selectedProduct?.name ??
                                  productController.text.trim(),
                              'image': selectedProduct?.image ??
                                  existingReview?['image'] ??
                                  '',
                              'rating': rating,
                              'comment': commentController.text.trim(),
                              'date': DateTime.now().toIso8601String(),
                            };

                            if (isEditing && oldKey != null) {
                              await _reviewBox!.put(oldKey, review);
                            } else {
                              await _reviewBox!.add(review);
                            }

                            if (!mounted) return;

                            Navigator.pop(sheetContext);
                            setState(() {});

                            ScaffoldMessenger.of(this.context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isEditing
                                      ? 'Review updated successfully'
                                      : 'Review added successfully',
                                ),
                                backgroundColor: AppTokens.surface,
                              ),
                            );
                          },
                          child: Text(
                            isEditing ? 'Save Changes' : 'Submit Review',
                            style: AppTokens.button,
                          ),
                        ),
                      ),
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

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTokens.body.copyWith(
        color: AppTokens.textTertiary,
      ),
      filled: true,
      fillColor: AppTokens.background,
      contentPadding: const EdgeInsets.all(16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppTokens.radiusLg),
        borderSide: BorderSide(color: AppTokens.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppTokens.radiusLg),
        borderSide: BorderSide(color: AppTokens.accent),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppTokens.radiusLg),
        borderSide: BorderSide(color: AppTokens.danger),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppTokens.radiusLg),
        borderSide: BorderSide(color: AppTokens.danger),
      ),
    );
  }

  Future<void> _deleteReview(dynamic key) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppTokens.surface,
          title: Text(
            'Delete review?',
            style: AppTokens.sectionTitle,
          ),
          content: Text(
            'This review will be removed from this device.',
            style: AppTokens.body.copyWith(
              color: AppTokens.textSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                'Cancel',
                style: AppTokens.body.copyWith(
                  color: AppTokens.textSecondary,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(
                'Delete',
                style: AppTokens.bodyStrong.copyWith(
                  color: AppTokens.danger,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed == true && _reviewBox != null) {
      await _reviewBox!.delete(key);

      if (mounted) {
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Review deleted')),
        );
      }
    }
  }

  Widget _buildStars(double rating, {double size = 17}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating
              ? Icons.star_rounded
              : Icons.star_outline_rounded,
          color: AppTokens.accent,
          size: size,
        );
      }),
    );
  }

  Widget _buildSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTokens.surface,
        border: Border.all(color: AppTokens.border),
        borderRadius: BorderRadius.circular(AppTokens.radiusLg),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'REVIEWS WRITTEN',
                  style: AppTokens.overline.copyWith(
                    color: AppTokens.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${_reviews.length}',
                  style: AppTokens.headline.copyWith(fontSize: 30),
                ),
              ],
            ),
          ),
          Container(
            width: 1,
            height: 54,
            color: AppTokens.border,
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AVERAGE RATING',
                  style: AppTokens.overline.copyWith(
                    color: AppTokens.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      _averageRating.toStringAsFixed(1),
                      style: AppTokens.headline.copyWith(fontSize: 30),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      Icons.star_rounded,
                      color: AppTokens.accent,
                      size: 24,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review) {
    final rating =
        (review['rating'] as num?)?.toDouble() ?? 0;

    final date = DateTime.tryParse(
      review['date']?.toString() ?? '',
    );

    final formattedDate = date == null
        ? ''
        : '${date.day.toString().padLeft(2, '0')}/'
            '${date.month.toString().padLeft(2, '0')}/'
            '${date.year}';

    final image = review['image']?.toString() ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTokens.surface,
        border: Border.all(color: AppTokens.border),
        borderRadius: BorderRadius.circular(AppTokens.radiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppTokens.radiusMd),
                child: Container(
                  width: 76,
                  height: 82,
                  color: AppTokens.background,
                  child: image.isEmpty
                      ? Icon(
                          Icons.shopping_bag_outlined,
                          color: AppTokens.textTertiary,
                          size: 30,
                        )
                      : Image.network(
                          image,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Icon(
                            Icons.image_not_supported_outlined,
                            color: AppTokens.textTertiary,
                            size: 28,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review['productName']?.toString() ??
                          'Product',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTokens.bodyStrong,
                    ),
                    const SizedBox(height: 8),
                    _buildStars(rating),
                    const SizedBox(height: 6),
                    Text(
                      formattedDate,
                      style: AppTokens.caption.copyWith(
                        color: AppTokens.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                color: AppTokens.surface,
                icon: Icon(
                  Icons.more_horiz,
                  color: AppTokens.textSecondary,
                ),
                onSelected: (value) {
                  if (value == 'edit') {
                    _showReviewForm(existingReview: review);
                  } else if (value == 'delete') {
                    _deleteReview(review['reviewKey']);
                  }
                },
                itemBuilder: (_) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Text('Edit review'),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Text(
                      'Delete review',
                      style: TextStyle(color: AppTokens.danger),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            review['comment']?.toString() ?? '',
            style: AppTokens.body.copyWith(
              color: AppTokens.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: AppTokens.surface,
              border: Border.all(color: AppTokens.border),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.rate_review_outlined,
              color: AppTokens.accent,
              size: 38,
            ),
          ),
          const SizedBox(height: 22),
          Text(
            'No reviews yet',
            style: AppTokens.sectionTitle,
          ),
          const SizedBox(height: 8),
          Text(
            'Your product reviews will appear here.',
            textAlign: TextAlign.center,
            style: AppTokens.body.copyWith(
              color: AppTokens.textSecondary,
            ),
          ),
          if (widget.products.isNotEmpty) ...[
            const SizedBox(height: 22),
            OutlinedButton.icon(
              onPressed: () => _showReviewForm(),
              icon: const Icon(Icons.add),
              label: const Text('Write your first review'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTokens.accent,
                side: BorderSide(color: AppTokens.accent),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTokens.background,
      appBar: AppBar(
        backgroundColor: AppTokens.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_rounded,
            color: AppTokens.textPrimary,
          ),
        ),
        title: Text(
          'My Reviews',
          style: AppTokens.pageTitle,
        ),
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(
                color: AppTokens.accent,
              ),
            )
          : _reviewBox == null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      'Unable to load reviews. Please try again.',
                      style: AppTokens.body.copyWith(
                        color: AppTokens.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : ValueListenableBuilder(
                  valueListenable: _reviewBox!.listenable(),
                  builder: (context, Box<dynamic> box, _) {
                    final reviews = _reviews;

                    return ListView(
                      padding: const EdgeInsets.all(
                        AppTokens.gutter,
                      ),
                      children: [
                        _buildSummary(),
                        const SizedBox(height: 28),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Your reviews',
                                style: AppTokens.sectionTitle,
                              ),
                            ),
                            if (reviews.isNotEmpty &&
                                widget.products.isNotEmpty)
                              TextButton.icon(
                                onPressed: () => _showReviewForm(),
                                icon: Icon(
                                  Icons.add,
                                  color: AppTokens.accent,
                                ),
                                label: Text(
                                  'Write review',
                                  style: AppTokens.bodyStrong.copyWith(
                                    color: AppTokens.accent,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        if (reviews.isEmpty)
                          _buildEmptyState()
                        else
                          ...reviews.map(_buildReviewCard),
                      ],
                    );
                  },
                ),
    );
  }
}
