import 'package:supabase_flutter/supabase_flutter.dart';

class AdminOrderRepository {
  final SupabaseClient _supabase =
      Supabase.instance.client;

  // ============================================================
  // GET ALL ORDERS
  // ============================================================

  Future<List<Map<String, dynamic>>> getAllOrders() async {
    final response = await _supabase
        .from('orders')
        .select()
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }



  Future<List<Map<String, dynamic>>> getOrderItems(
  String orderId,
) async {
  print('ADMIN ORDER ID: $orderId');

  final response = await _supabase
      .from('order_items')
      .select()
      .eq('order_id', orderId);

  print('ADMIN ORDER ITEMS RESPONSE: $response');
  print('ADMIN ORDER ITEMS COUNT: ${response.length}');

  return List<Map<String, dynamic>>.from(response);
}

  Future<void> updateOrderStatus({
    required String orderId,
    required String status,
  }) async {
    await _supabase
        .from('orders')
        .update({
          'status': status,
        })
        .eq('id', orderId);
  }
}