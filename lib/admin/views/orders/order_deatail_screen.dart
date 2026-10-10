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
  bool isUpdating = false;

  String? error;

  late String selectedStatus;

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
        widget.order['status']?.toString().toLowerCase() ??
            'pending';

    if (!statuses.contains(selectedStatus)) {
      selectedStatus = 'pending';
    }

    _loadOrderItems();
  }

  // =============================================================
  // LOAD ORDER ITEMS
  // =============================================================

  Future<void> _loadOrderItems() async {
    try {
      final orderId =
          widget.order['id'].toString();

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
        error = e.toString();
        isLoading = false;
      });
    }
  }

  // =============================================================
  // UPDATE STATUS
  // =============================================================

  Future<void> _updateStatus(String status) async {
    if (status == selectedStatus) {
      return;
    }

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
        SnackBar(
          content: Text(
            'Order status changed to ${status.toUpperCase()}',
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

  // =============================================================
  // BACK
  // =============================================================

  void _goBack() {
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;

    final customerName =
        order['customer_name']?.toString() ??
            'Unknown';

    final customerPhone =
        order['customer_phone']?.toString() ??
            'No phone';

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

    final orderId =
        order['id']?.toString() ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Order Details',
        ),

        leading: IconButton(
          onPressed: _goBack,
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            // ===================================================
            // ORDER INFORMATION
            // ===================================================

            Card(
              child: Padding(
                padding:
                    const EdgeInsets.all(16),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    const Text(
                      'Order Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 14),

                    Text(
                      'Order ID: $orderId',
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Customer: $customerName',
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Phone: $customerPhone',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ===================================================
            // ORDER STATUS
            // ===================================================

            Card(
              child: Padding(
                padding:
                    const EdgeInsets.all(16),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    const Text(
                      'Order Status',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 14),

                    Row(
                      children: [

                        Container(
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 7,
                          ),

                          decoration: BoxDecoration(
                            color:
                                _statusColor(
                                  selectedStatus,
                                ).withOpacity(.12),

                            borderRadius:
                                BorderRadius.circular(
                              20,
                            ),
                          ),

                          child: Text(
                            selectedStatus
                                .toUpperCase(),

                            style: TextStyle(
                              color:
                                  _statusColor(
                                selectedStatus,
                              ),
                              fontWeight:
                                  FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),

                        const Spacer(),

                        if (isUpdating)
                          const SizedBox(
                            height: 22,
                            width: 22,
                            child:
                                CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    DropdownButtonFormField<String>(
                      initialValue: selectedStatus,

                      decoration:
                          const InputDecoration(
                        border:
                            OutlineInputBorder(),
                        labelText:
                            'Change Status',
                      ),

                      items: statuses.map(
                        (status) {
                          return DropdownMenuItem<
                              String>(
                            value: status,

                            child: Row(
                              children: [

                                Icon(
                                  _statusIcon(
                                    status,
                                  ),
                                  size: 18,
                                  color:
                                      _statusColor(
                                    status,
                                  ),
                                ),

                                const SizedBox(
                                  width: 8,
                                ),

                                Text(
                                  status
                                      .toUpperCase(),
                                ),
                              ],
                            ),
                          );
                        },
                      ).toList(),

                      onChanged: isUpdating
                          ? null
                          : (value) {

                              if (value != null) {
                                _updateStatus(
                                  value,
                                );
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

            // ===================================================
            // PRODUCTS
            // ===================================================

            const Text(
              'Products',
              style: TextStyle(
                fontSize: 18,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            if (isLoading)
              const Center(
                child: Padding(
                  padding:
                      EdgeInsets.all(30),

                  child:
                      CircularProgressIndicator(),
                ),
              )

            else if (error != null)
              Card(
                child: Padding(
                  padding:
                      const EdgeInsets.all(16),

                  child: Text(
                    'Failed to load products.',
                    style: TextStyle(
                      color: Colors.red.shade700,
                    ),
                  ),
                ),
              )

            else if (items.isEmpty)
              const Card(
                child: Padding(
                  padding:
                      EdgeInsets.all(16),

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
                      item['price']
                              ?.toString() ??
                          '0';

                  final quantity =
                      item['quantity']
                              ?.toString() ??
                          '0';

                  final size =
                      item['size']
                              ?.toString() ??
                          '';

                  final color =
                      item['color']
                              ?.toString() ??
                          '';

                  final image =
                      item['image']
                          ?.toString();

                  return Card(
                    margin:
                        const EdgeInsets.only(
                      bottom: 10,
                    ),

                    child: Padding(
                      padding:
                          const EdgeInsets.all(
                        12,
                      ),

                      child: Row(
                        children: [

                          // PRODUCT IMAGE
                          if (image != null &&
                              image.isNotEmpty)

                            ClipRRect(
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                8,
                              ),

                              child:
                                  Image.network(
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
                                  return
                                      _imagePlaceholder();
                                },
                              ),
                            )

                          else
                            _imagePlaceholder(),

                          const SizedBox(
                            width: 12,
                          ),

                          // PRODUCT DETAILS
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,

                              children: [

                                Text(
                                  productName,

                                  style:
                                      const TextStyle(
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                    fontSize: 16,
                                  ),
                                ),

                                const SizedBox(
                                  height: 5,
                                ),

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

            // ===================================================
            // DELIVERY ADDRESS
            // ===================================================

            Card(
              child: Padding(
                padding:
                    const EdgeInsets.all(16),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    const Text(
                      'Delivery Address',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    if (address.isNotEmpty)
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

            // ===================================================
            // TOTAL
            // ===================================================

            Card(
              child: Padding(
                padding:
                    const EdgeInsets.all(16),

                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment
                          .spaceBetween,

                  children: [

                    const Text(
                      'Total Amount',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    Text(
                      '₹$totalAmount',

                      style:
                          const TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // =============================================================
  // STATUS COLOR
  // =============================================================

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {

      case 'confirmed':
        return Colors.blue;

      case 'shipped':
        return Colors.orange;

      case 'delivered':
        return Colors.green;

      case 'cancelled':
        return Colors.red;

      case 'pending':
      default:
        return Colors.amber;
    }
  }

  // =============================================================
  // STATUS ICON
  // =============================================================

  IconData _statusIcon(String status) {
    switch (status.toLowerCase()) {

      case 'confirmed':
        return Icons.check_circle_outline;

      case 'shipped':
        return Icons.local_shipping_outlined;

      case 'delivered':
        return Icons.done_all;

      case 'cancelled':
        return Icons.cancel_outlined;

      case 'pending':
      default:
        return Icons.pending_outlined;
    }
  }

  // =============================================================
  // IMAGE PLACEHOLDER
  // =============================================================

  Widget _imagePlaceholder() {
    return Container(
      width: 65,
      height: 65,

      color: Colors.grey.shade200,

      child: const Icon(
        Icons.image,
      ),
    );
  }
}