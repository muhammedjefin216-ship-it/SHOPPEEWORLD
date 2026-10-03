import 'package:shoppee_world/admin/models/product/product_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductRepository {
  final SupabaseClient _supabase =
      Supabase.instance.client;

  // ============================================================
  // ADD PRODUCT
  // ============================================================

  Future<int> addProduct({
    required String name,
    required String image,
    required double price,
    required double rating,
    required int categoryId,
    required double originalPrice,
    required double offerPrice,
    required String description,
    required int stockQuantity,
    required List<String> availableSizes,
    required List<String> availableColors,
  }) async {
    final response = await _supabase
        .from('products')
        .insert({
          'name': name,
          'image': image,
          'price': price,
          'rating': rating,
          'category_id': categoryId,
          'original_price': originalPrice,
          'offer_price': offerPrice,
          'description': description,
          'stock_quantity': stockQuantity,
          'available_sizes': availableSizes,
          'available_colors': availableColors,
        })
        .select('id')
        .single();

    return response['id'] as int;
  }

  // ============================================================
  // ADD PRODUCT IMAGES
  // ============================================================

  Future<void> addProductImages({
    required int productId,
    required List<String> imageUrls,
  }) async {
    if (imageUrls.isEmpty) return;

    final data = imageUrls.asMap().entries.map((entry) {
      return {
        'product_id': productId,
        'image_url': entry.value,
        'sort_order': entry.key,
      };
    }).toList();

    await _supabase
        .from('product_images')
        .insert(data);
  }

  // ============================================================
  // GET PRODUCT IMAGES
  // ============================================================

  Future<List<String>> getProductImages(
    int productId,
  ) async {
    final response = await _supabase
        .from('product_images')
        .select('image_url')
        .eq('product_id', productId)
        .order('sort_order');

    return (response as List)
        .map(
          (item) => item['image_url'] as String,
        )
        .toList();
  }

  // ============================================================
  // DELETE PRODUCT IMAGE
  // ============================================================

  Future<void> deleteProductImage({
    required int productId,
    required String imageUrl,
  }) async {
    await _supabase
        .from('product_images')
        .delete()
        .eq('product_id', productId)
        .eq('image_url', imageUrl);
  }

  // ============================================================
  // DELETE ALL PRODUCT IMAGES
  // ============================================================

  Future<void> deleteAllProductImages(
    int productId,
  ) async {
    await _supabase
        .from('product_images')
        .delete()
        .eq('product_id', productId);
  }

  // ============================================================
  // UPDATE PRODUCT
  // ============================================================

  Future<void> updateProduct({
    required int id,
    required String name,
    required String image,
    required double price,
    required double rating,
    required int categoryId,
    required double originalPrice,
    required double offerPrice,
    required String description,
    required int stockQuantity,
    required List<String> availableSizes,
    required List<String> availableColors,
  }) async {
    await _supabase
        .from('products')
        .update({
          'name': name,
          'image': image,
          'price': price,
          'rating': rating,
          'category_id': categoryId,
          'original_price': originalPrice,
          'offer_price': offerPrice,
          'description': description,
          'stock_quantity': stockQuantity,
          'available_sizes': availableSizes,
          'available_colors': availableColors,
        })
        .eq('id', id);
  }

  // ============================================================
  // GET PRODUCTS
  // ============================================================

  Future<List<ProductModel>> getProducts() async {
    final response = await _supabase
        .from('products')
        .select()
        .order('id', ascending: false);

    return (response as List)
        .map(
          (e) => ProductModel.fromJson(e),
        )
        .toList();
  }

Future<String?> deleteProduct(int id) async {
  try {
    final orderItems = await _supabase
        .from('order_items')
        .select('id')
        .eq('product_id', id);

    if ((orderItems as List).isNotEmpty) {
      return 'This product cannot be deleted because it has already been ordered.';
    }

    await _supabase
        .from('products')
        .delete()
        .eq('id', id);

    return null;
  } on PostgrestException catch (e) {
    if (e.code == '23503' &&
        e.message.contains('order_items_product_id_fkey')) {
      return 'This product cannot be deleted because it has already been ordered.';
    }

    return 'Unable to delete this product. Please try again.';
  } catch (e) {
    return 'Unable to delete this product. Please try again.';
  }
}
}    