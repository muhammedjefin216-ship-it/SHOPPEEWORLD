import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoppee_world/admin/repositories/order_repositery.dart';

class AdminOrderDetailsScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> order;

  const AdminOrderDetailsScreen({
    super.key,
    required this.order,
  });

  @override
  ConsumerState<AdminOrderDetailsScreen> createState() =>
      _AdminOrderDetailsScreenState();
}

class _AdminOrderDetailsScreenState
    extends ConsumerState<AdminOrderDetailsScreen> {
  final AdminOrderRepository _repository =
      AdminOrderRepository();

  List<Map<String, dynamic>> items = [];
  bool isLoading = true;

  String selectedStatus = 'pending';
  bool isUpdating = false;

  final List<String> statuses = [
    'pending',
    'confirmed',
    'shipped',
    'delivered',
    'cancelled',
  ];

  @override
  void initState() {
    super.initState();

    selectedStatus =
        widget.order['status']?.toString() ?? 'pending';

    _loadOrderItems();
  }

  Future<void> _loadOrderItems() async {
    try {
      final orderId = widget.order['id'].toString();

      final result =
          await _repository.getOrderItems(orderId);

      if (!mounted) return;

      setState(() {
        items = result;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to load order items',
          ),
        ),
      );
    }
  }

  Future<void> _updateStatus(String status) async {
    if (status == selectedStatus) return;

    setState(() {
      isUpdating = true;
    });

    try {
      await _repository.updateOrderStatus(
        orderId: widget.order['id'].toString(),
        status: status,
      );

      if (!mounted) return;

      setState(() {
        selectedStatus = status;
        isUpdating = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Order status updated successfully',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isUpdating = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Failed to update order status',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;

    final customerName =
        order['customer_name']?.toString() ?? 'Unknown';

    final customerPhone =
        order['customer_phone']?.toString() ?? 'No phone';

    final address =
        order['address']?.toString() ?? '';

    final city =
        order['city']?.toString() ?? '';

    final state =
        order['state']?.toString() ?? '';

    final pincode =
        order['pincode']?.toString() ?? '';

    final totalAmount =
        order['total_amount']?.toString() ?? '0';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =====================================================
            // ORDER INFORMATION
            // =====================================================

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Order Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      'Order ID: ${order['id']}',
                    ),

                    const SizedBox(height: 6),

                    Text(
                      'Customer: $customerName',
                    ),

                    const SizedBox(height: 6),

                    Text(
                      'Phone: $customerPhone',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // =====================================================
            // ORDER STATUS
            // =====================================================

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Order Status',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    DropdownButtonFormField<String>(
                      value: selectedStatus,
                      decoration:
                          const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Status',
                      ),
                      items: statuses.map((status) {
                        return DropdownMenuItem<String>(
                          value: status,
                          child: Text(
                            status.toUpperCase(),
                          ),
                        );
                      }).toList(),
                      onChanged: isUpdating
                          ? null
                          : (value) {
                              if (value != null) {
                                _updateStatus(value);
                              }
                            },
                    ),

                    if (isUpdating) ...[
                      const SizedBox(height: 12),
                      const LinearProgressIndicator(),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // =====================================================
            // PRODUCTS
            // =====================================================

            const Text(
              'Products',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            if (isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (items.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'No products found for this order.',
                  ),
                ),
              )
            else
              ...items.map(
                (item) {
                  final productName =
                      item['product_name']
                              ?.toString() ??
                          'Product';

                  final price =
                      item['price']?.toString() ?? '0';

                  final quantity =
                      item['quantity']?.toString() ?? '0';

                  final size =
                      item['size']?.toString() ?? '';

                  final color =
                      item['color']?.toString() ?? '';

                  final image =
                      item['image']?.toString();

                  return Card(
                    margin:
                        const EdgeInsets.only(bottom: 10),
                    child: Padding(
                      padding:
                          const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          if (image != null &&
                              image.isNotEmpty)
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(8),
                              child: Image.network(
                                image,
                                width: 65,
                                height: 65,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (
                                      context,
                                      error,
                                      stackTrace,
                                    ) {
                                  return Container(
                                    width: 65,
                                    height: 65,
                                    color: Colors.grey.shade200,
                                    child: const Icon(
                                      Icons.image,
                                    ),
                                  );
                                },
                              ),
                            )
                          else
                            Container(
                              width: 65,
                              height: 65,
                              color: Colors.grey.shade200,
                              child: const Icon(
                                Icons.image,
                              ),
                            ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  productName,
                                  style:
                                      const TextStyle(
                                    fontWeight:
                                        FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),

                                const SizedBox(height: 5),

                                Text(
                                  'Price: ₹$price',
                                ),

                                Text(
                                  'Quantity: $quantity',
                                ),

                                if (size.isNotEmpty)
                                  Text(
                                    'Size: $size',
                                  ),

                                if (color.isNotEmpty)
                                  Text(
                                    'Color: $color',
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

            const SizedBox(height: 16),

            // =====================================================
            // DELIVERY ADDRESS
            // =====================================================

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Delivery Address',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(address),

                    if (city.isNotEmpty)
                      Text(city),

                    if (state.isNotEmpty)
                      Text(state),

                    if (pincode.isNotEmpty)
                      Text(pincode),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // =====================================================
            // TOTAL
            // =====================================================

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Amount',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '₹$totalAmount',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}