import 'package:shoppee_world/user/models/product/product_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductRepository {
  final SupabaseClient _supabase =
      Supabase.instance.client;

  Future<List<ProductModel>> getProducts({
    int? categoryId,
  }) async {
    print("Selected Category ID: $categoryId");

    var query = _supabase
        .from('products')
        .select('''
          *,
          categories(name)
        ''');

    if (categoryId != null) {
      query = query.eq('category_id', categoryId);
    }

    final response = await query.order(
      'id',
      ascending: false,
    );

    return (response as List)
        .map((e) => ProductModel.fromJson(e))
        .toList();
  }



  Future<List<String>> getProductImages(int productId) async {
  final response = await _supabase
      .from('product_images')
      .select('image_url')
      .eq('product_id', productId)
      .order('sort_order');

  return (response as List)
      .map((item) => item['image_url'] as String)
      .toList();
}
}