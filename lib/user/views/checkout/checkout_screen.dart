import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:shoppee_world/user/core/services/whatsapp_service.dart';
import 'package:shoppee_world/user/repositories/order_repository.dart';
import 'package:shoppee_world/user/views/orders/order_success_screen.dart';
import 'package:shoppee_world/user/widgets/checkout/whatsapp_order_button.dart';

import '../../viewmodel/cart/cart_provider.dart';
import '../../widgets/checkout/address_form.dart';
import '../../widgets/checkout/checkout_order_summary.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({
    super.key,
  });

  @override
  ConsumerState<CheckoutScreen> createState() =>
      _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  // ==========================================================
  // CONTROLLERS
  // ==========================================================

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final pincodeController = TextEditingController();

  // ==========================================================
  // ORDER REPOSITORY
  // ==========================================================

  final OrderRepository _orderRepository = OrderRepository();

  // ==========================================================
  // DISPOSE
  // ==========================================================

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    cityController.dispose();
    stateController.dispose();
    pincodeController.dispose();

    super.dispose();
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    // ========================================================
    // CART DATA
    // ========================================================

    final cartItems = ref.watch(cartProvider);

    final cartNotifier = ref.read(cartProvider.notifier);

    final subtotal = cartNotifier.subtotal;

    final deliveryCharge = cartNotifier.deliveryCharge;

    final total = cartNotifier.total;

    return Scaffold(
      backgroundColor: const Color(0xff080C0D),

      // ========================================================
      // APP BAR
      // ========================================================

      appBar: AppBar(
        backgroundColor: const Color(0xff080C0D),
        surfaceTintColor: Colors.transparent,
        elevation: 0,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 19,
          ),
        ),

        centerTitle: true,

        title: Text(
          "Checkout",
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      // ========================================================
      // BODY
      // ========================================================

      body: cartItems.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.shopping_bag_outlined,
                    color: Colors.white38,
                    size: 45,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Your cart is empty",
                    style: GoogleFonts.outfit(
                      color: Colors.white70,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),

              padding: const EdgeInsets.fromLTRB(
                18,
                8,
                18,
                25,
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // =================================================
                  // DELIVERY ADDRESS
                  // =================================================

                  AddressForm(
                    nameController: nameController,
                    phoneController: phoneController,
                    addressController: addressController,
                    cityController: cityController,
                    stateController: stateController,
                    pincodeController: pincodeController,
                  ),

                  const SizedBox(height: 28),

                  // =================================================
                  // ORDER SUMMARY TITLE
                  // =================================================

                  Text(
                    "Order Summary",
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // =================================================
                  // ORDER SUMMARY
                  // =================================================

                  CheckoutOrderSummary(
                    subtotal: subtotal,
                    deliveryCharge: deliveryCharge,
                    total: total,
                  ),

                  const SizedBox(height: 25),

                  // =================================================
                  // WHATSAPP INFORMATION
                  // =================================================

                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xff191D1E),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Colors.white.withOpacity(.06),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 38,
                          width: 38,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.08),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.chat_outlined,
                            color: Colors.white,
                            size: 19,
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Order through WhatsApp",
                                style: GoogleFonts.outfit(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: 4),

                              Text(
                                "Your order details will be sent to us through WhatsApp for confirmation.",
                                style: GoogleFonts.outfit(
                                  color: Colors.white38,
                                  fontSize: 10,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // =================================================
                  // WHATSAPP ORDER BUTTON
                  // =================================================

                  WhatsAppOrderButton(
                    onPressed: _placeOrder,
                  ),

                  const SizedBox(height: 8),

                  Center(
                    child: Text(
                      "You'll be redirected to WhatsApp",
                      style: GoogleFonts.outfit(
                        color: Colors.white30,
                        fontSize: 9,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  // ==============================================================
  // PLACE ORDER
  // ==============================================================

  Future<void> _placeOrder() async {
    // ==========================================================
    // GET CART
    // ==========================================================

    final cartItems = ref.read(cartProvider);

    final cartNotifier = ref.read(cartProvider.notifier);

    // ==========================================================
    // VALIDATE ADDRESS
    // ==========================================================

    if (nameController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty ||
        addressController.text.trim().isEmpty ||
        cityController.text.trim().isEmpty ||
        stateController.text.trim().isEmpty ||
        pincodeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xff191D1E),
          content: Text(
            "Please fill in all delivery details",
            style: GoogleFonts.outfit(
              color: Colors.white,
            ),
          ),
        ),
      );

      return;
    }

    // ==========================================================
    // CHECK CART
    // ==========================================================

    if (cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xff191D1E),
          content: Text(
            "Your cart is empty",
            style: GoogleFonts.outfit(
              color: Colors.white,
            ),
          ),
        ),
      );

      return;
    }

    // ==========================================================
    // SAVE ORDER ITEMS DATA
    // ==========================================================

    final orderItems = cartItems.map((item) {
      return {
        "product_id": item.product.id,
        "product_name": item.product.name,
        "price": item.product.price,
        "quantity": item.quantity,
        "size": item.selectedSize,
        "color": item.selectedColor,
        "image": item.product.image,
      };
    }).toList();

    // ==========================================================
    // WHATSAPP PRODUCTS
    // ==========================================================

    final products = cartItems.map((item) {
      return {
        "name": item.product.name,
        "price": item.product.price,
        "quantity": item.quantity,
        "size": item.selectedSize,
        "color": item.selectedColor,
      };
    }).toList();

    // ==========================================================
    // SAVE ORDER + SEND WHATSAPP
    // ==========================================================

    try {
      // --------------------------------------------------------
      // 1. SAVE ORDER TO SUPABASE
      // --------------------------------------------------------

      await _orderRepository.createOrder(
        customerName: nameController.text.trim(),
        customerPhone: phoneController.text.trim(),
        address: addressController.text.trim(),
        city: cityController.text.trim(),
        state: stateController.text.trim(),
        pincode: pincodeController.text.trim(),
        totalAmount: cartNotifier.total,
        items: orderItems,
      );

      // --------------------------------------------------------
      // 2. SEND ORDER TO WHATSAPP
      // --------------------------------------------------------

      await WhatsAppService.sendOrder(
        phoneNumber: "917592088952",

        customerName: nameController.text.trim(),

        customerPhone: phoneController.text.trim(),

        address: addressController.text.trim(),

        city: cityController.text.trim(),

        state: stateController.text.trim(),

        pincode: pincodeController.text.trim(),

        products: products,

        subtotal: cartNotifier.subtotal,

        deliveryCharge: cartNotifier.deliveryCharge,

        total: cartNotifier.total,
      );

      if (!mounted) return;

      // --------------------------------------------------------
      // 3. CLEAR CART
      // --------------------------------------------------------

      ref.read(cartProvider.notifier).clearCart();

      // --------------------------------------------------------
      // 4. ORDER SUCCESS
      // --------------------------------------------------------

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const OrderSuccessScreen(),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xff191D1E),
          content: Text(
            "Could not place order. Please try again.",
            style: GoogleFonts.outfit(
              color: Colors.white,
            ),
          ),
        ),
      );
    }
  }
}