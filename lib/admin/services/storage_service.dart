import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

class StorageService {
  final SupabaseClient _supabase =
      Supabase.instance.client;

  Future<String> uploadProductImage({
    required Uint8List imageBytes,
    required String fileName,
  }) async {
    final path =
        'products/${DateTime.now().millisecondsSinceEpoch}_$fileName';

    await _supabase.storage
        .from('product-images')
        .uploadBinary(
          path,
          imageBytes,
          fileOptions: const FileOptions(
            upsert: false,
          ),
        );

    final imageUrl = _supabase.storage
        .from('product-images')
        .getPublicUrl(path);

    return imageUrl;
  }
}