// import 'package:flutter/material.dart';
// import 'package:shoppee_world/user/views/orders/order_screen.dart';

// class OrderSuccessScreen extends StatelessWidget {
//   const OrderSuccessScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             children: [
//               const Spacer(),
//               Container(
//                 height: 100,
//                 width: 100,
//                 decoration: const BoxDecoration(
//                   color: Colors.black,
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(Icons.check, color: Colors.white, size: 55),
//               ),

//               const SizedBox(height: 30),

//               const Text(
//                 "Order Request Sent!",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
//               ),

//               const SizedBox(height: 15),

//               // =====================================================
//               // DESCRIPTION
//               // =====================================================
//               Text(
//                 "Your order details have been shared "
//                 "with our store through WhatsApp.",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 15,
//                   color: Colors.grey.shade600,
//                   height: 1.5,
//                 ),
//               ),

//               const SizedBox(height: 10),

//               Text(
//                 "Our team will contact you shortly "
//                 "to confirm your order.",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 15,
//                   color: Colors.grey.shade600,
//                   height: 1.5,
//                 ),
//               ),

//               const Spacer(),

//               // =====================================================
//               // CONTINUE SHOPPING
//               // =====================================================
//               SizedBox(
//                 width: double.infinity,
//                 height: 58,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     Navigator.popUntil(context, (route) => route.isFirst);
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.black,
//                     foregroundColor: Colors.white,
//                     elevation: 0,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                   ),
//                   child: const Text(
//                     "Continue Shopping",
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 15),

//               // =====================================================
//               // VIEW ORDERS
//               // =====================================================
//               SizedBox(
//                 width: double.infinity,
//                 height: 58,
//                 child: OutlinedButton(
//                   onPressed: () {
//                     Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => OrdersScreen(
//                           onBack: () {
//                             Navigator.pop(context);
//                           },
//                         ),
//                       ),
//                     );
//                   },
//                   style: OutlinedButton.styleFrom(
//                     foregroundColor: Colors.black,
//                     side: const BorderSide(color: Colors.black),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                   ),
//                   child: const Text(
//                     "View My Orders",
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 30),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:shoppee_world/user/core/theme/app_tokens.dart';
import 'package:shoppee_world/user/views/orders/order_screen.dart';

class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTokens.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppTokens.s24),
          child: Column(
            children: [
              const Spacer(),

              // SUCCESS ICON
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  color: AppTokens.accent.withOpacity(0.12),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTokens.accent.withOpacity(0.35),
                    width: 1.5,
                  ),
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: AppTokens.accent,
                  size: 55,
                ),
              ),

              const SizedBox(height: AppTokens.s32),

              // TITLE
              Text(
                'Order Request Sent!',
                textAlign: TextAlign.center,
                style: AppTokens.headline.copyWith(
                  color: AppTokens.textPrimary,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: AppTokens.s16),

              // DESCRIPTION
              Text(
                'Your order details have been shared '
                'with our store through WhatsApp.',
                textAlign: TextAlign.center,
                style: AppTokens.body.copyWith(
                  color: AppTokens.textSecondary,
                  height: 1.6,
                ),
              ),

              const SizedBox(height: AppTokens.s12),

              Text(
                'Our team will contact you shortly '
                'to confirm your order.',
                textAlign: TextAlign.center,
                style: AppTokens.body.copyWith(
                  color: AppTokens.textSecondary,
                  height: 1.6,
                ),
              ),

              const Spacer(),

              // CONTINUE SHOPPING
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
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
                    'Continue Shopping',
                    style: AppTokens.button.copyWith(
                      color: AppTokens.onAccent,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppTokens.s12),

              // VIEW ORDERS
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OrdersScreen(
                          onBack: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTokens.textPrimary,
                    side: const BorderSide(
                      color: AppTokens.borderStrong,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppTokens.radiusButton,
                      ),
                    ),
                  ),
                  child: Text(
                    'View My Orders',
                    style: AppTokens.button.copyWith(
                      color: AppTokens.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppTokens.s24),
            ],
          ),
        ),
      ),
    );
  }
}

