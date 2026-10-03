import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shoppee_world/user/views/orders/order_details_screen.dart';

import '../../viewmodel/order/order_provider.dart';

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(myOrdersProvider);

    return Scaffold(
      backgroundColor: const Color(0xff080C0D),
      appBar: AppBar(
        backgroundColor: const Color(0xff080C0D),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 19,
          ),
        ),
        centerTitle: true,
        title: Text(
          "My Orders",
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: ordersAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ),

        error: (error, stack) => _buildError(),

        data: (orders) {
          if (orders.isEmpty) {
            return _buildEmpty();
          }

          return RefreshIndicator(
            color: Colors.black,
            backgroundColor: Colors.white,
            onRefresh: () async {
              ref.invalidate(myOrdersProvider);
              await ref.read(myOrdersProvider.future);
            },
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: const EdgeInsets.fromLTRB(18, 10, 18, 30),
              itemCount: orders.length,
              separatorBuilder: (_, _) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                return _OrderCard(
                  order: orders[index],
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 75,
              width: 75,
              decoration: BoxDecoration(
                color: const Color(0xff191D1E),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(.06),
                ),
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                color: Colors.white54,
                size: 32,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              "No Orders Yet",
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              "Your completed orders will appear here.",
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                color: Colors.white38,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: Colors.white38,
              size: 42,
            ),
            const SizedBox(height: 12),
            Text(
              "Unable to load orders",
              style: GoogleFonts.outfit(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final Map<String, dynamic> order;

  const _OrderCard({
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    final status = order['status']?.toString() ?? 'pending';

    final total = double.tryParse(
          order['total_amount']?.toString() ?? '0',
        ) ??
        0;

    final createdAt = order['created_at']?.toString() ?? '';

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xff191D1E),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withOpacity(.06),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.07),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.shopping_bag_outlined,
                  color: Colors.white,
                  size: 20,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Order #${_shortOrderId(order['id'])}",
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(createdAt),
                      style: GoogleFonts.outfit(
                        color: Colors.white38,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),

              _StatusBadge(status: status),
            ],
          ),

          const SizedBox(height: 15),

          Divider(
            height: 1,
            color: Colors.white.withOpacity(.07),
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Text(
                "Total Amount",
                style: GoogleFonts.outfit(
                  color: Colors.white54,
                  fontSize: 11,
                ),
              ),
              const Spacer(),
              Text(
                "₹${total.toStringAsFixed(0)}",
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                color: Colors.white38,
                size: 15,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  "${order['city'] ?? ''}, ${order['state'] ?? ''}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    color: Colors.white38,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

         SizedBox(
  width: double.infinity,
  height: 40,
  child: OutlinedButton(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OrderDetailsScreen(
            order: order,
          ),
        ),
      );
    },
    style: OutlinedButton.styleFrom(
      foregroundColor: Colors.white,
      side: BorderSide(
        color: Colors.white.withOpacity(.10),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(11),
      ),
    ),
    child: Text(
      "View Details",
      style: GoogleFonts.outfit(
        color: Colors.white,
        fontSize: 11,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
),
        ],
      ),
    );
  }

  String _shortOrderId(dynamic id) {
    if (id == null) return "------";

    final value = id.toString();

    if (value.length <= 8) {
      return value;
    }

    return value.substring(0, 8).toUpperCase();
  }

  String _formatDate(String date) {
    if (date.isEmpty) return "";

    try {
      final parsed = DateTime.parse(date).toLocal();

      return "${parsed.day.toString().padLeft(2, '0')}/"
          "${parsed.month.toString().padLeft(2, '0')}/"
          "${parsed.year}";
    } catch (_) {
      return date;
    }
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.07),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toUpperCase(),
        style: GoogleFonts.outfit(
          color: Colors.white70,
          fontSize: 8,
          fontWeight: FontWeight.w700,
          letterSpacing: .5,
        ),
      ),
    );
  }
}