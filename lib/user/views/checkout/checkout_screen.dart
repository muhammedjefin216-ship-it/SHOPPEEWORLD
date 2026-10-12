// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_fonts/google_fonts.dart';

// import 'package:shoppee_world/user/core/services/whatsapp_service.dart';
// import 'package:shoppee_world/user/repositories/order_repository.dart';
// import 'package:shoppee_world/user/views/orders/order_success_screen.dart';
// import 'package:shoppee_world/user/widgets/checkout/whatsapp_order_button.dart';

// import '../../viewmodel/cart/cart_provider.dart';
// import '../../widgets/checkout/address_form.dart';
// import '../../widgets/checkout/checkout_order_summary.dart';

// class CheckoutScreen extends ConsumerStatefulWidget {
//   // ==========================================================
//   // SELECTED PRODUCT IMAGES
//   // ==========================================================

//   final List<String> selectedProductImages;

//   const CheckoutScreen({
//     super.key,
//     this.selectedProductImages = const [],
//   });

//   @override
//   ConsumerState<CheckoutScreen> createState() =>
//       _CheckoutScreenState();
// }

// class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
//   // ==========================================================
//   // CONTROLLERS
//   // ==========================================================

//   final nameController = TextEditingController();
//   final phoneController = TextEditingController();
//   final addressController = TextEditingController();
//   final placeController = TextEditingController();
//   final landmarkController = TextEditingController();
//   final stateController = TextEditingController();
//   final districtController = TextEditingController();
//   final pincodeController = TextEditingController();

//   // ==========================================================
//   // ORDER REPOSITORY
//   // ==========================================================

//   final OrderRepository _orderRepository = OrderRepository();

//   // ==========================================================
//   // DISPOSE
//   // ==========================================================

//   @override
//   void dispose() {
//     nameController.dispose();
//     phoneController.dispose();
//     addressController.dispose();
//     placeController.dispose();
//     landmarkController.dispose();
//     stateController.dispose();
//     districtController.dispose();
//     pincodeController.dispose();

//     super.dispose();
//   }

//   // ==========================================================
//   // BUILD
//   // ==========================================================

//   @override
//   Widget build(BuildContext context) {
//     // ========================================================
//     // CART DATA
//     // ========================================================

//     final cartItems = ref.watch(cartProvider);

//     final cartNotifier = ref.read(cartProvider.notifier);

//     final subtotal = cartNotifier.subtotal;

//     final deliveryCharge = cartNotifier.deliveryCharge;

//     final total = cartNotifier.total;

//     return Scaffold(
//       backgroundColor: const Color(0xff080C0D),

//       // ========================================================
//       // APP BAR
//       // ========================================================

//       appBar: AppBar(
//         backgroundColor: const Color(0xff080C0D),
//         surfaceTintColor: Colors.transparent,
//         elevation: 0,

//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: const Icon(
//             Icons.arrow_back_ios_new_rounded,
//             color: Colors.white,
//             size: 19,
//           ),
//         ),

//         centerTitle: true,

//         title: Text(
//           "",
//           style: GoogleFonts.outfit(
//             color: Colors.white,
//             fontSize: 18,
//             fontWeight: FontWeight.w700,
//           ),
//         ),
//       ),

//       // ========================================================
//       // BODY
//       // ========================================================

//       body: cartItems.isEmpty
//           ? Center(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const Icon(
//                     Icons.shopping_bag_outlined,
//                     color: Colors.white38,
//                     size: 45,
//                   ),
//                   const SizedBox(height: 12),
//                   Text(
//                     "Your cart is empty",
//                     style: GoogleFonts.outfit(
//                       color: Colors.white70,
//                       fontSize: 15,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ],
//               ),
//             )
//           : SingleChildScrollView(
//               physics: const BouncingScrollPhysics(),

//               padding: const EdgeInsets.fromLTRB(
//                 18,
//                 8,
//                 18,
//                 25,
//               ),

//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // =================================================
//                   // DELIVERY ADDRESS
//                   // =================================================

//                   AddressForm(
//                     nameController: nameController,
//                     phoneController: phoneController,
//                     addressController: addressController,
//                     placeController: placeController,
//                     landmarkController: landmarkController,
//                     stateController: stateController,
//                     districtController: districtController,
//                     pincodeController: pincodeController,
//                   ),

//                   const SizedBox(height: 28),

//                   // =================================================
//                   // ORDER SUMMARY TITLE
//                   // =================================================

//                   Text(
//                     "Order Summary",
//                     style: GoogleFonts.outfit(
//                       color: Colors.white,
//                       fontSize: 14,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),

//                   const SizedBox(height: 12),

