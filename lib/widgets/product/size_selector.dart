import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SizeSelector extends StatefulWidget {
  final String? selectedSize;
  final ValueChanged<String> onSizeSelected;

  const SizeSelector({
    super.key,
    required this.selectedSize,
    required this.onSizeSelected,
  });

  @override
  State<SizeSelector> createState() =>
      _SizeSelectorState();
}

class _SizeSelectorState
    extends State<SizeSelector> {
  final List<String> sizes = [
    "UK 7",
    "UK 8",
    "UK 9",
    "UK 10",
    "UK 11",
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Select Size",
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight:
                    FontWeight.bold,
                color:
                    Colors.black87,
              ),
            ),

            TextButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Size Guide: Standard UK sizing applies.",
                      style:
                          GoogleFonts.outfit(),
                    ),
                    behavior:
                        SnackBarBehavior.floating,
                  ),
                );
              },
              icon: const Icon(
                Icons.rule,
                size: 16,
                color:
                    Colors.black54,
              ),
              label: Text(
                "Size Guide",
                style:
                    GoogleFonts.outfit(
                  color:
                      Colors.black54,
                  fontSize: 14,
                  fontWeight:
                      FontWeight.w600,
                  decoration:
                      TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        SizedBox(
          height: 48,
          child: ListView.separated(
            scrollDirection:
                Axis.horizontal,

            itemCount:
                sizes.length,

            separatorBuilder:
                (_, __) =>
                    const SizedBox(
                  width: 12,
                ),

            itemBuilder:
                (context, index) {
              final size =
                  sizes[index];

              final isSelected =
                  widget.selectedSize ==
                      size;

              return GestureDetector(
                onTap: () {
                  widget.onSizeSelected(
                    size,
                  );
                },

                child:
                    AnimatedContainer(
                  duration:
                      const Duration(
                    milliseconds: 200,
                  ),

                  padding:
                      const EdgeInsets
                          .symmetric(
                    horizontal: 20,
                  ),

                  decoration:
                      BoxDecoration(
                    color: isSelected
                        ? Colors.black
                        : Colors.grey
                            .shade50,

                    borderRadius:
                        BorderRadius
                            .circular(
                      14,
                    ),

                    border:
                        Border.all(
                      color: isSelected
                          ? Colors.black
                          : Colors.grey
                              .shade200,
                      width: 1.5,
                    ),
                  ),

                  child: Center(
                    child: Text(
                      size,

                      style:
                          GoogleFonts.outfit(
                        color: isSelected
                            ? Colors.white
                            : Colors.black87,

                        fontWeight:
                            FontWeight.bold,

                        fontSize: 14,
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