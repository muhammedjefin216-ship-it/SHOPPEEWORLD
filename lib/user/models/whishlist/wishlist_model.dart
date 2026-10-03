class WishlistModel {
  final int id;
  final String userId;
  final int productId;
  final DateTime createdAt;

  const WishlistModel({
    required this.id,
    required this.userId,
    required this.productId,
    required this.createdAt,
  });

  factory WishlistModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return WishlistModel(
      id: json['id'] as int,
      userId: json['user_id'] as String,
      productId: json['product_id'] as int,
      createdAt: DateTime.parse(
        json['created_at'],
      ),
    );
  }
}