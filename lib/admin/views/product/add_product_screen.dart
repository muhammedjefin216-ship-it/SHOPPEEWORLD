import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shoppee_world/admin/models/catagory/category_provider.dart';
import 'package:shoppee_world/admin/models/product/product_model.dart';
import 'package:shoppee_world/admin/repositories/product_repository.dart';
import 'package:shoppee_world/admin/services/storage_service.dart';

class AddProductScreen extends ConsumerStatefulWidget {
  final ProductModel? product;

  const AddProductScreen({
    super.key,
    this.product,
  });

  @override
  ConsumerState<AddProductScreen> createState() =>
      _AddProductScreenState();
}

class _AddProductScreenState
    extends ConsumerState<AddProductScreen> {
  bool isLoading = false;

  final nameController = TextEditingController();
  final ratingController = TextEditingController();

  final originalPriceController = TextEditingController();
  final offerPriceController = TextEditingController();
  final descriptionController = TextEditingController();
  final stockController = TextEditingController();
  final sizesController = TextEditingController();
  final colorsController = TextEditingController();

  final ImagePicker _imagePicker = ImagePicker();

  final ProductRepository _productRepository =
      ProductRepository();

  final StorageService _storageService =
      StorageService();

  int? selectedCategoryId;

  List<XFile> selectedImages = [];
  List<Uint8List> selectedImageBytes = [];

  // Existing images from Supabase
  List<String> existingImageUrls = [];

  @override
  void initState() {
    super.initState();

    if (widget.product != null) {
      final product = widget.product!;

      nameController.text = product.name;
      ratingController.text = product.rating.toString();

      originalPriceController.text =
          product.originalPrice.toString();

      offerPriceController.text =
          product.offerPrice.toString();

      descriptionController.text =
          product.description;

      stockController.text =
          product.stockQuantity.toString();

      sizesController.text =
          product.availableSizes.join(', ');

      colorsController.text =
          product.availableColors.join(', ');

      selectedCategoryId = product.categoryId;

      _loadExistingImages(product.id);
    }
  }

  Future<void> _loadExistingImages(int productId) async {
    try {
      final images =
          await _productRepository.getProductImages(productId);

      if (!mounted) return;

      setState(() {
        existingImageUrls = images;
      });
    } catch (e) {
      // Keep existing images empty if loading fails.
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    ratingController.dispose();

    originalPriceController.dispose();
    offerPriceController.dispose();
    descriptionController.dispose();
    stockController.dispose();
    sizesController.dispose();
    colorsController.dispose();

    super.dispose();
  }

  // ============================================================
  // PICK MULTIPLE IMAGES
  // ============================================================

  Future<void> _pickImages() async {
    final List<XFile> images =
        await _imagePicker.pickMultiImage();

    if (images.isEmpty) {
      return;
    }

    final List<Uint8List> bytes = [];

    for (final image in images) {
      bytes.add(await image.readAsBytes());
    }

    if (!mounted) return;

    setState(() {
      selectedImages = images;
      selectedImageBytes = bytes;
    });
  }

  void _removeImage(int index) {
    setState(() {
      selectedImages.removeAt(index);
      selectedImageBytes.removeAt(index);
    });
  }

  // ============================================================
  // CONVERT COMMA SEPARATED TEXT TO LIST
  // ============================================================

  List<String> _convertToList(String value) {
    return value
        .split(',')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();
  }

  // ============================================================
  // ADD PRODUCT
  // ============================================================

  Future<void> _addProduct() async {
    final name = nameController.text.trim();
    final ratingText = ratingController.text.trim();

    final originalPriceText =
        originalPriceController.text.trim();

    final offerPriceText =
        offerPriceController.text.trim();

    final description =
        descriptionController.text.trim();

    final stockText =
        stockController.text.trim();

    final sizes =
        _convertToList(sizesController.text);

    final colors =
        _convertToList(colorsController.text);

    // ------------------------------------------------------------
    // VALIDATION
    // ------------------------------------------------------------

    if (name.isEmpty ||
        ratingText.isEmpty ||
        originalPriceText.isEmpty ||
        offerPriceText.isEmpty ||
        description.isEmpty ||
        stockText.isEmpty ||
        sizes.isEmpty ||
        colors.isEmpty ||
        selectedCategoryId == null ||
        selectedImages.isEmpty ||
        selectedImageBytes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please fill all fields and select at least one image",
          ),
        ),
      );

      return;
    }

    final price = double.tryParse(offerPriceText);
    final rating = double.tryParse(ratingText);

    final originalPrice =
        double.tryParse(originalPriceText);

    final offerPrice =
        double.tryParse(offerPriceText);

    final stockQuantity =
        int.tryParse(stockText);

    if (price == null ||
        rating == null ||
        originalPrice == null ||
        offerPrice == null ||
        stockQuantity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please enter valid numeric values",
          ),
        ),
      );

      return;
    }

    if (originalPrice <= 0 ||
        offerPrice <= 0 ||
        stockQuantity < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please enter valid price and stock values",
          ),
        ),
      );

      return;
    }

    if (offerPrice > originalPrice) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Offer price cannot be greater than original price",
          ),
        ),
      );

      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // ----------------------------------------------------------
      // 1. UPLOAD ALL IMAGES
      // ----------------------------------------------------------

      final List<String> imageUrls = [];

      for (int i = 0;
          i < selectedImages.length;
          i++) {
        final imageUrl =
            await _storageService.uploadProductImage(
          imageBytes: selectedImageBytes[i],
          fileName: selectedImages[i].name,
        );

        imageUrls.add(imageUrl);
      }

      // ----------------------------------------------------------
      // 2. ADD PRODUCT
      // ----------------------------------------------------------

      final productId =
          await _productRepository.addProduct(
        name: name,
        image: imageUrls.first,
        // Actual selling price = offer price.
        price: price,
        rating: rating,
        categoryId: selectedCategoryId!,
        originalPrice: originalPrice,
        offerPrice: offerPrice,
        description: description,
        stockQuantity: stockQuantity,
        availableSizes: sizes,
        availableColors: colors,
      );

      // ----------------------------------------------------------
      // 3. SAVE ALL IMAGES
      // ----------------------------------------------------------

      await _productRepository.addProductImages(
        productId: productId,
        imageUrls: imageUrls,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Product added successfully!",
          ),
        ),
      );

      // ----------------------------------------------------------
      // CLEAR FORM
      // ----------------------------------------------------------

      nameController.clear();
      ratingController.clear();

      originalPriceController.clear();
      offerPriceController.clear();
      descriptionController.clear();
      stockController.clear();
      sizesController.clear();
      colorsController.clear();

      setState(() {
        selectedCategoryId = null;
        selectedImages = [];
        selectedImageBytes = [];
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
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

  // ============================================================
  // UPDATE PRODUCT
  // ============================================================

  Future<void> _updateProduct() async {
    final name = nameController.text.trim();
    final ratingText = ratingController.text.trim();

    final originalPriceText =
        originalPriceController.text.trim();

    final offerPriceText =
        offerPriceController.text.trim();

    final description =
        descriptionController.text.trim();

    final stockText =
        stockController.text.trim();

    final sizes =
        _convertToList(sizesController.text);

    final colors =
        _convertToList(colorsController.text);

    if (name.isEmpty ||
        ratingText.isEmpty ||
        originalPriceText.isEmpty ||
        offerPriceText.isEmpty ||
        description.isEmpty ||
        stockText.isEmpty ||
        sizes.isEmpty ||
        colors.isEmpty ||
        selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please fill all fields",
          ),
        ),
      );

      return;
    }

    final price = double.tryParse(offerPriceText);
    final rating = double.tryParse(ratingText);

    final originalPrice =
        double.tryParse(originalPriceText);

    final offerPrice =
        double.tryParse(offerPriceText);

    final stockQuantity =
        int.tryParse(stockText);

    if (price == null ||
        rating == null ||
        originalPrice == null ||
        offerPrice == null ||
        stockQuantity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Invalid numeric values",
          ),
        ),
      );

      return;
    }

    if (offerPrice > originalPrice) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Offer price cannot be greater than original price",
          ),
        ),
      );

      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      String imageUrl =
          widget.product!.image;

      // ----------------------------------------------------------
      // NEW MAIN IMAGE
      // ----------------------------------------------------------

      if (selectedImages.isNotEmpty &&
          selectedImageBytes.isNotEmpty) {
        imageUrl =
            await _storageService.uploadProductImage(
          imageBytes: selectedImageBytes.first,
          fileName: selectedImages.first.name,
        );
      }

      // ----------------------------------------------------------
      // UPDATE PRODUCT
      // ----------------------------------------------------------

      await _productRepository.updateProduct(
        id: widget.product!.id,
        name: name,
        image: imageUrl,
        // Actual selling price = offer price.
        price: price,
        rating: rating,
        categoryId: selectedCategoryId!,
        originalPrice: originalPrice,
        offerPrice: offerPrice,
        description: description,
        stockQuantity: stockQuantity,
        availableSizes: sizes,
        availableColors: colors,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Product Updated Successfully",
          ),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
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

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final categoriesAsync =
        ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.product == null
              ? "Add Product"
              : "Update Product",
          style: const TextStyle(
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
              decoration: const InputDecoration(
                hintText: "Enter product name",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // ======================================================
            // ORIGINAL PRICE
            // ======================================================

            const Text(
              "Original Price",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: originalPriceController,
              keyboardType:
                  const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                hintText: "Enter original price",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // ======================================================
            // OFFER PRICE
            // ======================================================

            const Text(
              "Offer Price",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: offerPriceController,
              keyboardType:
                  const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                hintText: "Enter offer price",
                border: OutlineInputBorder(),
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
              decoration: const InputDecoration(
                hintText: "Enter rating",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // ======================================================
            // STOCK
            // ======================================================

            const Text(
              "Stock Quantity",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: stockController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: "Enter available stock",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // ======================================================
            // DESCRIPTION
            // ======================================================

            const Text(
              "Description",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: descriptionController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText:
                    "Enter product description",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // ======================================================
            // AVAILABLE SIZES
            // ======================================================

            const Text(
              "Available Sizes",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: sizesController,
              decoration: const InputDecoration(
                hintText:
                    "Example: 7, 8, 9, 10, 11",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // ======================================================
            // AVAILABLE COLORS
            // ======================================================

            const Text(
              "Available Colors",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: colorsController,
              decoration: const InputDecoration(
                hintText:
                    "Example: White, Blue, Red",
                border: OutlineInputBorder(),
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
                  child: CircularProgressIndicator(),
                );
              },
              error: (error, stack) {
                return Text(
                  "Failed to load categories: $error",
                );
              },
              data: (categories) {
                return DropdownButtonFormField<int>(
                  initialValue: selectedCategoryId,
                  decoration:
                      const InputDecoration(
                    hintText: "Select category",
                    border: OutlineInputBorder(),
                  ),
                  items: categories
                      .map((category) {
                    return DropdownMenuItem<int>(
                      value: category.id,
                      child:
                          Text(category.name),
                    );
                  }).toList(),
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
            // PRODUCT IMAGES
            // ======================================================

            const Text(
              "Product Images",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            GestureDetector(
              onTap:
                  isLoading ? null : _pickImages,
              child: Container(
                width: double.infinity,
                height: 130,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius:
                      BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.grey.shade300,
                  ),
                ),
                child: const Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons
                          .add_photo_alternate_outlined,
                      size: 45,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Tap to select images",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "You can select multiple images",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),

  // ======================================================
// EXISTING IMAGES
// ======================================================

if (existingImageUrls.isNotEmpty) ...[
  const SizedBox(height: 15),

  const Text(
    "Existing Images",
    style: TextStyle(
      fontWeight: FontWeight.w600,
    ),
  ),

  const SizedBox(height: 10),

  GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: existingImageUrls.length,
    gridDelegate:
        const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1,
    ),
    itemBuilder: (context, index) {
      return Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              existingImageUrls[index],
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey.shade300,
                  child: const Icon(
                    Icons.image_not_supported,
                  ),
                );
              },
            ),
          ),

          Positioned(
            top: 5,
            right: 5,
            child: GestureDetector(
              onTap: () async {
                final imageUrl =
                    existingImageUrls[index];

                try {
                  await _productRepository
                      .deleteProductImage(
                    productId: widget.product!.id,
                    imageUrl: imageUrl,
                  );

                  if (!mounted) return;

                  setState(() {
                    existingImageUrls.removeAt(index);
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Image deleted"),
                    ),
                  );
                } catch (e) {
                  if (!mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Failed to delete image: $e",
                      ),
                    ),
                  );
                }
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.black87,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ),
        ],
      );
    },
  ),
],

            // ======================================================
            // NEW IMAGE PREVIEWS
            // ======================================================

            if (selectedImageBytes.isNotEmpty) ...[
              const SizedBox(height: 20),

              const Text(
                "New Images",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 10),

              GridView.builder(
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(),
                itemCount:
                    selectedImageBytes.length,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1,
                ),
                itemBuilder:
                    (context, index) {
                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius:
                            BorderRadius.circular(12),
                        child: Image.memory(
                          selectedImageBytes[index],
                          width:
                              double.infinity,
                          height:
                              double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),

                      Positioned(
                        top: 5,
                        right: 5,
                        child:
                            GestureDetector(
                          onTap: () =>
                              _removeImage(index),
                          child: Container(
                            padding:
                                const EdgeInsets.all(4),
                            decoration:
                                const BoxDecoration(
                              color: Colors.black87,
                              shape: BoxShape.circle,
                            ),
                            child:
                                const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ),

                      if (index == 0)
                        Positioned(
                          left: 6,
                          bottom: 6,
                          child: Container(
                            padding:
                                const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 4,
                            ),
                            decoration:
                                BoxDecoration(
                              color: Colors.black87,
                              borderRadius:
                                  BorderRadius.circular(6),
                            ),
                            child: const Text(
                              "Main",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],

            const SizedBox(height: 30),

            // ======================================================
            // ADD / UPDATE BUTTON
            // ======================================================

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: isLoading
                    ? null
                    : widget.product == null
                        ? _addProduct
                        : _updateProduct,
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(14),
                  ),
                ),
                child: isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child:
                            CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        widget.product == null
                            ? "Add Product"
                            : "Update Product",
                        style:
                            const TextStyle(
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