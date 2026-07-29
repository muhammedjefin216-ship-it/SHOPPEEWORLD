import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

class StorageService {
  final SupabaseClient _supabase =
      Supabase.instance.client;

  Future<String> uploadProductImage(
    File imageFile,
  ) async {
    // Create a unique file name
    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}.jpg';

    // Storage path
    final filePath =
        'products/$fileName';

    // Upload image
    await _supabase.storage
        .from('product-images')
        .upload(
          filePath,
          imageFile,
          fileOptions: const FileOptions(
            contentType: 'image/jpeg',
            upsert: false,
          ),
        );

    // Get public URL
    final imageUrl = _supabase.storage
        .from('product-images')
        .getPublicUrl(filePath);

    return imageUrl;
  }
}