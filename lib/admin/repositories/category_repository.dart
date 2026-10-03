import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:shoppee_world/admin/models/catagory/category_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CategoryRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  // =========================
  // GET CATEGORIES
  // =========================

  Future<List<CategoryModel>> getCategories() async {
    final response = await _supabase
        .from('categories')
        .select()
        .order('name');

    return (response as List)
        .map((json) => CategoryModel.fromJson(json))
        .toList();
  }

  // =========================
  // ADD CATEGORY
  // =========================

  Future<void> addCategory({
    required String name,
    String? imageUrl,
  }) async {
    await _supabase.from('categories').insert({
      'name': name,
      'image_url': imageUrl,
    });
  }

  // =========================
  // UPLOAD CATEGORY IMAGE
  // =========================

 Future<String> uploadCategoryImage(File imageFile) async {
  final user = _supabase.auth.currentUser;

  print("UPLOAD USER: ${user?.id}");
  print("UPLOAD EMAIL: ${user?.email}");

  final fileName =
      '${DateTime.now().millisecondsSinceEpoch}_${path.basename(imageFile.path)}';

  final filePath = 'categories/$fileName';

  await _supabase.storage
      .from('category-images')
      .upload(
        filePath,
        imageFile,
      );

  return _supabase.storage
      .from('category-images')
      .getPublicUrl(filePath);
}

  // =========================
  // UPDATE CATEGORY
  // =========================

  Future<void> updateCategory({
    required int id,
    required String name,
    String? imageUrl,
  }) async {
    await _supabase
        .from('categories')
        .update({
          'name': name,
          'image_url': imageUrl,
        })
        .eq('id', id);
  }

  // =========================
  // DELETE CATEGORY
  // =========================

  Future<void> deleteCategory(int id) async {
    // Check whether products are using this category
    final products = await _supabase
        .from('products')
        .select('id')
        .eq('category_id', id);

    if ((products as List).isNotEmpty) {
      throw Exception(
        'This category cannot be deleted because products are using it.',
      );
    }

    // Delete category if no products are using it
    await _supabase
        .from('categories')
        .delete()
        .eq('id', id);
  }
}