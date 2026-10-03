import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoppee_world/admin/repositories/order_repositery.dart';

final adminOrderRepositoryProvider =
    Provider<AdminOrderRepository>((ref) {
  return AdminOrderRepository();
});

final adminOrdersProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final repository =
      ref.read(adminOrderRepositoryProvider);

  return repository.getAllOrders();
});