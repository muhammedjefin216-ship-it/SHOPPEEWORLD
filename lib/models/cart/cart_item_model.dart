import 'package:shoppee_world/models/product/product_model.dart';

class CartItemModel {
  final ProductModel product;
  final int quantity;
  final String? selectedSize;
  final String? selectedColor;

  const CartItemModel({
    required this.product,
    this.quantity = 1,
    this.selectedSize,
    this.selectedColor,
  });

  // Create a new CartItemModel with updated values
  CartItemModel copyWith({
    int? quantity,
    String? selectedSize,
    String? selectedColor,
  }) {
    return CartItemModel(
      product: product,
      quantity: quantity ?? this.quantity,
      selectedSize:
          selectedSize ?? this.selectedSize,
      selectedColor:
          selectedColor ?? this.selectedColor,
    );
  }

  // Total price for this cart item
  double get totalPrice {
    return product.price * quantity;
  }
}