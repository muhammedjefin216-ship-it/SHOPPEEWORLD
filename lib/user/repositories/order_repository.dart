import 'package:supabase_flutter/supabase_flutter.dart';

class OrderRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  // ============================================================
  // CREATE ORDER
  // ============================================================

  Future<String> createOrder({
  required String customerName,
  required String customerPhone,
  required String address,
  required String place,
  required String landmark,
  required String district,
  required String state,
  required String pincode,
  required double totalAmount,
  required List<Map<String, dynamic>> items,
}) async {
  final user = _supabase.auth.currentUser;

  if (user == null) {
    throw Exception('User is not logged in');
  }

  // Create order
  final orderResponse = await _supabase
      .from('orders')
      .insert({
        'user_id': user.id,
        'customer_name': customerName,
        'customer_phone': customerPhone,
        'address': address,
        'place': place,
        'landmark': landmark,
        'district': district,
        'state': state,
        'pincode': pincode,
        'total_amount': totalAmount,
        'status': 'pending',
      })
      .select('id')
      .single();

  final orderId = orderResponse['id'] as String;

  // Create order items
  final orderItems = items.map((item) {
    return {
      'order_id': orderId,
      'product_id': item['product_id'],
      'product_name': item['product_name'],
      'price': item['price'],
      'quantity': item['quantity'],
      'size': item['size'],
      'color': item['color'],
      'image': item['image'],
    };
  }).toList();

  await _supabase
      .from('order_items')
      .insert(orderItems);

  return orderId;
}

  // ============================================================
  // GET MY ORDERS
  // ============================================================

  Future<List<Map<String, dynamic>>> getMyOrders() async {
    final user = _supabase.auth.currentUser;

    print("CURRENT USER: ${user?.id}");

    if (user == null) {
      throw Exception('User is not logged in');
    }

    print("Fetching orders...");

    final response = await _supabase
        .from('orders')
        .select()
        .eq('user_id', user.id)
        .eq('is_hidden', false)
        .order('created_at', ascending: false)
        .timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            throw Exception('Orders request timed out');
          },
        );

    print("ORDERS RESPONSE: $response");

    return List<Map<String, dynamic>>.from(response);
  }

  // ============================================================
  // HIDE SINGLE ORDER
  // ============================================================

  Future<void> hideOrder(String orderId) async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      throw Exception('User is not logged in');
    }

    await _supabase
        .from('orders')
        .update({
          'is_hidden': true,
        })
        .eq('id', orderId)
        .eq('user_id', user.id);
  }


   // ============================================================
  // GET HIDDEN ORDERS
  // ============================================================

  Future<List<Map<String, dynamic>>> getHiddenOrders() async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      throw Exception('User is not logged in');
    }

    final response = await _supabase
        .from('orders')
        .select()
        .eq('user_id', user.id)
        .eq('is_hidden', true)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  // ============================================================
  // RESTORE ORDER
  // ============================================================

  Future<void> restoreOrder(String orderId) async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      throw Exception('User is not logged in');
    }

    await _supabase
        .from('orders')
        .update({
          'is_hidden': false,
        })
        .eq('id', orderId)
        .eq('user_id', user.id);
  }

  // ============================================================
  // CLEAR ALL ORDER HISTORY
  // ============================================================

  Future<void> clearOrderHistory() async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      throw Exception('User is not logged in');
    }

    await _supabase
        .from('orders')
        .update({
          'is_hidden': true,
        })
        .eq('user_id', user.id);
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