import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoppee_world/models/product/product_model.dart';
import 'package:shoppee_world/repositories/product_repository.dart';

final productRepositoryProvider = Provider<ProductRepository>(
  (ref) {
    return ProductRepository();
  },
);

final productsProvider =
    FutureProvider<List<ProductModel>>((ref) async {
  final repository =
      ref.read(productRepositoryProvider);

  final data =
      await repository.getProducts();

  return data
      .map(
        (json) => ProductModel.fromJson(json),
      )
      .toList();
});