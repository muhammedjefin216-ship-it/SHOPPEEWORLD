import 'package:shoppee_world/user/models/product/product_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class WishlistRepository {
  final SupabaseClient _supabase =
      Supabase.instance.client;

Future<void> addToWishlist({
  required int productId,
}) async {
  final user = _supabase.auth.currentUser;

  if (user == null) {
    throw Exception('User is not logged in');
  }

  print("User: ${user.id}");
  print("Product ID: $productId");

  try {
    await _supabase.from('wishlist').insert({
      'user_id': user.id,
      'product_id': productId,
    });

    print("Wishlist Added Successfully");
  } catch (e) {
    print("Wishlist Error: $e");
    rethrow;
  }
}

  // Remove product from wishlist
  Future<void> removeFromWishlist({
    required int productId,
  }) async {
    final user = _supabase.auth.currentUser;

    if (user == null) return;

    await _supabase
        .from('wishlist')
        .delete()
        .eq('user_id', user.id)
        .eq('product_id', productId);
  }

  // Get wishlist products
  Future<List<ProductModel>> getWishlist() async {
    final user = _supabase.auth.currentUser;

    if (user == null) return [];

    final response = await _supabase
        .from('wishlist')
        .select('''
          products(
            *,
            categories(name)
          )
        ''')
        .eq('user_id', user.id);

    return (response as List)
        .map(
          (e) => ProductModel.fromJson(
            e['products'],
          ),
        )
        .toList();
  }

  // Check favorite
  Future<bool> isFavorite(
    int productId,
  ) async {
    final user = _supabase.auth.currentUser;

    if (user == null) return false;

    final response = await _supabase
        .from('wishlist')
        .select('id')
        .eq('user_id', user.id)
        .eq('product_id', productId)
        .maybeSingle();

    return response != null;
  }
}