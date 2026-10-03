import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoppee_world/admin/models/catagory/category_model.dart';
import 'package:shoppee_world/admin/models/catagory/category_provider.dart';

final categoriesProvider =
    FutureProvider<List<CategoryModel>>((ref) async {
  final repository = ref.read(categoryRepositoryProvider);

  final categories = await repository.getCategories();

  for (final category in categories) {
    print(
      'CATEGORY: ${category.name} | IMAGE: ${category.imageUrl}',
    );
  }

  return categories;
});