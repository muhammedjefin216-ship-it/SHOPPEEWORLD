

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoppee_world/user/core/theme/app_tokens.dart';
import 'package:shoppee_world/user/repositories/product_repository.dart';
import 'package:shoppee_world/user/viewmodel/wishlist/wishlist_provider.dart';

import '../common/app_network_image.dart';

/// Full-bleed product gallery. Place it at the top of the page with no
/// horizontal padding: the image runs edge to edge and the page background
/// curves up over its bottom edge.
class ProductImage extends ConsumerStatefulWidget {
  final String image;
  final int productId;
  final bool initialFavorite;

  // Selected images will be sent back to ProductDetailsScreen.
  final ValueChanged<List<String>>? onImagesSelected;

  const ProductImage({
    super.key,
    required this.image,
    required this.productId,
    this.initialFavorite = false,
    this.onImagesSelected,
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

  List<String> _images = [];

  int _selectedImageIndex = 0;

  bool _isLoadingImages = true;
  bool _isUpdatingFavorite = false;

  // Images selected for sharing with the order.
  final Set<int> _selectedShareImageIndexes = {};

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

  // ----------------------------------------------------------
  // LOAD PRODUCT IMAGES
  // ----------------------------------------------------------

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

  // ----------------------------------------------------------
  // FULL SCREEN IMAGE
  // ----------------------------------------------------------

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

  // ----------------------------------------------------------
  // WISHLIST
  // ----------------------------------------------------------

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

  // ----------------------------------------------------------
  // MAIN IMAGE SELECTION
  // ----------------------------------------------------------

  void _selectImage(int index) {
    if (index < 0 || index >= _images.length) return;

    setState(() {
      _selectedImageIndex = index;
    });
  }

  // ----------------------------------------------------------
  // SHARE IMAGE SELECTION
  // ----------------------------------------------------------

  void _toggleShareImage(int index) {
    if (index < 0 || index >= _images.length) return;

    setState(() {
      if (_selectedShareImageIndexes.contains(index)) {
        _selectedShareImageIndexes.remove(index);
      } else {
        _selectedShareImageIndexes.add(index);
      }
    });

    _notifySelectedImages();
  }

  // ----------------------------------------------------------
  // SEND SELECTED IMAGES TO PARENT
  // ----------------------------------------------------------

  void _notifySelectedImages() {
    final selectedImages = _selectedShareImageIndexes
        .map((index) => _images[index])
        .toList();

    widget.onImagesSelected?.call(selectedImages);
  }

  // ----------------------------------------------------------
  // SELECT ALL IMAGES
  // ----------------------------------------------------------

  void _selectAllImages() {
    setState(() {
      if (_selectedShareImageIndexes.length == _images.length) {
        _selectedShareImageIndexes.clear();
      } else {
        _selectedShareImageIndexes.clear();

        for (int i = 0; i < _images.length; i++) {
          _selectedShareImageIndexes.add(i);
        }
      }
    });

    _notifySelectedImages();
  }

  @override
  Widget build(BuildContext context) {
    final currentImage =
        _images.isNotEmpty &&
                _selectedImageIndex < _images.length
            ? _images[_selectedImageIndex]
            : widget.image;

    final hasMultipleImages = !_isLoadingImages && _images.length > 1;

    final selectedCount = _selectedShareImageIndexes.length;

    final topInset = MediaQuery.of(context).padding.top;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ==================================================
        // MAIN IMAGE (full-bleed)
        // ==================================================

        SizedBox(
          height: 380,
          width: double.infinity,
          child: Stack(
            children: [
              Positioned.fill(
                child: Hero(
                  tag: 'product-image-${widget.productId}',
                  child: _isLoadingImages
                      ? Container(
                          color: AppTokens.surface,
                          child: const Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: AppTokens.textSecondary,
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: _openFullScreenImage,
                          child: AppNetworkImage(
                            imageUrl: currentImage,
                            fit: BoxFit.cover,
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                ),
              ),

              // ==================================================
              // WISHLIST BUTTON
              // ==================================================

              Positioned(
                top: topInset + 8,
                right: AppTokens.gutter,
                child: ScaleTransition(
                  scale: _favScaleAnimation,
                  child: Material(
                    color: AppTokens.background,
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: _isUpdatingFavorite
                          ? null
                          : _toggleFavorite,
                      child: SizedBox(
                        height: 40,
                        width: 40,
                        child: Icon(
                          _isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: _isFavorite
                              ? AppTokens.accent
                              : AppTokens.textPrimary,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // ==================================================
              // IMAGE COUNTER
              // ==================================================

              if (hasMultipleImages)
                Positioned(
                  left: AppTokens.gutter,
                  bottom: 32,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTokens.background,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_selectedImageIndex + 1} / ${_images.length}',
                      style: AppTokens.caption.copyWith(
                        color: AppTokens.textPrimary,
                      ),
                    ),
                  ),
                ),

              // ==================================================
              // IMAGE INDICATOR (tappable)
              // ==================================================

              if (hasMultipleImages)
                Positioned(
                  bottom: 24,
                  right: AppTokens.gutter,
                  child: Row(
                    children: List.generate(
                      _images.length,
                      (index) {
                        final isActive =
                            _selectedImageIndex == index;

                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            _selectImage(index);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 3,
                              vertical: 8,
                            ),
                            child: AnimatedContainer(
                              duration: const Duration(
                                milliseconds: 200,
                              ),
                              height: 4,
                              width: isActive ? 18 : 6,
                              decoration: BoxDecoration(
                                color: isActive
                                    ? AppTokens.accent
                                    : Colors.white54,
                                borderRadius:
                                    BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

              // ==================================================
              // PAGE SHEET CURVE (page background over image edge)
              // ==================================================

              const Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: AppTokens.s20,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppTokens.background,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(AppTokens.radiusSheet),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // ==================================================
        // IMAGE THUMBNAILS
        // ==================================================

        if (hasMultipleImages)
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppTokens.gutter,
              AppTokens.s4,
              AppTokens.gutter,
              AppTokens.s8,
            ),
            child: SizedBox(
              height: 56,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: _images.length,
                itemBuilder: (context, index) {
                  final isCurrentImage =
                      _selectedImageIndex == index;

                  final isShareSelected =
                      _selectedShareImageIndexes
                          .contains(index);

                  return GestureDetector(
                    // Tapping the thumbnail changes
                    // the main displayed image.
                    onTap: () {
                      _selectImage(index);
                    },
                    child: Stack(
                      children: [
                        // ----------------------------------------
                        // THUMBNAIL
                        // ----------------------------------------

                        AnimatedContainer(
                          duration:
                              const Duration(milliseconds: 200),
                          width: 56,
                          height: 56,
                          margin: const EdgeInsets.only(
                            right: AppTokens.s8,
                          ),
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: AppTokens.surface,
                            borderRadius: BorderRadius.circular(
                              AppTokens.radiusMd,
                            ),
                            border: Border.all(
                              color: isCurrentImage
                                  ? AppTokens.accent
                                  : AppTokens.border,
                              width: isCurrentImage ? 1.5 : 1,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(6),
                            child: AppNetworkImage(
                              imageUrl: _images[index],
                              fit: BoxFit.cover,
                              borderRadius:
                                  BorderRadius.circular(6),
                            ),
                          ),
                        ),

                        // ----------------------------------------
                        // CHECKBOX
                        // ----------------------------------------

                        Positioned(
                          top: 4,
                          right: 12,
                          child: GestureDetector(
                            onTap: () {
                              _toggleShareImage(index);
                            },
                            child: AnimatedContainer(
                              duration: const Duration(
                                milliseconds: 180,
                              ),
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                color: isShareSelected
                                    ? AppTokens.accent
                                    : AppTokens.overlay,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isShareSelected
                                      ? AppTokens.accent
                                      : Colors.white70,
                                  width: 1.5,
                                ),
                              ),
                              child: isShareSelected
                                  ? const Icon(
                                      Icons.check,
                                      size: 14,
                                      color: AppTokens.onAccent,
                                    )
                                  : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),

        // ==================================================
        // IMAGE SELECTION CONTROL
        // ==================================================

        if (hasMultipleImages)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTokens.gutter,
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.photo_library_outlined,
                  color: AppTokens.textSecondary,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    selectedCount == 0
                        ? 'Select images for order'
                        : '$selectedCount image'
                            '${selectedCount == 1 ? '' : 's'} selected',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTokens.caption,
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _selectAllImages,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 8,
                    ),
                    child: Text(
                      selectedCount == _images.length
                          ? 'Clear'
                          : 'Select all',
                      style: AppTokens.caption.copyWith(
                        color: AppTokens.accent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

// ================================================================
// FULL SCREEN PRODUCT IMAGE
// ================================================================

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
          Matrix4.identity()..scale(2.5);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          tooltip: 'Close',
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