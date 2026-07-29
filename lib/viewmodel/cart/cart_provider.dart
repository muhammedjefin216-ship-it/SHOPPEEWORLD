import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoppee_world/models/cart/cart_item_model.dart';
import 'package:shoppee_world/models/product/product_model.dart';

final cartProvider =
    NotifierProvider<CartNotifier, List<CartItemModel>>(
  CartNotifier.new,
);

class CartNotifier extends Notifier<List<CartItemModel>> {
  @override
  List<CartItemModel> build() {
    return [];
  }

  // Add product to cart
  void addToCart({
    required ProductModel product,
    int quantity = 1,
    String? selectedSize,
    String? selectedColor,
  }) {
    final existingIndex = state.indexWhere(
      (item) =>
          item.product.id == product.id &&
          item.selectedSize == selectedSize &&
          item.selectedColor == selectedColor,
    );

    // If same product with same options already exists
    if (existingIndex != -1) {
      final existingItem = state[existingIndex];

      final updatedItem = existingItem.copyWith(
        quantity:
            existingItem.quantity + quantity,
      );

      final updatedList = [...state];

      updatedList[existingIndex] = updatedItem;

      state = updatedList;

      return;
    }

    // Add new product
    final newItem = CartItemModel(
      product: product,
      quantity: quantity,
      selectedSize: selectedSize,
      selectedColor: selectedColor,
    );

    state = [
      ...state,
      newItem,
    ];
  }

  // Increase quantity
  void increaseQuantity(
    CartItemModel item,
  ) {
    final index = state.indexOf(item);

    if (index == -1) return;

    final updatedItem = item.copyWith(
      quantity: item.quantity + 1,
    );

    final updatedList = [...state];

    updatedList[index] = updatedItem;

    state = updatedList;
  }

  // Decrease quantity
  void decreaseQuantity(
    CartItemModel item,
  ) {
    final index = state.indexOf(item);

    if (index == -1) return;

    if (item.quantity <= 1) {
      removeItem(item);
      return;
    }

    final updatedItem = item.copyWith(
      quantity: item.quantity - 1,
    );

    final updatedList = [...state];

    updatedList[index] = updatedItem;

    state = updatedList;
  }

  // Remove item
  void removeItem(
    CartItemModel item,
  ) {
    state = state
        .where(
          (cartItem) => cartItem != item,
        )
        .toList();
  }

  // Clear cart
  void clearCart() {
    state = [];
  }

  // Total items
  int get totalItems {
    return state.fold(
      0,
      (total, item) =>
          total + item.quantity,
    );
  }

  // Subtotal
  double get subtotal {
    return state.fold(
      0,
      (total, item) =>
          total + item.totalPrice,
    );
  }

  // Delivery charge
  double get deliveryCharge {
    if (state.isEmpty) {
      return 0;
    }

    return 100;
  }

  // Final total
  double get total {
    return subtotal + deliveryCharge;
  }
}