//                   // =================================================
//                   // ORDER SUMMARY
//                   // =================================================

//                   CheckoutOrderSummary(
//                     subtotal: subtotal,
//                     deliveryCharge: deliveryCharge,
//                     total: total,
//                   ),

//                   const SizedBox(height: 25),

//                   // =================================================
//                   // WHATSAPP INFORMATION
//                   // =================================================

//                   Container(
//                     padding: const EdgeInsets.all(14),
//                     decoration: BoxDecoration(
//                       color: const Color(0xff191D1E),
//                       borderRadius: BorderRadius.circular(15),
//                       border: Border.all(
//                         color: Colors.white.withOpacity(.06),
//                       ),
//                     ),
//                     child: Row(
//                       crossAxisAlignment:
//                           CrossAxisAlignment.start,
//                       children: [
//                         Container(
//                           height: 38,
//                           width: 38,
//                           decoration: BoxDecoration(
//                             color: Colors.white.withOpacity(.08),
//                             shape: BoxShape.circle,
//                           ),
//                           child: const Icon(
//                             Icons.chat_outlined,
//                             color: Colors.white,
//                             size: 19,
//                           ),
//                         ),

//                         const SizedBox(width: 12),

//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment:
//                                 CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 "Order through WhatsApp",
//                                 style: GoogleFonts.outfit(
//                                   color: Colors.white,
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),

//                               const SizedBox(height: 4),

//                               Text(
//                                 "Your order details will be sent to us through WhatsApp for confirmation.",
//                                 style: GoogleFonts.outfit(
//                                   color: Colors.white38,
//                                   fontSize: 10,
//                                   height: 1.4,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   const SizedBox(height: 18),

//                   // =================================================
//                   // WHATSAPP ORDER BUTTON
//                   // =================================================

//                   WhatsAppOrderButton(
//                     onPressed: _placeOrder,
//                   ),

//                   const SizedBox(height: 8),

//                   Center(
//                     child: Text(
//                       "You'll be redirected to WhatsApp",
//                       style: GoogleFonts.outfit(
//                         color: Colors.white30,
//                         fontSize: 9,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }

//   // ==============================================================
//   // PLACE ORDER
//   // ==============================================================

//   Future<void> _placeOrder() async {
//     // ==========================================================
//     // GET CART
//     // ==========================================================

//     final cartItems = ref.read(cartProvider);

//     final cartNotifier = ref.read(cartProvider.notifier);

//     // ==========================================================
//     // VALIDATE ADDRESS
//     // ==========================================================

//     if (nameController.text.trim().isEmpty ||
//         phoneController.text.trim().isEmpty ||
//         addressController.text.trim().isEmpty ||
//         placeController.text.trim().isEmpty ||
//         landmarkController.text.trim().isEmpty ||
//         districtController.text.trim().isEmpty ||
//         stateController.text.trim().isEmpty ||
//         pincodeController.text.trim().isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           behavior: SnackBarBehavior.floating,
//           backgroundColor: const Color(0xff191D1E),
//           content: Text(
//             "Please fill in all delivery details",
//             style: GoogleFonts.outfit(
//               color: Colors.white,
//             ),
//           ),
//         ),
//       );

//       return;
//     }

//     // ==========================================================
//     // CHECK CART
//     // ==========================================================

//     if (cartItems.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           behavior: SnackBarBehavior.floating,
//           backgroundColor: const Color(0xff191D1E),
//           content: Text(
//             "Your cart is empty",
//             style: GoogleFonts.outfit(
//               color: Colors.white,
//             ),
//           ),
//         ),
//       );

//       return;
//     }

//     // ==========================================================
//     // SAVE ORDER ITEMS DATA
//     // ==========================================================

//     final orderItems = cartItems.map((item) {
//       return {
//         "product_id": item.product.id,
//         "product_name": item.product.name,
//         "price": item.product.price,
//         "quantity": item.quantity,
//         "size": item.selectedSize,
//         "color": item.selectedColor,
//         "image": item.product.image,
//       };
//     }).toList();

//     // ==========================================================
//     // WHATSAPP PRODUCTS DATA
//     // ==========================================================

//     final products = cartItems.map((item) {
//       return {
//         "name": item.product.name,
//         "price": item.product.price,
//         "quantity": item.quantity,
//         "size": item.selectedSize,
//         "color": item.selectedColor,
//       };
//     }).toList();

//     // ==========================================================
//     // DEBUG - SELECTED IMAGES
//     // ==========================================================

//     print(
//       "SELECTED PRODUCT IMAGES: "
//       "${widget.selectedProductImages}",
//     );

//     // ==========================================================
//     // SAVE ORDER + SEND WHATSAPP
//     // ==========================================================

