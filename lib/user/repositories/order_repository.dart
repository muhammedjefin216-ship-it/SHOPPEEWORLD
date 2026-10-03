import 'package:supabase_flutter/supabase_flutter.dart';

class OrderRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<String> createOrder({
    required String customerName,
    required String customerPhone,
    required String address,
    required String city,
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
          'city': city,
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