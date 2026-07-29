import 'package:supabase_flutter/supabase_flutter.dart';

class ProductRepository {
  final SupabaseClient _supabase =
      Supabase.instance.client;

  Future<void> addProduct({
    required String name,
    required String image,
    required double price,
    required double rating,
    required int categoryId,
  }) async {
    await _supabase
        .from('products')
        .insert({
      'name': name,
      'image': image,
      'price': price,
      'rating': rating,
      'category_id': categoryId,
    });
  }
}