//     try {
//       // --------------------------------------------------------
//       // 1. SAVE ORDER TO SUPABASE
//       // --------------------------------------------------------

//       await _orderRepository.createOrder(
//         customerName: nameController.text.trim(),
//         customerPhone: phoneController.text.trim(),
//         address: addressController.text.trim(),
//         place: placeController.text.trim(),
//         landmark: landmarkController.text.trim(),
//         district: districtController.text.trim(),
//         state: stateController.text.trim(),
//         pincode: pincodeController.text.trim(),
//         totalAmount: cartNotifier.total,
//         items: orderItems,
//       );

//       await WhatsAppService.sendOrder(
//         phoneNumber: "917592088952",

//         customerName: nameController.text.trim(),

//         customerPhone: phoneController.text.trim(),

//         address: addressController.text.trim(),

//         place: placeController.text.trim(),

//         landmark: landmarkController.text.trim(),

//         district: districtController.text.trim(),

//         state: stateController.text.trim(),

//         pincode: pincodeController.text.trim(),

//         products: products,

//         subtotal: cartNotifier.subtotal,

//         deliveryCharge: cartNotifier.deliveryCharge,

//         total: cartNotifier.total,

//         productImages: widget.selectedProductImages,

//       );

//       // --------------------------------------------------------
//       // 3. CHECK MOUNTED
//       // --------------------------------------------------------

//       if (!mounted) return;

//       // --------------------------------------------------------
//       // 4. CLEAR CART
//       // --------------------------------------------------------

//       ref.read(cartProvider.notifier).clearCart();

//       // --------------------------------------------------------
//       // 5. ORDER SUCCESS
//       // --------------------------------------------------------

//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (_) => const OrderSuccessScreen(),
//         ),
//       );
//     } catch (e, stackTrace) {
//       print("❌ ORDER ERROR: $e");
//       print("❌ STACK TRACE: $stackTrace");

//       if (!mounted) return;

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           behavior: SnackBarBehavior.floating,
//           backgroundColor: const Color(0xff191D1E),
//           content: Text(
//             "Error: $e",
//             style: GoogleFonts.outfit(
//               color: Colors.white,
//             ),
//           ),
//         ),
//       );
//     }
//   }
// }






