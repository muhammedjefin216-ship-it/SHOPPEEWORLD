import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoppee_world/user/models/product/product_model.dart';
import 'package:shoppee_world/user/repositories/product_repository.dart';
import 'package:shoppee_world/user/viewmodel/catagory/selected_category_provider.dart';

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository();
});

final productsProvider =
    FutureProvider<List<ProductModel>>((ref) async {
  final repository = ref.read(productRepositoryProvider);

  final selectedCategory = ref.watch(selectedCategoryProvider);

  return repository.getProducts(
    categoryId: selectedCategory,
  );
});