import 'package:flutter/material.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Admin Dashboard",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [

            // Products
            _buildDashboardCard(
              context,
              icon: Icons.inventory_2_outlined,
              title: "Products",
              onTap: () {
                // Product management screen later
              },
            ),

            // Add Product
            _buildDashboardCard(
              context,
              icon: Icons.add_box_outlined,
              title: "Add Product",
              onTap: () {
                // Add product screen later
              },
            ),

            // Categories
            _buildDashboardCard(
              context,
              icon: Icons.category_outlined,
              title: "Categories",
              onTap: () {
                // Category management later
              },
            ),

            // Orders
            _buildDashboardCard(
              context,
              icon: Icons.shopping_bag_outlined,
              title: "Orders",
              onTap: () {
                // Orders screen later
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.grey.shade200,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: Colors.black87,
            ),

            const SizedBox(height: 12),

            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}