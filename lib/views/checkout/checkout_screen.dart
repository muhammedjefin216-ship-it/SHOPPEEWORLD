import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shoppee_world/core/services/whatsapp_service.dart';
import 'package:shoppee_world/views/orders/order_success_screen.dart';
import 'package:shoppee_world/widgets/checkout/whatsapp_order_button.dart';

import '../../viewmodel/cart/cart_provider.dart';
import '../../widgets/checkout/address_form.dart';
import '../../widgets/checkout/checkout_order_summary.dart';
import '../../widgets/common/custom_app_bar.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({
    super.key,
  });

  @override
  ConsumerState<CheckoutScreen> createState() =>
      _CheckoutScreenState();
}

class _CheckoutScreenState
    extends ConsumerState<CheckoutScreen> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final pincodeController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    // Get cart data from Riverpod
    final cartItems = ref.watch(cartProvider);

    final cartNotifier =
        ref.read(cartProvider.notifier);

    // Calculate actual prices
    final subtotal = cartNotifier.subtotal;

    final deliveryCharge =
        cartNotifier.deliveryCharge;

    final total =
        cartNotifier.total;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,

      appBar: const CustomAppBar(
        title: "Checkout",
      ),

      body: cartItems.isEmpty
          ? const Center(
              child: Text(
                "Your cart is empty",
              ),
            )
          : SingleChildScrollView(
              padding:
                  const EdgeInsets.all(20),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  // =================================================
                  // DELIVERY ADDRESS
                  // =================================================

                  AddressForm(
                    nameController:
                        nameController,

                    phoneController:
                        phoneController,

                    addressController:
                        addressController,

                    cityController:
                        cityController,

                    stateController:
                        stateController,

                    pincodeController:
                        pincodeController,
                  ),

                  const SizedBox(
                    height: 30,
                  ),

                  // =================================================
                  // ORDER SUMMARY TITLE
                  // =================================================

                  const Text(
                    "Order Summary",

                    style: TextStyle(
                      fontSize: 20,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 15,
                  ),

                  // =================================================
                  // ORDER SUMMARY
                  // =================================================

                  CheckoutOrderSummary(
                    subtotal: subtotal,

                    deliveryCharge:
                        deliveryCharge,

                    total: total,
                  ),

                  const SizedBox(
                    height: 30,
                  ),

                  // =================================================
                  // WHATSAPP BUTTON
                  // =================================================

                  WhatsAppOrderButton(
                    onPressed: _placeOrder,
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
    );
  }

  // ================================================================
  // PLACE ORDER
  // ================================================================

  Future<void> _placeOrder() async {
    // Get current cart
    final cartItems =
        ref.read(cartProvider);

    final cartNotifier =
        ref.read(cartProvider.notifier);

    // ==============================================================
    // VALIDATE ADDRESS
    // ==============================================================

    if (nameController.text
            .trim()
            .isEmpty ||
        phoneController.text
            .trim()
            .isEmpty ||
        addressController.text
            .trim()
            .isEmpty ||
        cityController.text
            .trim()
            .isEmpty ||
        stateController.text
            .trim()
            .isEmpty ||
        pincodeController.text
            .trim()
            .isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Please fill in all delivery details",
          ),
        ),
      );

      return;
    }

    // ==============================================================
    // CHECK CART
    // ==============================================================

    if (cartItems.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Your cart is empty",
          ),
        ),
      );

      return;
    }

    // ==============================================================
    // CONVERT CART ITEMS TO WHATSAPP PRODUCTS
    // ==============================================================

    final products =
        cartItems.map((item) {
      return {
        "name": item.product.name,

        "price": item.product.price,

        "quantity": item.quantity,

        "size": item.selectedSize,

        "color": item.selectedColor,
      };
    }).toList();

    // ==============================================================
    // SEND ORDER TO WHATSAPP
    // ==============================================================

    try {
      await WhatsAppService.sendOrder(
        // Your shop WhatsApp number
        phoneNumber: "917592088952",

        // Customer details
        customerName:
            nameController.text.trim(),

        customerPhone:
            phoneController.text.trim(),

        address:
            addressController.text.trim(),

        city:
            cityController.text.trim(),

        state:
            stateController.text.trim(),

        pincode:
            pincodeController.text.trim(),

        // Actual cart products
        products: products,

        // Actual prices
        subtotal:
            cartNotifier.subtotal,

        deliveryCharge:
            cartNotifier.deliveryCharge,

        total:
            cartNotifier.total,
      );

      if (!mounted) return;

     ref.read(cartProvider.notifier).clearCart();
      Navigator.pushReplacement(
        context,

        MaterialPageRoute(
          builder: (_) =>
              const OrderSuccessScreen(),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Could not open WhatsApp",
          ),
        ),
      );
    }
  }
}