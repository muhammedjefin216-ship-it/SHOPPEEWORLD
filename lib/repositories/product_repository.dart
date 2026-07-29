import 'package:supabase_flutter/supabase_flutter.dart';

class ProductRepository {
  final SupabaseClient _supabase =
      Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getProducts() async {
    final response = await _supabase
        .from('products')
        .select('''
          id,
          name,
          image,
          price,
          rating,
          is_favorite,
          category_id,
          categories (
            id,
            name
          )
        ''')
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }
}