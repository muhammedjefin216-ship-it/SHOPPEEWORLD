import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoppee_world/admin/models/product/product_model.dart';
import 'package:shoppee_world/admin/repositories/product_repository.dart';

final productRepositoryProvider =
    Provider<ProductRepository>((ref) {
  return ProductRepository();
});

final deleteProductProvider =
    Provider<ProductRepository>((ref) {
  return ProductRepository();
});

final productsProvider =
    FutureProvider<List<ProductModel>>((ref) async {
  final repository = ref.read(productRepositoryProvider);

  return repository.getProducts();
});