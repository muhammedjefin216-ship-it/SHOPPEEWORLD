import 'package:flutter/material.dart';
import 'package:shoppee_world/user/core/theme/app_tokens.dart';

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
      child: SizedBox(
        width: 82,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 58,
              width: 58,
              decoration: BoxDecoration(
                color: AppTokens.surface,
                borderRadius: BorderRadius.circular(
                  AppTokens.radiusLg,
                ),
                border: Border.all(
                  color: isSelected
                      ? AppTokens.accent
                      : AppTokens.border,
                  width: isSelected ? 1.5 : 1,
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: imageUrl != null && imageUrl!.isNotEmpty
                  ? Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) {
                        return _buildFallbackIcon();
                      },
                    )
                  : _buildFallbackIcon(),
            ),
            const SizedBox(height: AppTokens.s8),
            Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: AppTokens.caption.copyWith(
                fontSize: 11,
                color: isSelected
                    ? AppTokens.accent
                    : AppTokens.textSecondary,
                fontWeight: isSelected
                    ? FontWeight.w600
                    : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFallbackIcon() {
    return Center(
      child: Icon(
        _getIcon(),
        size: 25,
        color: isSelected
            ? AppTokens.accent
            : AppTokens.textSecondary,
      ),
    );
  }
}

