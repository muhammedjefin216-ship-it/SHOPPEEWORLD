import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:shoppee_world/admin/models/catagory/category_model.dart';
import 'package:shoppee_world/admin/repositories/category_repository.dart';

class AddCategoryScreen extends StatefulWidget {
  final CategoryModel? category;

  const AddCategoryScreen({
    super.key,
    this.category,
  });

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final _controller = TextEditingController();

  final CategoryRepository _repository = CategoryRepository();
  final ImagePicker _picker = ImagePicker();

  File? _selectedImage;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    if (widget.category != null) {
      _controller.text = widget.category!.name;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image == null) return;

    setState(() {
      _selectedImage = File(image.path);
    });
  }

  Future<void> saveCategory() async {
    final name = _controller.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Enter category name"),
        ),
      );
      return;
    }

    if (_selectedImage == null && widget.category == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Select category image"),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      if (widget.category == null) {
  final imageUrl =
      await _repository.uploadCategoryImage(
    _selectedImage!,
  );

  await _repository.addCategory(
    name: name,
    imageUrl: imageUrl,
  );
} else {
  String? imageUrl;

  if (_selectedImage != null) {
    imageUrl = await _repository.uploadCategoryImage(
      _selectedImage!,
    );
  }

  await _repository.updateCategory(
    id: widget.category!.id,
    name: name,
    imageUrl: imageUrl,
  );
}

      if (!mounted) return;

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.category == null
              ? "Add Category"
              : "Update Category",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: isLoading ? null : pickImage,
              child: Container(
                height: 160,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.grey.shade400,
                  ),
                ),
                child: _selectedImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(
                          _selectedImage!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_photo_alternate_outlined,
                            size: 45,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Add Category Image",
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: "Category Name",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading ? null : saveCategory,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : Text(
                        widget.category == null
                            ? "Add Category"
                            : "Update Category",
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}