// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_fonts/google_fonts.dart';

// import '../../repositories/order_repository.dart';

// class OrderDetailsScreen extends ConsumerStatefulWidget {
//   final Map<String, dynamic> order;

//   const OrderDetailsScreen({super.key, required this.order});

//   @override
//   ConsumerState<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
// }

// class _OrderDetailsScreenState extends ConsumerState<OrderDetailsScreen> {
//   final OrderRepository _repository = OrderRepository();

//   List<Map<String, dynamic>> items = [];
//   bool isLoading = true;
//   String? error;

//   @override
//   void initState() {
//     super.initState();
//     _loadOrderItems();
//   }

//   Future<void> _loadOrderItems() async {
//     try {
//       final orderId = widget.order['id'].toString();

//       final result = await _repository.getOrderItems(orderId);

//       if (!mounted) return;

//       setState(() {
//         items = result;
//         isLoading = false;
//       });
//     } catch (e) {
//       if (!mounted) return;

//       setState(() {
//         error = e.toString();
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final order = widget.order;

//     final status = order['status']?.toString() ?? 'pending';

//     final total =
//         double.tryParse(order['total_amount']?.toString() ?? '0') ?? 0;

//     return Scaffold(
//       backgroundColor: const Color(0xff080C0D),
//       appBar: AppBar(
//         backgroundColor: const Color(0xff080C0D),
//         surfaceTintColor: Colors.transparent,
//         elevation: 0,
//         leading: Padding(
//           padding: const EdgeInsets.only(left: 8),
//           child: IconButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             icon: const Icon(
//               Icons.arrow_back_ios_new_rounded,
//               color: Colors.white,
//               size: 18,
//             ),
//           ),
//         ),
//         centerTitle: true,
//         title: Text(
//           "Order Details",
//           style: GoogleFonts.outfit(
//             color: Colors.white,
//             fontSize: 18,
//             fontWeight: FontWeight.w700,
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         physics: const BouncingScrollPhysics(),
//         padding: const EdgeInsets.fromLTRB(18, 8, 18, 30),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // =====================================================
//             // ORDER HEADER
//             // =====================================================
//             _buildOrderHeader(order: order, status: status),

//             const SizedBox(height: 24),

//             // =====================================================
//             // PRODUCTS
//             // =====================================================
//             _buildSectionTitle("Products"),

//             const SizedBox(height: 11),

//             if (isLoading)
//               const Center(
//                 child: Padding(
//                   padding: EdgeInsets.all(35),
//                   child: CircularProgressIndicator(
//                     color: Colors.white,
//                     strokeWidth: 2,
//                   ),
//                 ),
//               )
//             else if (error != null)
//               _buildError()
//             else if (items.isEmpty)
//               _buildEmptyItems()
//             else
//               Column(
//                 children: items.map((item) => _buildProductItem(item)).toList(),
//               ),

//             const SizedBox(height: 20),

//             // =====================================================
//             // PRICE SUMMARY
//             // =====================================================
//             _buildPriceSummary(order: order, total: total),

//             const SizedBox(height: 20),

//             // =====================================================
//             // CUSTOMER DETAILS
//             // =====================================================
//             _buildCustomerDetails(order),

//             const SizedBox(height: 20),

//             // =====================================================
//             // DELIVERY ADDRESS
//             // =====================================================
//             _buildDeliveryAddress(order),
//           ],
//         ),
//       ),
//     );
//   }

//   // =============================================================
//   // ORDER HEADER
//   // =============================================================

//   Widget _buildOrderHeader({
//     required Map<String, dynamic> order,
//     required String status,
//   }) {
//     final createdAt = order['created_at']?.toString() ?? '';

//     final normalizedStatus = status.toLowerCase();

//     final isPending = normalizedStatus == 'pending';

//     return Container(
//       padding: const EdgeInsets.all(18),
//       decoration: BoxDecoration(
//         color: const Color(0xff191D1E),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: Colors.white.withOpacity(.07)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 height: 48,
//                 width: 48,
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(.07),
//                   borderRadius: BorderRadius.circular(14),
//                 ),
//                 child: const Icon(
//                   Icons.shopping_bag_outlined,
//                   color: Colors.white,
//                   size: 23,
//                 ),
//               ),

//               const SizedBox(width: 12),

