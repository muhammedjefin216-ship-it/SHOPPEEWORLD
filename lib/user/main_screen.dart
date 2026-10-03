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

  final List<Widget> screens = const [
    HomeScreen(),
    SearchScreen(),
    WishlistScreen(),
    OrdersScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(cartProvider.notifier).loadCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff080C0D),

      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),

      bottomNavigationBar: Container(
        height: 62,
        decoration: const BoxDecoration(
          color: Color(0xff191D1E),
        ),
        child: NavigationBar(
          height: 62,
          backgroundColor: const Color(0xff191D1E),
          elevation: 0,

          selectedIndex: currentIndex,

          onDestinationSelected: (index) {
            setState(() {
              currentIndex = index;
            });
          },

          indicatorColor: Colors.white,

          destinations: const [
            NavigationDestination(
              icon: Icon(
                Icons.home_outlined,
                color: Colors.white54,
                size: 21,
              ),
              selectedIcon: Icon(
                Icons.home,
                color: Colors.black,
                size: 21,
              ),
              label: 'Home',
            ),

            NavigationDestination(
              icon: Icon(
                Icons.search,
                color: Colors.white54,
                size: 21,
              ),
              selectedIcon: Icon(
                Icons.search,
                color: Colors.black,
                size: 21,
              ),
              label: 'Search',
            ),

            NavigationDestination(
              icon: Icon(
                Icons.favorite_border,
                color: Colors.white54,
                size: 21,
              ),
              selectedIcon: Icon(
                Icons.favorite,
                color: Colors.black,
                size: 21,
              ),
              label: 'Wishlist',
            ),

            NavigationDestination(
              icon: Icon(
                Icons.receipt_long_outlined,
                color: Colors.white54,
                size: 21,
              ),
              selectedIcon: Icon(
                Icons.receipt_long,
                color: Colors.black,
                size: 21,
              ),
              label: 'Orders',
            ),

            NavigationDestination(
              icon: Icon(
                Icons.person_outline,
                color: Colors.white54,
                size: 21,
              ),
              selectedIcon: Icon(
                Icons.person,
                color: Colors.black,
                size: 21,
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}