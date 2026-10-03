class ProductModel {
  final int id;
  final String name;
  final String image;
  final double price;
  final double rating;
  final int categoryId;
  final String category;
  final bool isFavorite;

  final double originalPrice;
  final double offerPrice;
  final String description;
  final int stockQuantity;
  final List<String> availableSizes;
  final List<String> availableColors;

  const ProductModel({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.rating,
    required this.categoryId,
    required this.category,
    this.isFavorite = false,

    // New fields
    this.originalPrice = 0,
    this.offerPrice = 0,
    this.description = '',
    this.stockQuantity = 0,
    this.availableSizes = const [],
    this.availableColors = const [],
  });

  factory ProductModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final categoryData =
        json['categories'] as Map<String, dynamic>?;

    return ProductModel(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      price: (json['price'] as num?)?.toDouble() ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      categoryId: json['category_id'],
      category: categoryData?['name'] ?? '',
      isFavorite: json['is_favorite'] ?? false,

      // New fields
      originalPrice:
          (json['original_price'] as num?)?.toDouble() ?? 0,

      offerPrice:
          (json['offer_price'] as num?)?.toDouble() ?? 0,

      description:
          json['description']?.toString() ?? '',

      stockQuantity:
          (json['stock_quantity'] as num?)?.toInt() ?? 0,

      availableSizes:
          List<String>.from(
        json['available_sizes'] ?? [],
      ),

      availableColors:
          List<String>.from(
        json['available_colors'] ?? [],
      ),
    );
  }
}