//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Order #${_shortOrderId(order['id'])}",
//                       style: GoogleFonts.outfit(
//                         color: Colors.white,
//                         fontSize: 15,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                     const SizedBox(height: 5),
//                     Text(
//                       "Placed on ${_formatDate(createdAt)}",
//                       style: GoogleFonts.outfit(
//                         color: Colors.white38,
//                         fontSize: 10,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               _statusBadge(status),
//             ],
//           ),

//           const SizedBox(height: 18),

//           Container(height: 1, color: Colors.white.withOpacity(.06)),

//           const SizedBox(height: 15),

//           Row(
//             children: [
//               Icon(
//                 isPending
//                     ? Icons.schedule_rounded
//                     : Icons.check_circle_outline_rounded,
//                 size: 17,
//                 color: isPending
//                     ? const Color(0xffFBBF24)
//                     : const Color(0xff6EE7B7),
//               ),

//               const SizedBox(width: 8),

//               Expanded(
//                 child: Text(
//                   isPending
//                       ? "Your order is waiting for confirmation"
//                       : "Your order has been updated",
//                   style: GoogleFonts.outfit(
//                     color: Colors.white54,
//                     fontSize: 10,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   // =============================================================
//   // PRODUCT ITEM
//   // =============================================================

//   Widget _buildProductItem(Map<String, dynamic> item) {
//     final name = item['product_name']?.toString() ?? '';

//     final image = item['image']?.toString() ?? '';

//     final price = double.tryParse(item['price']?.toString() ?? '0') ?? 0;

//     final quantity = int.tryParse(item['quantity']?.toString() ?? '0') ?? 0;

//     final size = item['size']?.toString();

//     final color = item['color']?.toString();

//     final itemTotal = price * quantity;

//     return Container(
//       margin: const EdgeInsets.only(bottom: 10),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: const Color(0xff191D1E),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.white.withOpacity(.06)),
//       ),
//       child: Row(
//         children: [
//           // Product Image
//           ClipRRect(
//             borderRadius: BorderRadius.circular(12),
//             child: image.isNotEmpty
//                 ? Image.network(
//                     image,
//                     width: 72,
//                     height: 72,
//                     fit: BoxFit.cover,
//                     errorBuilder: (_, _, _) => _imagePlaceholder(),
//                   )
//                 : _imagePlaceholder(),
//           ),

//           const SizedBox(width: 12),

