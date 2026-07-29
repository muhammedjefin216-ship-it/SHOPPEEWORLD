class ProductModel {
  final int id;
  final String name;
  final String image;
  final double price;
  final double rating;
  final String category;
  final bool isFavorite;

  const ProductModel({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.rating,
    required this.category,
    this.isFavorite = false,
  });

  factory ProductModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final categoryData =
        json['categories'] as Map<String, dynamic>?;

    return ProductModel(
      id: json['id'] as int,
      name: json['name'] as String,
      image: json['image'] as String,
      price: (json['price'] as num).toDouble(),
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      category: categoryData?['name'] as String? ?? '',
      isFavorite:
          json['is_favorite'] as bool? ?? false,
    );
  }
}