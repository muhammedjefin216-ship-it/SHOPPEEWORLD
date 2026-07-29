import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shoppee_world/admin/models/catagory/category_provider.dart';

// import '../../admin/repositories/product_repository.dart';
// import '../../admin/services/storage_service.dart';
// import '../../viewmodel/category/category_provider.dart';

class AddProductScreen extends ConsumerStatefulWidget {
  const AddProductScreen({super.key});

  @override
  ConsumerState<AddProductScreen> createState() =>
      _AddProductScreenState();
}

class _AddProductScreenState
    extends ConsumerState<AddProductScreen> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final ratingController = TextEditingController();

  final ImagePicker _imagePicker = ImagePicker();

  // final ProductRepository _productRepository =
  //     ProductRepository();

  // final StorageService _storageService =
  //     StorageService();

  int? selectedCategoryId;

  XFile? selectedImage;
  Uint8List? selectedImageBytes;

  bool isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    ratingController.dispose();

    super.dispose();
  }

  // ============================================================
  // PICK IMAGE
  // ============================================================

  Future<void> _pickImage() async {
    final XFile? image =
        await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (image == null) {
      return;
    }

    final bytes = await image.readAsBytes();

    setState(() {
      selectedImage = image;
      selectedImageBytes = bytes;
    });
  }

  // ============================================================
  // ADD PRODUCT
  // ============================================================

  Future<void> _addProduct() async {
    // ------------------------------------------------------------
    // VALIDATION
    // ------------------------------------------------------------

    final name =
        nameController.text.trim();

    final priceText =
        priceController.text.trim();

    final ratingText =
        ratingController.text.trim();

    if (name.isEmpty ||
        priceText.isEmpty ||
        ratingText.isEmpty ||
        selectedCategoryId == null ||
        selectedImageBytes == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Please fill all fields and select an image",
          ),
        ),
      );

      return;
    }

    final price =
        double.tryParse(priceText);

    final rating =
        double.tryParse(ratingText);

    if (price == null ||
        rating == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Please enter valid price and rating",
          ),
        ),
      );

      return;
    }

    // ------------------------------------------------------------
    // START LOADING
    // ------------------------------------------------------------

    setState(() {
      isLoading = true;
    });

    try {
      // ----------------------------------------------------------
      // 1. UPLOAD IMAGE
      // ----------------------------------------------------------

      // final imageUrl =
      //     await _storageService
      //         .uploadProductImage(
      //   imageBytes:
      //       selectedImageBytes!,
      //   fileName:
      //       selectedImage!.name,
      // );

      // ----------------------------------------------------------
      // 2. INSERT PRODUCT
      // ----------------------------------------------------------

      // await _productRepository
      //     .addProduct(
      //   name: name,
      //   image: imageUrl,
      //   price: price,
      //   rating: rating,
      //   categoryId:
      //       selectedCategoryId!,
      // );

      if (!mounted) return;

      // ----------------------------------------------------------
      // SUCCESS
      // ----------------------------------------------------------

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Product added successfully!",
          ),
        ),
      );

      // Clear form
      nameController.clear();
      priceController.clear();
      ratingController.clear();

      setState(() {
        selectedCategoryId = null;
        selectedImage = null;
        selectedImageBytes = null;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            "Failed to add product: $e",
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync =
        ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Product",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [

            // ======================================================
            // PRODUCT NAME
            // ======================================================

            const Text(
              "Product Name",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: nameController,
              decoration:
                  const InputDecoration(
                hintText:
                    "Enter product name",
                border:
                    OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // ======================================================
            // PRICE
            // ======================================================

            const Text(
              "Price",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: priceController,
              keyboardType:
                  const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration:
                  const InputDecoration(
                hintText:
                    "Enter product price",
                border:
                    OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // ======================================================
            // RATING
            // ======================================================

            const Text(
              "Rating",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: ratingController,
              keyboardType:
                  const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration:
                  const InputDecoration(
                hintText:
                    "Enter rating",
                border:
                    OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // ======================================================
            // CATEGORY
            // ======================================================

            const Text(
              "Category",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            categoriesAsync.when(
              loading: () {
                return const Center(
                  child:
                      CircularProgressIndicator(),
                );
              },

              error: (error, stack) {
                return Text(
                  "Failed to load categories: $error",
                );
              },

              data: (categories) {
                return DropdownButtonFormField<int>(
                  value:
                      selectedCategoryId,

                  decoration:
                      const InputDecoration(
                    hintText:
                        "Select category",
                    border:
                        OutlineInputBorder(),
                  ),

                  items: categories
                      .map(
                    (category) {
                      return DropdownMenuItem<int>(
                        value:
                            category.id,
                        child: Text(
                          category.name,
                        ),
                      );
                    },
                  ).toList(),

                  onChanged: (value) {
                    setState(() {
                      selectedCategoryId =
                          value;
                    });
                  },
                );
              },
            ),

            const SizedBox(height: 30),

            // ======================================================
            // PRODUCT IMAGE
            // ======================================================

            const Text(
              "Product Image",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            GestureDetector(
              onTap: isLoading
                  ? null
                  : _pickImage,
              child: Container(
                width: double.infinity,
                height: 200,
                decoration:
                    BoxDecoration(
                  color:
                      Colors.grey.shade100,
                  borderRadius:
                      BorderRadius.circular(
                    16,
                  ),
                  border: Border.all(
                    color:
                        Colors.grey.shade300,
                  ),
                ),
                child:
                    selectedImageBytes == null
                        ? const Column(
                            mainAxisAlignment:
                                MainAxisAlignment
                                    .center,
                            children: [
                              Icon(
                                Icons
                                    .add_photo_alternate_outlined,
                                size: 50,
                                color:
                                    Colors.grey,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Tap to select image",
                                style:
                                    TextStyle(
                                  color:
                                      Colors.grey,
                                ),
                              ),
                            ],
                          )
                        : ClipRRect(
                            borderRadius:
                                BorderRadius.circular(
                              16,
                            ),
                            child:
                                Image.memory(
                              selectedImageBytes!,
                              width:
                                  double.infinity,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
              ),
            ),

            const SizedBox(height: 30),

            // ======================================================
            // ADD PRODUCT BUTTON
            // ======================================================

            SizedBox(
              width: double.infinity,
              height: 55,
              child:
                  ElevatedButton(
                onPressed:
                    isLoading
                        ? null
                        : _addProduct,
                style:
                    ElevatedButton
                        .styleFrom(
                  backgroundColor:
                      Colors.black,
                  foregroundColor:
                      Colors.white,
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      14,
                    ),
                  ),
                ),
                child: isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child:
                            CircularProgressIndicator(
                          strokeWidth: 2,
                          color:
                              Colors.white,
                        ),
                      )
                    : const Text(
                        "Add Product",
                        style:
                            TextStyle(
                          fontSize: 16,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}