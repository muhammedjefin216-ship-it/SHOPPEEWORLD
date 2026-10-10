import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoppee_world/user/viewmodel/cart/cart_provider.dart';

import 'package:shoppee_world/user/views/home/home_screen.dart';
import 'package:shoppee_world/user/views/orders/order_screen.dart';
import 'package:shoppee_world/user/views/search/search_screen.dart';
import 'package:shoppee_world/user/views/wishlist/wishlist_screen.dart';
import 'package:shoppee_world/user/views/profile/profile_screen.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int currentIndex = 0;

  late final List<Widget> screens;

  @override
  void initState() {
    super.initState();

    screens = [
      const HomeScreen(),

      const SearchScreen(),

      const WishlistScreen(),

      OrdersScreen(
  onBack: () {
    if (!mounted) return;

    setState(() {
      currentIndex = 0;
    });
  },
),

      const ProfileScreen(),
    ];

    Future.microtask(() {
      ref.read(cartProvider.notifier).loadCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,

        onDestinationSelected: (index) {
          setState(() {
            currentIndex = index;
          });
        },

        backgroundColor: const Color(0xFF080C0D),

        indicatorColor: const Color(0xFF191D1E),

        destinations: const [
          // =========================================================
          // HOME
          // =========================================================

          NavigationDestination(
            icon: Icon(
              Icons.home_outlined,
              color: Colors.white70,
            ),
            selectedIcon: Icon(
              Icons.home,
              color: Colors.white,
            ),
            label: 'Home',
          ),

          // =========================================================
          // SEARCH
          // =========================================================

          NavigationDestination(
            icon: Icon(
              Icons.search_outlined,
              color: Colors.white70,
            ),
            selectedIcon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            label: 'Search',
          ),

          // =========================================================
          // WISHLIST
          // =========================================================

          NavigationDestination(
            icon: Icon(
              Icons.favorite_border,
              color: Colors.white70,
            ),
            selectedIcon: Icon(
              Icons.favorite,
              color: Colors.white,
            ),
            label: 'Wishlist',
          ),

          // =========================================================
          // ORDERS
          // =========================================================

          NavigationDestination(
            icon: Icon(
              Icons.shopping_bag_outlined,
              color: Colors.white70,
            ),
            selectedIcon: Icon(
              Icons.shopping_bag,
              color: Colors.white,
            ),
            label: 'Orders',
          ),

          // =========================================================
          // PROFILE
          // =========================================================

          NavigationDestination(
            icon: Icon(
              Icons.person_outline,
              color: Colors.white70,
            ),
            selectedIcon: Icon(
              Icons.person,
              color: Colors.white,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}