
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductDescription extends StatefulWidget {
  final String description;

  const ProductDescription({
    super.key,
    required this.description,
  });

  @override
  State<ProductDescription> createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<ProductDescription> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ==========================================================
        // TITLE
        // ==========================================================

        Text(
          "Description",
          style: GoogleFonts.outfit(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),

        const SizedBox(height: 10),

        // ==========================================================
        // DESCRIPTION
        // ==========================================================

        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          child: Text(
            widget.description,
            maxLines: _isExpanded ? null : 3,
            overflow: _isExpanded
                ? TextOverflow.visible
                : TextOverflow.ellipsis,
            style: GoogleFonts.outfit(
              color: Colors.white54,
              height: 1.6,
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),

        const SizedBox(height: 7),

        // ==========================================================
        // READ MORE / LESS
        // ==========================================================

        GestureDetector(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _isExpanded ? "Read Less" : "Read More",
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 2),
              Icon(
                _isExpanded
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
                size: 17,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ],
    );
  }
}