import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shoppee_world/user/core/theme/app_tokens.dart';
import 'package:shoppee_world/user/core/services/whatsapp_service.dart';
import 'package:shoppee_world/user/repositories/order_repository.dart';
import 'package:shoppee_world/user/views/orders/order_success_screen.dart';
import 'package:shoppee_world/user/widgets/checkout/whatsapp_order_button.dart';
import '../../viewmodel/cart/cart_provider.dart';
import '../../widgets/checkout/address_form.dart';
import '../../widgets/checkout/checkout_order_summary.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  final List<String> selectedProductImages;

  const CheckoutScreen({
    super.key,
    this.selectedProductImages = const [],
  });

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final placeController = TextEditingController();
  final landmarkController = TextEditingController();
  final stateController = TextEditingController();
  final districtController = TextEditingController();
  final pincodeController = TextEditingController();

  final OrderRepository _orderRepository = OrderRepository();

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    placeController.dispose();
    landmarkController.dispose();
    stateController.dispose();
    districtController.dispose();
    pincodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);

    final subtotal = cartNotifier.subtotal;
    final deliveryCharge = cartNotifier.deliveryCharge;
    final total = cartNotifier.total;

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
            size: 22,
          ),
        ),
        title: Text(
          'Checkout',
          style:GoogleFonts.poppins(
            fontSize: 21,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: cartItems.isEmpty
          ? _buildEmptyCart()
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(
                AppTokens.gutter,
                AppTokens.s8,
                AppTokens.gutter,
                AppTokens.s24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AddressForm(
                    nameController: nameController,
                    phoneController: phoneController,
                    addressController: addressController,
                    placeController: placeController,
                    landmarkController: landmarkController,
                    stateController: stateController,
                    districtController: districtController,
                    pincodeController: pincodeController,
                  ),

                  const SizedBox(height: AppTokens.s24),

                  _buildSectionTitle('Order Summary'),

                  const SizedBox(height: AppTokens.s12),

                  CheckoutOrderSummary(
                    subtotal: subtotal,
                    deliveryCharge: deliveryCharge,
                    total: total,
                  ),

                  const SizedBox(height: AppTokens.s24),

                  Container(
                    padding: const EdgeInsets.all(AppTokens.s16),
                    decoration: BoxDecoration(
                      color: AppTokens.surface,
                      borderRadius: BorderRadius.circular(
                        AppTokens.radiusLg,
                      ),
                      border: Border.all(color: AppTokens.border),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 48,
                          width: 48,
                          decoration: BoxDecoration(
                            color: AppTokens.accent.withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.chat_outlined,
                            color: AppTokens.accent,
                            size: 24,
                          ),
                        ),

                        const SizedBox(width: AppTokens.s12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Order through WhatsApp',
                                style: AppTokens.bodyStrong.copyWith(
                                  color: AppTokens.textPrimary,
                                  fontSize: 19,
                                  fontWeight: FontWeight.w700,
                                  height: 1.35,
                                ),
                              ),

                              const SizedBox(height: AppTokens.s8),

                              Text(
                                'Your order details will be sent to us '
                                'through WhatsApp for confirmation.',
                                style: AppTokens.body.copyWith(
                                  color: AppTokens.textSecondary,
                                  fontSize: 16,
                                  height: 1.6,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppTokens.s20),

                  WhatsAppOrderButton(
                    onPressed: _placeOrder,
                  ),

                  const SizedBox(height: AppTokens.s12),

                  Center(
                    child: Text(
                      "You'll be redirected to WhatsApp",
                      textAlign: TextAlign.center,
                      style: AppTokens.caption.copyWith(
                        color: AppTokens.textTertiary,
                        fontSize: 15,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTokens.s24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 88,
              width: 88,
              decoration: BoxDecoration(
                color: AppTokens.surface,
                shape: BoxShape.circle,
                border: Border.all(color: AppTokens.border),
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                color: AppTokens.textSecondary,
                size: 42,
              ),
            ),

            const SizedBox(height: AppTokens.s16),

            Text(
              'Your cart is empty',
              textAlign: TextAlign.center,
              style: AppTokens.sectionTitle.copyWith(
                color: AppTokens.textPrimary,
                fontSize: 23,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTokens.sectionTitle.copyWith(
        color: AppTokens.textPrimary,
        fontSize: 23,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Future<void> _placeOrder() async {
    final cartItems = ref.read(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);

    if (nameController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty ||
        addressController.text.trim().isEmpty ||
        placeController.text.trim().isEmpty ||
        landmarkController.text.trim().isEmpty ||
        districtController.text.trim().isEmpty ||
        stateController.text.trim().isEmpty ||
        pincodeController.text.trim().isEmpty) {
      _showMessage('Please fill in all delivery details');
      return;
    }

    if (cartItems.isEmpty) {
      _showMessage('Your cart is empty');
      return;
    }

    final orderItems = cartItems.map((item) {
      return {
        'product_id': item.product.id,
        'product_name': item.product.name,
        'price': item.product.price,
        'quantity': item.quantity,
        'size': item.selectedSize,
        'color': item.selectedColor,
        'image': item.product.image,
      };
    }).toList();

    final products = cartItems.map((item) {
      return {
        'name': item.product.name,
        'price': item.product.price,
        'quantity': item.quantity,
        'size': item.selectedSize,
        'color': item.selectedColor,
      };
    }).toList();

    debugPrint(
      'SELECTED PRODUCT IMAGES: ${widget.selectedProductImages}',
    );

    try {
      await _orderRepository.createOrder(
        customerName: nameController.text.trim(),
        customerPhone: phoneController.text.trim(),
        address: addressController.text.trim(),
        place: placeController.text.trim(),
        landmark: landmarkController.text.trim(),
        district: districtController.text.trim(),
        state: stateController.text.trim(),
        pincode: pincodeController.text.trim(),
        totalAmount: cartNotifier.total,
        items: orderItems,
      );

      await WhatsAppService.sendOrder(
        phoneNumber: '917592088952',
        customerName: nameController.text.trim(),
        customerPhone: phoneController.text.trim(),
        address: addressController.text.trim(),
        place: placeController.text.trim(),
        landmark: landmarkController.text.trim(),
        district: districtController.text.trim(),
        state: stateController.text.trim(),
        pincode: pincodeController.text.trim(),
        products: products,
        subtotal: cartNotifier.subtotal,
        deliveryCharge: cartNotifier.deliveryCharge,
        total: cartNotifier.total,
        productImages: widget.selectedProductImages,
      );

      if (!mounted) return;

      ref.read(cartProvider.notifier).clearCart();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const OrderSuccessScreen(),
        ),
      );
    } catch (e, stackTrace) {
      debugPrint('ORDER ERROR: $e');
      debugPrint('STACK TRACE: $stackTrace');

      if (!mounted) return;

      _showMessage('Error: $e');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppTokens.surface,
        content: Text(
          message,
          style: AppTokens.body.copyWith(
            color: AppTokens.textPrimary,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

