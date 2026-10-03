class ProductModel {
  final int id;
  final String name;
  final String image;
  final double price;
  final double rating;
  final int categoryId;

  final double originalPrice;
  final double offerPrice;
  final String description;
  final int stockQuantity;
  final List<String> availableSizes;
  final List<String> availableColors;

  ProductModel({
    
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.rating,
    required this.categoryId,
    required this.originalPrice,
    required this.offerPrice,
    required this.description,
    required this.stockQuantity,
    required this.availableSizes,
    required this.availableColors,
  });

  factory ProductModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      price: (json['price'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      categoryId: json['category_id'],

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