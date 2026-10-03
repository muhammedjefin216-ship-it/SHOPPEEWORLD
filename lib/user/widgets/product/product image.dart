import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shoppee_world/user/repositories/product_repository.dart';
import 'package:shoppee_world/user/viewmodel/wishlist/wishlist_provider.dart';

import '../common/app_network_image.dart';

class ProductImage extends ConsumerStatefulWidget {
  final String image;
  final int productId;
  final bool initialFavorite;

  const ProductImage({
    super.key,
    required this.image,
    required this.productId,
    this.initialFavorite = false,
  });

  @override
  ConsumerState<ProductImage> createState() =>
      _ProductImageState();
}

class _ProductImageState extends ConsumerState<ProductImage>
    with SingleTickerProviderStateMixin {
  late bool _isFavorite;

  late AnimationController _favController;
  late Animation<double> _favScaleAnimation;

  // ==========================================================
  // IMAGE STATE
  // ==========================================================

  List<String> _images = [];

  int _selectedImageIndex = 0;

  bool _isLoadingImages = true;

  bool _isUpdatingFavorite = false;

  @override
  void initState() {
    super.initState();

    _isFavorite = widget.initialFavorite;

    _favController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _favScaleAnimation = TweenSequence<double>(
      [
        TweenSequenceItem(
          tween: Tween(
            begin: 1.0,
            end: 1.35,
          ),
          weight: 50,
        ),
        TweenSequenceItem(
          tween: Tween(
            begin: 1.35,
            end: 1.0,
          ),
          weight: 50,
        ),
      ],
    ).animate(_favController);

    _loadProductImages();
  }

  @override
  void dispose() {
    _favController.dispose();
    super.dispose();
  }

  // ==========================================================
  // LOAD PRODUCT IMAGES
  // ==========================================================

  Future<void> _loadProductImages() async {
    try {
      final images = await ProductRepository()
          .getProductImages(widget.productId);

      if (!mounted) return;

      setState(() {
        if (images.isNotEmpty) {
          _images = images;
        } else {
          _images = [widget.image];
        }

        _isLoadingImages = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _images = [widget.image];
        _isLoadingImages = false;
      });
    }
  }

  // ==========================================================
  // OPEN FULL SCREEN IMAGE
  // ==========================================================

  void _openFullScreenImage() {
    final currentImage =
        _images.isNotEmpty &&
                _selectedImageIndex < _images.length
            ? _images[_selectedImageIndex]
            : widget.image;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FullScreenProductImage(
          imageUrl: currentImage,
        ),
      ),
    );
  }

  // ==========================================================
  // FAVORITE
  // ==========================================================

  Future<void> _toggleFavorite() async {
    if (_isUpdatingFavorite) return;

    final previousValue = _isFavorite;

    setState(() {
      _isFavorite = !_isFavorite;
      _isUpdatingFavorite = true;
    });

    _favController.forward(from: 0.0);

    try {
      await ref
          .read(wishlistNotifierProvider)
          .toggleFavorite(
            productId: widget.productId,
          );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isFavorite = previousValue;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to update wishlist: '
            '${e.toString().replaceFirst('Exception: ', '')}',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isUpdatingFavorite = false;
        });
      }
    }
  }

  // ==========================================================
  // CHANGE IMAGE
  // ==========================================================

  void _selectImage(int index) {
    if (index < 0 || index >= _images.length) {
      return;
    }

    setState(() {
      _selectedImageIndex = index;
    });
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    final currentImage =
        _images.isNotEmpty &&
                _selectedImageIndex < _images.length
            ? _images[_selectedImageIndex]
            : widget.image;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff191D1E),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(.05),
        ),
      ),
      child: Column(
        children: [
          // ======================================================
          // MAIN PRODUCT IMAGE
          // ======================================================

          SizedBox(
            height: 320,
            child: Stack(
              children: [
                // ------------------------------------------------
                // IMAGE
                // ------------------------------------------------

                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Hero(
                      tag:
                          'product-image-${widget.productId}',
                      child: _isLoadingImages
                          ? const Center(
                              child:
                                  CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : GestureDetector(
                              onTap:
                                  _openFullScreenImage,
                              child: AppNetworkImage(
                                imageUrl: currentImage,
                                fit: BoxFit.cover,
                                borderRadius:
                                    BorderRadius.circular(
                                  20,
                                ),
                              ),
                            ),
                    ),
                  ),
                ),

                // ------------------------------------------------
                // FAVORITE BUTTON
                // ------------------------------------------------

                Positioned(
                  top: 16,
                  right: 16,
                  child: ScaleTransition(
                    scale: _favScaleAnimation,
                    child: Container(
                      height: 44,
                      width: 44,
                      decoration: BoxDecoration(
                        color:
                            const Color(0xff080C0D),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color:
                              Colors.white.withOpacity(.08),
                        ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          customBorder:
                              const CircleBorder(),
                          onTap:
                              _isUpdatingFavorite
                                  ? null
                                  : _toggleFavorite,
                          child: Icon(
                            _isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: _isFavorite
                                ? Colors.redAccent
                                : Colors.white,
                            size: 21,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // ------------------------------------------------
                // IMAGE DOTS
                // ------------------------------------------------

                if (!_isLoadingImages &&
                    _images.length > 1)
                  Positioned(
                    bottom: 12,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: List.generate(
                        _images.length,
                        (index) {
                          final isActive =
                              _selectedImageIndex ==
                                  index;

                          return GestureDetector(
                            onTap: () {
                              _selectImage(index);
                            },
                            child: AnimatedContainer(
                              duration: const Duration(
                                milliseconds: 250,
                              ),
                              margin:
                                  const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              height: 5,
                              width:
                                  isActive ? 20 : 5,
                              decoration:
                                  BoxDecoration(
                                color: isActive
                                    ? Colors.white
                                    : Colors.white24,
                                borderRadius:
                                    BorderRadius.circular(
                                  5,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // ======================================================
          // THUMBNAILS
          // ======================================================

          if (!_isLoadingImages &&
              _images.length > 1)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                16,
                0,
                16,
                16,
              ),
              child: SizedBox(
                height: 62,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics:
                      const BouncingScrollPhysics(),
                  itemCount: _images.length,
                  itemBuilder:
                      (context, index) {
                    final isSelected =
                        _selectedImageIndex ==
                            index;

                    return GestureDetector(
                      onTap: () {
                        _selectImage(index);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(
                          milliseconds: 200,
                        ),
                        width: 62,
                        height: 62,
                        margin:
                            const EdgeInsets.only(
                          right: 10,
                        ),
                        padding:
                            const EdgeInsets.all(3),
                        decoration:
                            BoxDecoration(
                          color:
                              const Color(0xff080C0D),
                          borderRadius:
                              BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? Colors.white
                                : Colors.white
                                    .withOpacity(.06),
                            width:
                                isSelected ? 1.5 : 1,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(9),
                          child: AppNetworkImage(
                            imageUrl:
                                _images[index],
                            fit: BoxFit.cover,
                            borderRadius:
                                BorderRadius.circular(9),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ==========================================================
// FULL SCREEN PRODUCT IMAGE
// ==========================================================

class FullScreenProductImage extends StatefulWidget {
  final String imageUrl;

  const FullScreenProductImage({
    super.key,
    required this.imageUrl,
  });

  @override
  State<FullScreenProductImage> createState() =>
      _FullScreenProductImageState();
}

class _FullScreenProductImageState
    extends State<FullScreenProductImage> {
  final TransformationController
      _transformationController =
      TransformationController();

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  void _handleDoubleTap() {
    final currentScale =
        _transformationController.value
            .getMaxScaleOnAxis();

    if (currentScale > 1.0) {
      _transformationController.value =
          Matrix4.identity();
    } else {
      _transformationController.value =
          Matrix4.identity()
            ..scale(2.5);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.close,
            color: Colors.white,
          ),
        ),
      ),

      body: Center(
        child: GestureDetector(
          onDoubleTap: _handleDoubleTap,

          child: InteractiveViewer(
            transformationController:
                _transformationController,
            minScale: 1.0,
            maxScale: 4.0,
            panEnabled: true,
            scaleEnabled: true,

            child: AppNetworkImage(
              imageUrl: widget.imageUrl,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}