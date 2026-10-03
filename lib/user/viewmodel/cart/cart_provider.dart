import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoppee_world/user/models/cart/cart_item_model.dart';
import 'package:shoppee_world/user/models/product/product_model.dart';
import 'package:shoppee_world/user/repositories/cart_repository.dart';

final cartRepositoryProvider = Provider<CartRepository>((ref) {
  return CartRepository();
});

final cartProvider =
    NotifierProvider<CartNotifier, List<CartItemModel>>(
  CartNotifier.new,
);

class CartNotifier extends Notifier<List<CartItemModel>> {
  late final CartRepository _repository;

  @override
  List<CartItemModel> build() {
    _repository = ref.read(cartRepositoryProvider);

    return [];
  }
// Load cart from Supabase
Future<void> loadCart() async {
  try {
    final data = await _repository.getCartItems();

    final items = data.map((item) {
      final productJson =
          item['products'] as Map<String, dynamic>;

      final product =
          ProductModel.fromJson(productJson);

      return CartItemModel(
        cartItemId: item['id'] as int,
        product: product,
        quantity: item['quantity'] as int,
        selectedSize: item['selected_size'] as String?,
        selectedColor: item['selected_color'] as String?,
      );
    }).toList();

    state = items;
  } catch (e) {
    // Keep current cart state if loading fails.
  }
}

  // Add product to cart
  Future<void> addToCart({
    required ProductModel product,
    int quantity = 1,
    String? selectedSize,
    String? selectedColor,
  }) async {
    final existingIndex = state.indexWhere(
      (item) =>
          item.product.id == product.id &&
          item.selectedSize == selectedSize &&
          item.selectedColor == selectedColor,
    );

    if (existingIndex != -1) {
      final existingItem = state[existingIndex];

      final newQuantity =
          existingItem.quantity + quantity;

      final updatedItem = existingItem.copyWith(
        quantity: newQuantity,
      );

      final updatedList = [...state];

      updatedList[existingIndex] = updatedItem;

      state = updatedList;

      // For now we will handle the Supabase update
      // after adding cart IDs to the model.
      return;
    }

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

    await _repository.addToCart(
      productId: product.id,
      quantity: quantity,
      selectedSize: selectedSize,
      selectedColor: selectedColor,
    );
  }

  // Increase quantity
// Increase quantity
Future<void> increaseQuantity(
  CartItemModel item,
) async {
  final index = state.indexOf(item);

  if (index == -1) return;

  final newQuantity = item.quantity + 1;

  final updatedItem = item.copyWith(
    quantity: newQuantity,
  );

  final updatedList = [...state];

  updatedList[index] = updatedItem;

  state = updatedList;

  if (item.cartItemId != null) {
    await _repository.updateQuantity(
      cartItemId: item.cartItemId!,
      quantity: newQuantity,
    );
  }
}

  // Decrease quantity
// Decrease quantity
Future<void> decreaseQuantity(
  CartItemModel item,
) async {
  final index = state.indexOf(item);

  if (index == -1) return;

  if (item.quantity <= 1) {
    await removeItem(item);
    return;
  }

  final newQuantity = item.quantity - 1;

  final updatedItem = item.copyWith(
    quantity: newQuantity,
  );

  final updatedList = [...state];

  updatedList[index] = updatedItem;

  state = updatedList;

  if (item.cartItemId != null) {
    await _repository.updateQuantity(
      cartItemId: item.cartItemId!,
      quantity: newQuantity,
    );
  }
}

// Remove item
Future<void> removeItem(
  CartItemModel item,
) async {
  state = state
      .where(
        (cartItem) => cartItem != item,
      )
      .toList();

  if (item.cartItemId != null) {
    await _repository.removeItem(
      cartItemId: item.cartItemId!,
    );
  }
}

  // Clear cart
  Future<void> clearCart() async {
    state = [];

    await _repository.clearCart();
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