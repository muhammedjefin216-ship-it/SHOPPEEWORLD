import 'package:flutter/material.dart';
import 'package:shoppee_world/user/views/cart/cart_screen.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // SW Logo
        SizedBox(
         height: 68,
width: 88,
          child: Image.asset(
            'assets/images/sw_logo.png',
            fit: BoxFit.contain,
          ),
        ),

        const SizedBox(width: 2),

        // App Name
        const Expanded(
          child: Text(
            "Shoppee World",
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
          ),
        ),

        // Cart
        IconButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CartScreen(),
      ),
    );
  },
  padding: EdgeInsets.zero,
  constraints: const BoxConstraints(
    minWidth: 35,
    minHeight: 35,
  ),
  icon: const Icon(
    Icons.shopping_cart_outlined,
    color: Colors.white,
    size: 25,
  ),
),
      ],
    );
  }
}