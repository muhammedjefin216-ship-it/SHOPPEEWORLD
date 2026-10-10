import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shoppee_world/user/core/theme/app_tokens.dart';
import 'package:shoppee_world/user/viewmodel/order/order_provider.dart';
import 'package:shoppee_world/user/views/orders/order_details_screen.dart';

class OrdersScreen extends ConsumerStatefulWidget {
  final VoidCallback onBack;

  const OrdersScreen({
    super.key,
    required this.onBack,
  });

  @override
  ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen> {
  bool _isClearing = false;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.invalidate(myOrdersProvider);
    });
  }

  Future<void> _refreshOrders() async {
    ref.invalidate(myOrdersProvider);
    await ref.read(myOrdersProvider.future);
  }

  // CLEAR ALL ORDERS

  Future<void> _clearAllOrders() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppTokens.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppTokens.radiusSheet,
            ),
            side: const BorderSide(color: AppTokens.border),
          ),
          title: Text(
            'Clear Order History?',
            style: AppTokens.sectionTitle,
          ),
          content: Text(
            'All your orders will be removed from your order history. '
            'Your orders will still be safely stored in our system.',
            style: AppTokens.body,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                'Cancel',
                style: AppTokens.body.copyWith(
                  color: AppTokens.textSecondary,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(
                'Clear All',
                style: AppTokens.bodyStrong.copyWith(
                  color: AppTokens.danger,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    setState(() {
      _isClearing = true;
    });

    try {
      final repository = ref.read(orderRepositoryProvider);

      await repository.clearOrderHistory();
      ref.invalidate(myOrdersProvider);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order history cleared'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to clear order history: $e'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isClearing = false;
        });
      }
    }
  }

  // HIDE SINGLE ORDER

  Future<void> _hideOrder(String orderId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppTokens.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppTokens.radiusSheet,
            ),
            side: const BorderSide(color: AppTokens.border),
          ),
          title: Text(
            'Hide Order?',
            style: AppTokens.sectionTitle,
          ),
          content: Text(
            'This order will be removed from your order history.',
            style: AppTokens.body,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                'Cancel',
                style: AppTokens.body.copyWith(
                  color: AppTokens.textSecondary,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(
                'Hide',
                style: AppTokens.bodyStrong.copyWith(
                  color: AppTokens.danger,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    try {
      final repository = ref.read(orderRepositoryProvider);

      await repository.hideOrder(orderId);
      ref.invalidate(myOrdersProvider);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order removed from history'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to hide order: $e'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ordersAsync = ref.watch(myOrdersProvider);

    return Scaffold(
      backgroundColor: AppTokens.background,
      appBar: AppBar(
        backgroundColor: AppTokens.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: widget.onBack,
          tooltip: 'Go back',
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppTokens.textPrimary,
            size: 19,
          ),
        ),
        title: Text(
          'My Orders',
          style: AppTokens.headline.copyWith(
            fontSize: 21,
          ),
        ),
        centerTitle: true,
        actions: [
          if (!_isClearing)
            ordersAsync.maybeWhen(
              data: (orders) {
                if (orders.isEmpty) {
                  return const SizedBox.shrink();
                }

                return IconButton(
                  onPressed: _clearAllOrders,
                  tooltip: 'Clear order history',
                  icon: const Icon(
                    Icons.delete_sweep_outlined,
                    color: AppTokens.textSecondary,
                  ),
                );
              },
              orElse: () => const SizedBox.shrink(),
            ),
          if (_isClearing)
            const Padding(
              padding: EdgeInsets.all(AppTokens.s16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppTokens.accent,
                ),
              ),
            ),
        ],
      ),
      body: ordersAsync.when(
        // LOADING

        loading: () {
          return const Center(
            child: CircularProgressIndicator(
              color: AppTokens.accent,
              strokeWidth: 2.5,
            ),
          );
        },

        // ERROR

        error: (error, stackTrace) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(AppTokens.s24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _StateIcon(
                    icon: Icons.error_outline_rounded,
                    color: AppTokens.danger,
                  ),
                  const SizedBox(height: AppTokens.s20),
                  Text(
                    'Something went wrong',
                    textAlign: TextAlign.center,
                    style: AppTokens.sectionTitle,
                  ),
                  const SizedBox(height: AppTokens.s8),
                  Text(
                    error.toString(),
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: AppTokens.caption.copyWith(
                      color: AppTokens.textTertiary,
                    ),
                  ),
                  const SizedBox(height: AppTokens.s24),
                  ElevatedButton(
                    onPressed: _refreshOrders,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTokens.accent,
                      foregroundColor: AppTokens.onAccent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppTokens.radiusButton,
                        ),
                      ),
                    ),
                    child: Text(
                      'Try Again',
                      style: AppTokens.button.copyWith(
                        color: AppTokens.onAccent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },

        // DATA

        data: (orders) {
          if (orders.isEmpty) {
            return RefreshIndicator(
              onRefresh: _refreshOrders,
              color: AppTokens.onAccent,
              backgroundColor: AppTokens.accent,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                children: [
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.2,
                  ),
                  _EmptyOrders(
                    onExplore: widget.onBack,
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refreshOrders,
            color: AppTokens.onAccent,
            backgroundColor: AppTokens.accent,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: const EdgeInsets.fromLTRB(
                AppTokens.gutter,
                AppTokens.s8,
                AppTokens.gutter,
                AppTokens.s32,
              ),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];

                return _OrderCard(
                  order: order,
                  onHide: () {
                    _hideOrder(order['id'].toString());
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// STATE ICON

class _StateIcon extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _StateIcon({
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 78,
      width: 78,
      decoration: BoxDecoration(
        color: AppTokens.surface,
        shape: BoxShape.circle,
        border: Border.all(color: AppTokens.border),
      ),
      child: Icon(
        icon,
        color: color,
        size: 36,
      ),
    );
  }
}

// EMPTY ORDERS

class _EmptyOrders extends StatelessWidget {
  final VoidCallback onExplore;

  const _EmptyOrders({
    required this.onExplore,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTokens.s24,
      ),
      child: Column(
        children: [
          Container(
            height: 112,
            width: 112,
            decoration: BoxDecoration(
              color: AppTokens.surface,
              shape: BoxShape.circle,
              border: Border.all(color: AppTokens.border),
            ),
            child: const Icon(
              Icons.shopping_bag_outlined,
              color: AppTokens.accent,
              size: 48,
            ),
          ),
          const SizedBox(height: AppTokens.s24),
          Text(
            'No orders yet',
            style: AppTokens.headline.copyWith(
              fontSize: 22,
            ),
          ),
          const SizedBox(height: AppTokens.s8),
          Text(
            'Your orders will appear here\nonce you make a purchase.',
            textAlign: TextAlign.center,
            style: AppTokens.body,
          ),
          const SizedBox(height: AppTokens.s24),
          ElevatedButton(
            onPressed: onExplore,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTokens.accent,
              foregroundColor: AppTokens.onAccent,
              elevation: 0,
              padding: const EdgeInsets.symmetric(
                horizontal: AppTokens.s24,
                vertical: AppTokens.s16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  AppTokens.radiusButton,
                ),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Explore Products',
                  style: AppTokens.button.copyWith(
                    color: AppTokens.onAccent,
                  ),
                ),
                const SizedBox(width: AppTokens.s8),
                const Icon(
                  Icons.arrow_forward_rounded,
                  size: 18,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ORDER CARD

class _OrderCard extends StatelessWidget {
  final Map<String, dynamic> order;
  final VoidCallback onHide;

  const _OrderCard({
    required this.order,
    required this.onHide,
  });

  @override
  Widget build(BuildContext context) {
    final orderId = order['id']?.toString() ?? '';
    final status = order['status']?.toString() ?? 'pending';
    final totalAmount = order['total_amount']?.toString() ?? '0';
    final customerName = order['customer_name']?.toString() ?? '';
    final createdAt = order['created_at']?.toString() ?? '';

    final statusColor = _statusColor(status);

    return Container(
      margin: const EdgeInsets.only(
        bottom: AppTokens.s16,
      ),
      padding: const EdgeInsets.all(AppTokens.s16),
      decoration: BoxDecoration(
        color: AppTokens.surface,
        borderRadius: BorderRadius.circular(
          AppTokens.radiusSheet,
        ),
        border: Border.all(
          color: AppTokens.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ORDER ID AND STATUS

          Row(
            children: [
              Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  color: AppTokens.background,
                  borderRadius: BorderRadius.circular(
                    AppTokens.radiusMd,
                  ),
                ),
                child: const Icon(
                  Icons.shopping_bag_outlined,
                  color: AppTokens.accent,
                  size: 22,
                ),
              ),
              const SizedBox(width: AppTokens.s12),
              Expanded(
                child: Text(
                  'Order #$orderId',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTokens.bodyStrong.copyWith(
                    color: AppTokens.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: AppTokens.s8),
              IconButton(
                onPressed: onHide,
                tooltip: 'Hide order',
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 32,
                  minHeight: 32,
                ),
                icon: const Icon(
                  Icons.more_vert_rounded,
                  color: AppTokens.textSecondary,
                  size: 21,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppTokens.s12),

          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTokens.s12,
                vertical: AppTokens.s8,
              ),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(
                  AppTokens.radiusSm,
                ),
                border: Border.all(
                  color: statusColor.withOpacity(0.25),
                ),
              ),
              child: Text(
                status.toUpperCase(),
                style: AppTokens.overline.copyWith(
                  color: statusColor,
                  fontSize: 10,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),

          const SizedBox(height: AppTokens.s16),

          if (customerName.isNotEmpty) ...[
            Text(
              customerName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTokens.bodyStrong,
            ),
            const SizedBox(height: AppTokens.s12),
          ],

          // ORDER TOTAL

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTokens.s12,
              vertical: AppTokens.s12,
            ),
            decoration: BoxDecoration(
              color: AppTokens.background,
              borderRadius: BorderRadius.circular(
                AppTokens.radiusMd,
              ),
            ),
            child: Row(
              children: [
                Text(
                  'Total amount',
                  style: AppTokens.body,
                ),
                const Spacer(),
                Flexible(
                  child: Text(
                    '₹$totalAmount',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style: AppTokens.bodyStrong.copyWith(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),

          if (createdAt.isNotEmpty) ...[
            const SizedBox(height: AppTokens.s12),
            Row(
              children: [
                const Icon(
                  Icons.schedule_rounded,
                  color: AppTokens.textTertiary,
                  size: 15,
                ),
                const SizedBox(width: AppTokens.s8),
                Expanded(
                  child: Text(
                    createdAt,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTokens.caption.copyWith(
                      color: AppTokens.textTertiary,
                    ),
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: AppTokens.s16),

          // VIEW DETAILS

          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () async {
                final updated = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => OrderDetailsScreen(
                      order: order,
                    ),
                  ),
                );

                if (updated == true) {
                  // Preserve the existing return behavior.
                }
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTokens.accent,
                side: const BorderSide(
                  color: AppTokens.borderStrong,
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: AppTokens.s12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    AppTokens.radiusButton,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'View Details',
                    style: AppTokens.button.copyWith(
                      color: AppTokens.accent,
                    ),
                  ),
                  const SizedBox(width: AppTokens.s8),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    size: 17,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return const Color(0xFF65A9FF);
      case 'processing':
        return const Color(0xFFFFB454);
      case 'shipped':
        return const Color(0xFFB69CFF);
      case 'delivered':
        return AppTokens.success;
      case 'cancelled':
      case 'canceled':
        return AppTokens.danger;
      case 'pending':
      default:
        return AppTokens.accent;
    }
  }
}