//           // Product Information
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   name,
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                   style: GoogleFonts.outfit(
//                     color: Colors.white,
//                     fontSize: 13,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),

//                 const SizedBox(height: 6),

//                 if (size != null && size.isNotEmpty)
//                   Text("Size: $size", style: _smallTextStyle()),

//                 if (color != null && color.isNotEmpty)
//                   Text("Color: $color", style: _smallTextStyle()),

//                 const SizedBox(height: 4),

//                 Text("Qty: $quantity", style: _smallTextStyle()),
//               ],
//             ),
//           ),

//           const SizedBox(width: 8),

//           // Item Total
//           Text(
//             "₹${itemTotal.toStringAsFixed(0)}",
//             style: GoogleFonts.outfit(
//               color: Colors.white,
//               fontSize: 13,
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // =============================================================
//   // PRICE SUMMARY
//   // =============================================================

//   Widget _buildPriceSummary({
//     required Map<String, dynamic> order,
//     required double total,
//   }) {
//     return _sectionContainer(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildSectionTitle("Payment Summary"),

//           const SizedBox(height: 15),

//           _priceRow(
//             "Total Amount",
//             "₹${total.toStringAsFixed(0)}",
//             isTotal: true,
//           ),
//         ],
//       ),
//     );
//   }

//   // =============================================================
//   // CUSTOMER DETAILS
//   // =============================================================

//   Widget _buildCustomerDetails(Map<String, dynamic> order) {
//     return _sectionContainer(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildSectionTitle("Customer Details"),

//           const SizedBox(height: 14),

//           _detailRow(
//             Icons.person_outline_rounded,
//             order['customer_name']?.toString() ?? '',
//           ),

//           const SizedBox(height: 10),

//           _detailRow(
//             Icons.phone_outlined,
//             order['customer_phone']?.toString() ?? '',
//           ),
//         ],
//       ),
//     );
//   }

//   // =============================================================
//   // DELIVERY ADDRESS
//   // =============================================================

//   Widget _buildDeliveryAddress(Map<String, dynamic> order) {
//     return _sectionContainer(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildSectionTitle("Delivery Address"),

//           const SizedBox(height: 14),

//           _detailRow(Icons.home_outlined, order['address']?.toString() ?? ''),

//           const SizedBox(height: 10),

//           _detailRow(
//             Icons.location_on_outlined,
//             "${order['city'] ?? ''}, "
//             "${order['state'] ?? ''}",
//           ),

//           const SizedBox(height: 10),

//           _detailRow(
//             Icons.pin_drop_outlined,
//             "Pincode: ${order['pincode'] ?? ''}",
//           ),
//         ],
//       ),
//     );
//   }

//   // =============================================================
//   // DETAIL ROW
//   // =============================================================

//   Widget _detailRow(IconData icon, String text) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Icon(icon, color: Colors.white38, size: 17),

//         const SizedBox(width: 10),

//         Expanded(
//           child: Text(
//             text,
//             style: GoogleFonts.outfit(
//               color: Colors.white70,
//               fontSize: 11,
//               height: 1.4,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   // =============================================================
//   // PRICE ROW
//   // =============================================================

//   Widget _priceRow(String title, String value, {bool isTotal = false}) {
//     return Row(
//       children: [
//         Text(
//           title,
//           style: GoogleFonts.outfit(
//             color: isTotal ? Colors.white : Colors.white54,
//             fontSize: isTotal ? 14 : 11,
//             fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
//           ),
//         ),

//         const Spacer(),

//         Text(
//           value,
//           style: GoogleFonts.outfit(
//             color: Colors.white,
//             fontSize: isTotal ? 17 : 12,
//             fontWeight: FontWeight.w700,
//           ),
//         ),
//       ],
//     );
//   }

//   // =============================================================
//   // SECTION CONTAINER
//   // =============================================================

//   Widget _sectionContainer({required Widget child}) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: const Color(0xff191D1E),
//         borderRadius: BorderRadius.circular(18),
//         border: Border.all(color: Colors.white.withOpacity(.06)),
//       ),
//       child: child,
//     );
//   }

//   // =============================================================
//   // SECTION TITLE
//   // =============================================================

//   Widget _buildSectionTitle(String title) {
//     return Text(
//       title,
//       style: GoogleFonts.outfit(
//         color: Colors.white,
//         fontSize: 15,
//         fontWeight: FontWeight.w700,
//       ),
//     );
//   }

//   // =============================================================
//   // STATUS BADGE
//   // =============================================================

//   Widget _statusBadge(String status) {
//     final normalized = status.toLowerCase();

//     final isPending = normalized == 'pending';

//     final isCompleted = normalized == 'completed';

//     final Color textColor = isPending
//         ? const Color(0xffFBBF24)
//         : isCompleted
//         ? const Color(0xff6EE7B7)
//         : Colors.white70;

//     final Color backgroundColor = isPending
//         ? const Color(0xff2A2415)
//         : isCompleted
//         ? const Color(0xff18251F)
//         : Colors.white.withOpacity(.07);

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//       decoration: BoxDecoration(
//         color: backgroundColor,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: textColor.withOpacity(.18)),
//       ),
//       child: Text(
//         status.toUpperCase(),
//         style: GoogleFonts.outfit(
//           color: textColor,
//           fontSize: 8,
//           fontWeight: FontWeight.w700,
//           letterSpacing: .5,
//         ),
//       ),
//     );
//   }

//   // =============================================================
//   // IMAGE PLACEHOLDER
//   // =============================================================

//   Widget _imagePlaceholder() {
//     return Container(
//       width: 72,
//       height: 72,
//       color: const Color(0xff111516),
//       child: const Icon(Icons.image_outlined, color: Colors.white24, size: 25),
//     );
//   }

//   // =============================================================
//   // ERROR
//   // =============================================================

//   Widget _buildError() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: const Color(0xff191D1E),
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Text(
//         "Unable to load order items.",
//         textAlign: TextAlign.center,
//         style: GoogleFonts.outfit(color: Colors.white54, fontSize: 11),
//       ),
//     );
//   }

//   // =============================================================
//   // EMPTY ITEMS
//   // =============================================================

//   Widget _buildEmptyItems() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: const Color(0xff191D1E),
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Text(
//         "No items found for this order.",
//         textAlign: TextAlign.center,
//         style: GoogleFonts.outfit(color: Colors.white54, fontSize: 11),
//       ),
//     );
//   }

//   // =============================================================
//   // SMALL TEXT
//   // =============================================================

//   TextStyle _smallTextStyle() {
//     return GoogleFonts.outfit(color: Colors.white38, fontSize: 10);
//   }

//   // =============================================================
//   // SHORT ORDER ID
//   // =============================================================

//   String _shortOrderId(dynamic id) {
//     if (id == null) {
//       return "------";
//     }

//     final value = id.toString();

//     if (value.length <= 8) {
//       return value;
//     }

//     return value.substring(0, 8).toUpperCase();
//   }

//   // =============================================================
//   // FORMAT DATE
//   // =============================================================

//   String _formatDate(String date) {
//     if (date.isEmpty) {
//       return "";
//     }

//     try {
//       final parsed = DateTime.parse(date).toLocal();

//       return "${parsed.day.toString().padLeft(2, '0')}/"
//           "${parsed.month.toString().padLeft(2, '0')}/"
//           "${parsed.year}";
//     } catch (_) {
//       return date;
//     }
//   }
// }




import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_tokens.dart';
import '../../repositories/order_repository.dart';

class OrderDetailsScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  ConsumerState<OrderDetailsScreen> createState() =>
      _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends ConsumerState<OrderDetailsScreen> {
  final OrderRepository _repository = OrderRepository();

  List<Map<String, dynamic>> items = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadOrderItems();
  }

  Future<void> _loadOrderItems() async {
    try {
      final orderId = widget.order['id'].toString();
      final result = await _repository.getOrderItems(orderId);

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

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    final status = order['status']?.toString() ?? 'pending';
    final total =
        double.tryParse(order['total_amount']?.toString() ?? '0') ?? 0;

    return Scaffold(
      backgroundColor: AppTokens.background,
      appBar: AppBar(
        backgroundColor: AppTokens.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppTokens.textPrimary,
            size: 18,
          ),
        ),
        centerTitle: true,
        title: Text(
          'Order Details',
          style: AppTokens.pageTitle.copyWith(
            color: AppTokens.textPrimary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          AppTokens.gutter,
          AppTokens.s8,
          AppTokens.gutter,
          AppTokens.s32,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderHeader(order: order, status: status),
            const SizedBox(height: AppTokens.s24),

            _buildSectionTitle('Products'),
            const SizedBox(height: AppTokens.s12),

            if (isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(AppTokens.s32),
                  child: CircularProgressIndicator(
                    color: AppTokens.accent,
                    strokeWidth: 2,
                  ),
                ),
              )
            else if (error != null)
              _buildError()
            else if (items.isEmpty)
              _buildEmptyItems()
            else
              Column(
                children: items.map(_buildProductItem).toList(),
              ),

            const SizedBox(height: AppTokens.s20),

            _buildPriceSummary(order: order, total: total),
            const SizedBox(height: AppTokens.s20),

            _buildCustomerDetails(order),
            const SizedBox(height: AppTokens.s20),

            _buildDeliveryAddress(order),
          ],
        ),
      ),
    );
  }

  // ORDER HEADER

  Widget _buildOrderHeader({
    required Map<String, dynamic> order,
    required String status,
  }) {
    final createdAt = order['created_at']?.toString() ?? '';
    final isPending = status.toLowerCase() == 'pending';

    return Container(
      padding: const EdgeInsets.all(AppTokens.s20),
      decoration: BoxDecoration(
        color: AppTokens.surface,
        borderRadius: BorderRadius.circular(AppTokens.radiusSheet),
        border: Border.all(color: AppTokens.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: AppTokens.fill,
                  borderRadius: BorderRadius.circular(AppTokens.radiusLg),
                ),
                child: const Icon(
                  Icons.shopping_bag_outlined,
                  color: AppTokens.accent,
                  size: 23,
                ),
              ),
              const SizedBox(width: AppTokens.s12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order #${_shortOrderId(order['id'])}',
                      style: AppTokens.bodyStrong.copyWith(
                        color: AppTokens.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppTokens.s4),
                    Text(
                      'Placed on ${_formatDate(createdAt)}',
                      style: AppTokens.caption.copyWith(
                        color: AppTokens.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: AppTokens.s8),
              _statusBadge(status),
            ],
          ),

          const SizedBox(height: AppTokens.s20),

          const Divider(height: 1, color: AppTokens.border),

          const SizedBox(height: AppTokens.s16),

          Row(
            children: [
              Icon(
                isPending
                    ? Icons.schedule_rounded
                    : Icons.check_circle_outline_rounded,
                size: 17,
                color: isPending ? AppTokens.accent : AppTokens.success,
              ),
              const SizedBox(width: AppTokens.s8),
              Expanded(
                child: Text(
                  isPending
                      ? 'Your order is waiting for confirmation'
                      : 'Your order has been updated',
                  style: AppTokens.caption.copyWith(
                    color: AppTokens.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // PRODUCT ITEM

  Widget _buildProductItem(Map<String, dynamic> item) {
    final name = item['product_name']?.toString() ?? '';
    final image = item['image']?.toString() ?? '';
    final price = double.tryParse(item['price']?.toString() ?? '0') ?? 0;
    final quantity = int.tryParse(item['quantity']?.toString() ?? '0') ?? 0;
    final size = item['size']?.toString();
    final productColor = item['color']?.toString();
    final itemTotal = price * quantity;

    return Container(
      margin: const EdgeInsets.only(bottom: AppTokens.s12),
      padding: const EdgeInsets.all(AppTokens.s12),
      decoration: BoxDecoration(
        color: AppTokens.surface,
        borderRadius: BorderRadius.circular(AppTokens.radiusLg),
        border: Border.all(color: AppTokens.border),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppTokens.radiusMd),
            child: image.isNotEmpty
                ? Image.network(
                    image,
                    width: 72,
                    height: 72,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => _imagePlaceholder(),
                  )
                : _imagePlaceholder(),
          ),

          const SizedBox(width: AppTokens.s12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTokens.bodyStrong.copyWith(
                    color: AppTokens.textPrimary,
                  ),
                ),
                const SizedBox(height: AppTokens.s8),

                if (size != null && size.isNotEmpty)
                  Text('Size: $size', style: _smallTextStyle()),

                if (productColor != null && productColor.isNotEmpty)
                  Text('Color: $productColor', style: _smallTextStyle()),

                const SizedBox(height: AppTokens.s4),
                Text('Qty: $quantity', style: _smallTextStyle()),
              ],
            ),
          ),

          const SizedBox(width: AppTokens.s8),

          Text(
            '₹${itemTotal.toStringAsFixed(0)}',
            style: AppTokens.price.copyWith(
              color: AppTokens.accent,
            ),
          ),
        ],
      ),
    );
  }

  // PAYMENT SUMMARY

  Widget _buildPriceSummary({
    required Map<String, dynamic> order,
    required double total,
  }) {
    return _sectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Payment Summary'),
          const SizedBox(height: AppTokens.s16),
          _priceRow(
            'Total Amount',
            '₹${total.toStringAsFixed(0)}',
            isTotal: true,
          ),
        ],
      ),
    );
  }

  // CUSTOMER DETAILS

  Widget _buildCustomerDetails(Map<String, dynamic> order) {
    return _sectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Customer Details'),
          const SizedBox(height: AppTokens.s16),
          _detailRow(
            Icons.person_outline_rounded,
            order['customer_name']?.toString() ?? '',
          ),
          const SizedBox(height: AppTokens.s12),
          _detailRow(
            Icons.phone_outlined,
            order['customer_phone']?.toString() ?? '',
          ),
        ],
      ),
    );
  }

  // DELIVERY ADDRESS

  Widget _buildDeliveryAddress(Map<String, dynamic> order) {
    return _sectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Delivery Address'),
          const SizedBox(height: AppTokens.s16),
          _detailRow(
            Icons.home_outlined,
            order['address']?.toString() ?? '',
          ),
          const SizedBox(height: AppTokens.s12),
          _detailRow(
            Icons.location_on_outlined,
            '${order['city'] ?? ''}, ${order['state'] ?? ''}',
          ),
          const SizedBox(height: AppTokens.s12),
          _detailRow(
            Icons.pin_drop_outlined,
            'Pincode: ${order['pincode'] ?? ''}',
          ),
        ],
      ),
    );
  }

  // DETAIL ROW

  Widget _detailRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppTokens.textSecondary, size: 18),
        const SizedBox(width: AppTokens.s12),
        Expanded(
          child: Text(
            text,
            style: AppTokens.body.copyWith(
              color: AppTokens.textSecondary,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  // PRICE ROW

  Widget _priceRow(String title, String value, {bool isTotal = false}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: (isTotal ? AppTokens.bodyStrong : AppTokens.body).copyWith(
              color: isTotal
                  ? AppTokens.textPrimary
                  : AppTokens.textSecondary,
            ),
          ),
        ),
        const SizedBox(width: AppTokens.s12),
        Text(
          value,
          style: (isTotal ? AppTokens.price : AppTokens.bodyStrong).copyWith(
            color: isTotal ? AppTokens.accent : AppTokens.textPrimary,
          ),
        ),
      ],
    );
  }

  // SECTION CONTAINER

  Widget _sectionContainer({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppTokens.s16),
      decoration: BoxDecoration(
        color: AppTokens.surface,
        borderRadius: BorderRadius.circular(AppTokens.radiusLg),
        border: Border.all(color: AppTokens.border),
      ),
      child: child,
    );
  }

  // SECTION TITLE

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTokens.sectionTitle.copyWith(
        color: AppTokens.textPrimary,
      ),
    );
  }

  // STATUS BADGE

  Widget _statusBadge(String status) {
    final normalized = status.toLowerCase();
    final isPending = normalized == 'pending';
    final isCompleted = normalized == 'completed';

    final Color textColor = isPending
        ? AppTokens.accent
        : isCompleted
            ? AppTokens.success
            : AppTokens.textSecondary;

    final Color backgroundColor = isPending
        ? AppTokens.accent.withOpacity(0.10)
        : isCompleted
            ? AppTokens.success.withOpacity(0.10)
            : AppTokens.fill;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTokens.s12,
        vertical: AppTokens.s8,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: textColor.withOpacity(0.25)),
      ),
      child: Text(
        status.toUpperCase(),
        style: AppTokens.overline.copyWith(
          color: textColor,
          letterSpacing: 0.4,
        ),
      ),
    );
  }

  // IMAGE PLACEHOLDER

  Widget _imagePlaceholder() {
    return Container(
      width: 72,
      height: 72,
      color: AppTokens.fill,
      child: const Icon(
        Icons.image_outlined,
        color: AppTokens.textTertiary,
        size: 25,
      ),
    );
  }

  // ERROR

  Widget _buildError() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppTokens.s20),
      decoration: BoxDecoration(
        color: AppTokens.surface,
        borderRadius: BorderRadius.circular(AppTokens.radiusLg),
        border: Border.all(color: AppTokens.border),
      ),
      child: Text(
        'Unable to load order items.',
        textAlign: TextAlign.center,
        style: AppTokens.body.copyWith(
          color: AppTokens.textSecondary,
        ),
      ),
    );
  }

  // EMPTY ITEMS

  Widget _buildEmptyItems() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppTokens.s20),
      decoration: BoxDecoration(
        color: AppTokens.surface,
        borderRadius: BorderRadius.circular(AppTokens.radiusLg),
        border: Border.all(color: AppTokens.border),
      ),
      child: Text(
        'No items found for this order.',
        textAlign: TextAlign.center,
        style: AppTokens.body.copyWith(
          color: AppTokens.textSecondary,
        ),
      ),
    );
  }

  // SMALL TEXT

  TextStyle _smallTextStyle() {
    return AppTokens.caption.copyWith(
      color: AppTokens.textSecondary,
    );
  }

  // SHORT ORDER ID

  String _shortOrderId(dynamic id) {
    if (id == null) return '------';

    final value = id.toString();

    if (value.length <= 8) return value;

    return value.substring(0, 8).toUpperCase();
  }

  // FORMAT DATE

  String _formatDate(String date) {
    if (date.isEmpty) return '';

    try {
      final parsed = DateTime.parse(date).toLocal();

      return '${parsed.day.toString().padLeft(2, '0')}/'
          '${parsed.month.toString().padLeft(2, '0')}/'
          '${parsed.year}';
    } catch (_) {
      return date;
    }
  }
}


