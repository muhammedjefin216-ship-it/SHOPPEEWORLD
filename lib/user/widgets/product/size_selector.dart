import 'package:flutter/material.dart';
import 'package:shoppee_world/user/core/theme/app_tokens.dart';

class SizeSelector extends StatefulWidget {
  final List<String> sizes;
  final String? selectedSize;
  final ValueChanged<String> onSizeSelected;

  const SizeSelector({
    super.key,
    required this.sizes,
    required this.selectedSize,
    required this.onSizeSelected,
  });

  @override
  State<SizeSelector> createState() => _SizeSelectorState();
}

class _SizeSelectorState extends State<SizeSelector> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ==========================================================
        // TITLE + SIZE GUIDE
        // ==========================================================

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Size",
              style: AppTokens.bodyStrong,
            ),

            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Size Guide: Standard UK sizing applies.",
                      style: AppTokens.bodyStrong,
                    ),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: AppTokens.surface,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppTokens.radiusLg,
                      ),
                      side: const BorderSide(
                        color: AppTokens.borderStrong,
                      ),
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 4,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.straighten_rounded,
                      size: 16,
                      color: AppTokens.textSecondary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "Size guide",
                      style: AppTokens.caption.copyWith(
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: AppTokens.s8),

        // ==========================================================
        // SIZE OPTIONS
        // ==========================================================

        SizedBox(
          height: 44,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: widget.sizes.length,
            separatorBuilder: (_, _) =>
                const SizedBox(width: AppTokens.s8),
            itemBuilder: (context, index) {
              final size = widget.sizes[index];

              final isSelected =
                  widget.selectedSize == size;

              return GestureDetector(
                onTap: () {
                  widget.onSizeSelected(size);
                },
                child: AnimatedContainer(
                  duration: const Duration(
                    milliseconds: 200,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 52,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTokens.s12,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTokens.fill
                        : AppTokens.background,
                    borderRadius: BorderRadius.circular(
                      AppTokens.radiusMd,
                    ),
                    border: Border.all(
                      color: isSelected
                          ? AppTokens.fill
                          : AppTokens.border,
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      size.replaceFirst("UK ", ""),
                      style: AppTokens.bodyStrong.copyWith(
                        color: isSelected
                            ? AppTokens.onFill
                            : AppTokens.textPrimary,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}