import 'package:supabase_flutter/supabase_flutter.dart';

class AdminRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<bool> loginAdmin({
    required String email,
    required String password,
  }) async {
    final response = await _supabase
        .from('admins')
        .select()
        .eq('email', email)
        .eq('password', password);

    return response.isNotEmpty;
  }

  Future<List<Map<String, dynamic>>> getOrderItems(
  String orderId,
) async {
  final response = await _supabase
      .from('order_items')
      .select()
      .eq('order_id', orderId);

  return List<Map<String, dynamic>>.from(response);
}
}
