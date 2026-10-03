import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryItem({
    super.key,
    required this.name,
    required this.onTap,
    this.imageUrl,
    this.isSelected = false,
  });

  IconData _getIcon() {
    switch (name.toLowerCase()) {
      case "shoes":
        return Icons.shopping_bag_outlined;
      case "watches":
        return Icons.watch_outlined;
      case "gadgets":
        return Icons.devices_outlined;
      case "shades":
        return Icons.wb_sunny_outlined;
      case "shirt":
        return Icons.checkroom_outlined;
      default:
        return Icons.category_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 82,
        margin: const EdgeInsets.only(right: 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 58,
              width: 58,
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white
                    : const Color(0xff191D1E),
                borderRadius: BorderRadius.circular(14),
              ),
              clipBehavior: Clip.antiAlias,
              child: imageUrl != null && imageUrl!.isNotEmpty
                  ? Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) {
                        return Icon(
                          _getIcon(),
                          size: 25,
                          color: isSelected
                              ? Colors.black
                              : Colors.white,
                        );
                      },
                    )
                  : Icon(
                      _getIcon(),
                      size: 25,
                      color: isSelected
                          ? Colors.black
                          : Colors.white,
                    ),
            ),
            const SizedBox(height: 7),
            Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: isSelected
                    ? FontWeight.w700
                    : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}