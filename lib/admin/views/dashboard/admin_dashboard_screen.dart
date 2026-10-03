import 'package:flutter/material.dart';
import 'package:shoppee_world/admin/views/catagory/view_category_screen.dart';
import 'package:shoppee_world/admin/views/orders/admin_orders_screen.dart';
import 'package:shoppee_world/admin/views/product/add_product_screen.dart';
import 'package:shoppee_world/admin/views/product/view_products_screen.dart';
import 'package:shoppee_world/user/views/auth/login/login_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(251, 253, 252, 255),

      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        foregroundColor: const Color.fromARGB(255, 214, 217, 11),
        title: const Text(
          "Admin Dashboard",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(18),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 18,
          mainAxisSpacing: 18,

          // Give each card enough height.
          childAspectRatio: 0.72,

          children: [
            _dashboardCard(
              context,
              icon: Icons.inventory_2_outlined,
              title: "Products",
              subtitle: "View / Edit / Delete",
              color: Colors.blue,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ViewProductsScreen()),
                );
              },
            ),

            _dashboardCard(
              context,
              icon: Icons.add_box_outlined,
              title: "Add Product",
              subtitle: "Create new product",
              color: Colors.green,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddProductScreen()),
                );
              },
            ),

            _dashboardCard(
              context,
              icon: Icons.category_outlined,
              title: "Categories",
              subtitle: "Manage categories",
              color: Colors.orange,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ViewCategoryScreen()),
                );
              },
            ),

            _dashboardCard(
              context,
              icon: Icons.shopping_bag_outlined,
              title: "Orders",
              subtitle: "View / Manage Orders",
              color: Colors.deepPurple,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AdminOrdersScreen()),
                );
              },
            ),

            _dashboardCard(
              context,
              icon: Icons.logout,
              title: "Logout",
              subtitle: "Exit Admin",
              color: Colors.red,
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _dashboardCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(.15),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: color.withOpacity(.12),
              child: Icon(icon, color: color, size: 28),
            ),

            const SizedBox(height: 14),

            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),

            const SizedBox(height: 6),

            Text(
              subtitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),

            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [Icon(Icons.arrow_forward_ios, size: 18, color: color)],
            ),
          ],
        ),
      ),
    );
  }
}
