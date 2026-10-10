import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ColorSelector extends StatelessWidget {
  final List<String> colors;
  final String? selectedColor;
  final ValueChanged<String> onColorSelected;

  const ColorSelector({
    super.key,
    required this.colors,
    required this.selectedColor,
    required this.onColorSelected,
  });

  Color _getColor(String colorName) {
    final color = colorName.toLowerCase().trim();

    if (color.contains('black')) {
      return Colors.black;
    }

    if (color.contains('white')) {
      return Colors.white;
    }

    if (color.contains('blue')) {
      return Colors.blue;
    }

    if (color.contains('red')) {
      return Colors.red;
    }

    if (color.contains('green')) {
      return Colors.green;
    }

    if (color.contains('yellow')) {
      return Colors.yellow;
    }

    if (color.contains('orange')) {
      return Colors.orange;
    }

    if (color.contains('purple')) {
      return Colors.purple;
    }

    if (color.contains('pink')) {
      return Colors.pink;
    }

    if (color.contains('brown')) {
      return Colors.brown;
    }

    if (color.contains('grey') ||
        color.contains('gray')) {
      return Colors.grey;
    }

    if (color.contains('beige')) {
      return const Color(0xffD8C3A5);
    }

    if (color.contains('navy')) {
      return const Color(0xff172554);
    }

    if (color.contains('maroon')) {
      return const Color(0xff800000);
    }

    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "Color:",
              style: GoogleFonts.outfit(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),

            const SizedBox(width: 5),

            Text(
              selectedColor ?? "Select a color",
              style: GoogleFonts.outfit(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.white54,
              ),
            ),
          ],
        ),

        const SizedBox(height: 13),

        // ==========================================================
        // COLOR OPTIONS
        // ==========================================================

        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: List.generate(
              colors.length,
              (index) {
                final colorName = colors[index];
                final color = _getColor(colorName);

                final selected =
                    selectedColor == colorName;

                final isWhite =
                    color == Colors.white;

                return GestureDetector(
                  onTap: () {
                    onColorSelected(colorName);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(
                      milliseconds: 200,
                    ),
                    margin: const EdgeInsets.only(
                      right: 12,
                    ),
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: selected
                            ? Colors.white
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: AnimatedScale(
                      duration: const Duration(
                        milliseconds: 200,
                      ),
                      scale: selected ? 1.05 : 1.0,
                      child: Container(
                        height: 34,
                        width: 34,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: isWhite
                              ? Border.all(
                                  color: Colors.white38,
                                )
                              : null,
                        ),
                        child: selected
                            ? Icon(
                                Icons.check,
                                size: 16,
                                color: isWhite
                                    ? Colors.black
                                    : Colors.white,
                              )
                            : null,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}