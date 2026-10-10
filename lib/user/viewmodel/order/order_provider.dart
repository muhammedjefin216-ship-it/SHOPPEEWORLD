import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoppee_world/user/repositories/order_repository.dart';

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return OrderRepository();
});

final myOrdersProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final repository = ref.read(orderRepositoryProvider);

  return repository.getMyOrders();
});

final hiddenOrdersProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final repository = ref.read(orderRepositoryProvider);

  return repository.getHiddenOrders();
});