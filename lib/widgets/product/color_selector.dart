import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ColorSelector extends StatelessWidget {
  final String? selectedColor;
  final ValueChanged<String> onColorSelected;

  const ColorSelector({
    super.key,
    required this.selectedColor,
    required this.onColorSelected,
  });

  final List<Color> colors = const [
    Colors.black,
    Colors.white,
    Colors.blue,
    Colors.red,
  ];

  final List<String> colorNames = const [
    "Midnight Black",
    "Off White",
    "Ocean Blue",
    "Crimson Red",
  ];

  @override
  Widget build(BuildContext context) {
    final selectedIndex =
        selectedColor == null
            ? 0
            : colorNames.indexOf(selectedColor!);

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        // ============================================================
        // SELECTED COLOR NAME
        // ============================================================

        Row(
          children: [
            Text(
              "Color: ",
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            Text(
              selectedColor ?? "Select a color",
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // ============================================================
        // COLOR LIST
        // ============================================================

        Row(
          children: List.generate(
            colors.length,
            (index) {
              final color = colors[index];

              final selected =
                  selectedColor ==
                      colorNames[index];

              final isWhite =
                  color == Colors.white;

              return GestureDetector(
                onTap: () {
                  onColorSelected(
                    colorNames[index],
                  );
                },

                child: AnimatedContainer(
                  duration:
                      const Duration(
                    milliseconds: 200,
                  ),

                  margin:
                      const EdgeInsets.only(
                    right: 16,
                  ),

                  padding:
                      const EdgeInsets.all(
                    3,
                  ),

                  decoration:
                      BoxDecoration(
                    shape:
                        BoxShape.circle,

                    border:
                        Border.all(
                      color: selected
                          ? (isWhite
                              ? Colors
                                  .grey
                                  .shade400
                              : color)
                          : Colors
                              .transparent,

                      width: 2,
                    ),
                  ),

                  child: AnimatedScale(
                    duration:
                        const Duration(
                      milliseconds: 200,
                    ),

                    scale:
                        selected ? 1.05 : 0.95,

                    child: CircleAvatar(
                      radius: 18,

                      backgroundColor:
                          color,

                      child: isWhite
                          ? Container(
                              decoration:
                                  BoxDecoration(
                                shape:
                                    BoxShape.circle,
                                border:
                                    Border.all(
                                  color: Colors
                                      .grey
                                      .shade300,
                                ),
                              ),

                              child: selected
                                  ? const Center(
                                      child:
                                          Icon(
                                        Icons
                                            .check,
                                        size:
                                            16,
                                        color: Colors
                                            .black,
                                      ),
                                    )
                                  : null,
                            )
                          : selected
                              ? const Icon(
                                  Icons.check,
                                  size: 16,
                                  color:
                                      Colors.white,
                                )
                              : null,
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