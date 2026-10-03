import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoppee_world/admin/viewmodel/product_provider.dart';
import 'package:shoppee_world/admin/views/product/add_product_screen.dart';

class ViewProductsScreen extends ConsumerWidget {
  const ViewProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Products")),
      body: products.when(
        loading: () => const Center(child: CircularProgressIndicator()),

        error: (error, _) => Center(child: Text(error.toString())),

        data: (items) {
          if (items.isEmpty) {
            return const Center(child: Text("No products found"));
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 10),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final product = items[index];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          product.image,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 80,
                              height: 80,
                              color: Colors.grey.shade300,
                              child: const Icon(
                                Icons.image_not_supported,
                                size: 35,
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(width: 15),

                      // Product Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 6),

                            // Offer Price
                            Text(
                              "₹${product.offerPrice.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),

                            // Original Price
                            if (product.originalPrice > 0)
                              Text(
                                "₹${product.originalPrice.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),

                            const SizedBox(height: 5),

                            // Rating
                            Text(
                              "⭐ ${product.rating}",
                              style: const TextStyle(fontSize: 14),
                            ),

                            const SizedBox(height: 5),

                            // Stock
                            Text(
                              "Stock: ${product.stockQuantity}",
                              style: TextStyle(
                                fontSize: 13,
                                color: product.stockQuantity > 0
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            const SizedBox(height: 5),

                           
                            if (product.availableSizes.isNotEmpty)
                              Text(
                                "Sizes: ${product.availableSizes.join(', ')}",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),

                          
                            if (product.availableColors.isNotEmpty)
                              Text(
                                "Colors: ${product.availableColors.join(', ')}",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 5),

                      // Action Buttons
                      Column(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      AddProductScreen(product: product),
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit, color: Colors.blue),
                          ),

                          IconButton(
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text("Delete Product"),
                                  content: const Text(
                                    "Are you sure you want to delete this product?",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context, false);
                                      },
                                      child: const Text("Cancel"),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context, true);
                                      },
                                      child: const Text("Delete"),
                                    ),
                                  ],
                                ),
                              );

                              if (confirm != true) return;

                              final message = await ref
                                  .read(deleteProductProvider)
                                  .deleteProduct(product.id);

                              if (!context.mounted) return;

                              if (message != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(message),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );

                                return;
                              }

                              ref.invalidate(productsProvider);

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Product deleted successfully'),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );

                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Product Deleted"),
                                  ),
                                );
                              }
                            },
                            icon: const Icon(Icons.delete, color: Colors.red),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
