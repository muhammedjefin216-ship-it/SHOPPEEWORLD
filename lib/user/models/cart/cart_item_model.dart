import 'package:shoppee_world/user/models/product/product_model.dart';

class CartItemModel {
  final int? cartItemId;
  final ProductModel product;
  final int quantity;
  final String? selectedSize;
  final String? selectedColor;

  const CartItemModel({
    this.cartItemId,
    required this.product,
    this.quantity = 1,
    this.selectedSize,
    this.selectedColor,
  });

  CartItemModel copyWith({
    int? cartItemId,
    int? quantity,
    String? selectedSize,
    String? selectedColor,
  }) {
    return CartItemModel(
      cartItemId: cartItemId ?? this.cartItemId,
      product: product,
      quantity: quantity ?? this.quantity,
      selectedSize: selectedSize ?? this.selectedSize,
      selectedColor: selectedColor ?? this.selectedColor,
    );
  }

  double get totalPrice {
    return product.price * quantity;
  }
}