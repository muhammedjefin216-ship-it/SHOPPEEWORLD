import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoppee_world/admin/models/catagory/category_model.dart';
import 'package:shoppee_world/admin/repositories/category_repository.dart';

final categoryRepositoryProvider =
    Provider<CategoryRepository>((ref) {
  return CategoryRepository();
});

final deleteCategoryProvider =
    Provider<CategoryRepository>((ref) {
  return CategoryRepository();
});

final categoriesProvider =
    FutureProvider<List<CategoryModel>>((ref) async {
  final repository = ref.read(categoryRepositoryProvider);

  return repository.getCategories();
});