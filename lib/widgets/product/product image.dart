import 'package:flutter/material.dart';
import '../common/app_network_image.dart';

class ProductImage extends StatefulWidget {
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
  State<ProductImage> createState() => _ProductImageState();
}

class _ProductImageState extends State<ProductImage> with SingleTickerProviderStateMixin {
  late bool _isFavorite;
  late AnimationController _favController;
  late Animation<double> _favScaleAnimation;
  int _activeDotIndex = 0;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.initialFavorite;
    _favController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _favScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.4), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.4, end: 1.0), weight: 50),
    ]).animate(_favController);
  }

  @override
  void dispose() {
    _favController.dispose();
    super.dispose();
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
    _favController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main Image Container with Hero
        Container(
          height: 380,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.grey.shade50,
                Colors.grey.shade100,
              ],
            ),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Hero(
            tag: 'product-image-${widget.productId}',
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: AppNetworkImage(
                imageUrl: widget.image,
                fit: BoxFit.contain,
                borderRadius: BorderRadius.circular(28),
              ),
            ),
          ),
        ),

        // Carousel Dot Indicators Mockup
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              final isActive = _activeDotIndex == index;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _activeDotIndex = index;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 6,
                  width: isActive ? 20 : 6,
                  decoration: BoxDecoration(
                    color: isActive ? Colors.black : Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              );
            }),
          ),
        ),

        // Floating Favorite Button
        Positioned(
          top: 20,
          right: 20,
          child: ScaleTransition(
            scale: _favScaleAnimation,
            child: Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: _toggleFavorite,
                  child: Icon(
                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: _isFavorite ? Colors.red : Colors.black87,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}