import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
          children: [
            Text(
              "Select Size",
              style: GoogleFonts.outfit(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),

            TextButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Size Guide: Standard UK sizing applies.",
                      style: GoogleFonts.outfit(),
                    ),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              icon: const Icon(
                Icons.rule,
                size: 15,
                color: Colors.white54,
              ),
              label: Text(
                "Size Guide",
                style: GoogleFonts.outfit(
                  color: Colors.white54,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        // ==========================================================
        // SIZE OPTIONS
        // ==========================================================

        SizedBox(
          height: 48,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: widget.sizes.length,
            separatorBuilder: (_, _) =>
                const SizedBox(width: 10),
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
                  width: 58,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white
                        : const Color(0xff191D1E),
                    borderRadius:
                        BorderRadius.circular(11),
                    border: Border.all(
                      color: isSelected
                          ? Colors.white
                          : Colors.white.withOpacity(.08),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      size.replaceFirst("UK ", ""),
                      style: GoogleFonts.outfit(
                        color: isSelected
                            ? Colors.black
                            : Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
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