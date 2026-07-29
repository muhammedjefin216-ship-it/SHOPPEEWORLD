import 'package:shoppee_world/admin/models/catagory/category_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class CategoryRepository {
  final SupabaseClient _supabase =
      Supabase.instance.client;

  Future<List<CategoryModel>> getCategories() async {
    final response = await _supabase
        .from('categories')
        .select()
        .order('name');

    return (response as List)
        .map(
          (json) => CategoryModel.fromJson(
            json as Map<String, dynamic>,
          ),
        )
        .toList();
  }
}