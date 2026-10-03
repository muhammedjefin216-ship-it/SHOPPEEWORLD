import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoppee_world/admin/viewmodel/catagory_provider.dart';
import 'package:shoppee_world/admin/views/catagory/add_category_screen.dart';

class ViewCategoryScreen extends ConsumerWidget {
  const ViewCategoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Categories"),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddCategoryScreen(),
            ),
          );

          if (result == true) {
            ref.invalidate(categoriesProvider);
          }
        },
      ),

      body: categories.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),

        error: (error, _) => Center(
          child: Text(
            error.toString(),
          ),
        ),

        data: (items) {
          if (items.isEmpty) {
            return const Center(
              child: Text("No Categories Found"),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final category = items[index];

              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(
                  bottom: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.black,
                    child: Text(
                      category.name[0].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  title: Text(
                    category.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // EDIT
                      IconButton(
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.blue,
                        ),
                        onPressed: () async {
                          final result =
                              await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  AddCategoryScreen(
                                category: category,
                              ),
                            ),
                          );

                          if (result == true) {
                            ref.invalidate(
                              categoriesProvider,
                            );
                          }
                        },
                      ),

                      // DELETE
                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () async {
                          final confirm =
                              await showDialog<bool>(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text(
                                "Delete Category",
                              ),
                              content: const Text(
                                "Are you sure you want to delete this category?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(
                                      context,
                                      false,
                                    );
                                  },
                                  child: const Text(
                                    "Cancel",
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(
                                      context,
                                      true,
                                    );
                                  },
                                  child: const Text(
                                    "Delete",
                                  ),
                                ),
                              ],
                            ),
                          );

                          if (confirm != true) {
                            return;
                          }

                          // DELETE CATEGORY
                          try {
                            await ref
                                .read(
                                  deleteCategoryProvider,
                                )
                                .deleteCategory(
                                  category.id,
                                );

                            ref.invalidate(
                              categoriesProvider,
                            );

                            if (!context.mounted) {
                              return;
                            }

                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Category Deleted",
                                ),
                              ),
                            );
                          } catch (e) {
                            if (!context.mounted) {
                              return;
                            }

                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Cannot delete this category because products are using it.",
                                ),
                                duration: Duration(
                                  seconds: 3,
                                ),
                              ),
                            );
                          }
                        },
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