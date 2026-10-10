import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddressForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final TextEditingController placeController;
  final TextEditingController landmarkController;
  final TextEditingController stateController;
  final TextEditingController districtController;
  final TextEditingController pincodeController;

  const AddressForm({
    super.key,
    required this.nameController,
    required this.phoneController,
    required this.addressController,
    required this.placeController,
    required this.landmarkController,
    required this.stateController,
    required this.districtController,
    required this.pincodeController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ==========================================================
        // SECTION TITLE
        // ==========================================================

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Delivery Address",
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            GestureDetector(
              onTap: () {
                // Keep this for future Add New address functionality.
              },
              child: Text(
                "+ Add New",
                style: GoogleFonts.outfit(
                  color: Colors.white54,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // ==========================================================
        // NAME
        // ==========================================================

        _textField(
          controller: nameController,
          hint: "Full Name",
          icon: Icons.person_outline_rounded,
        ),

        const SizedBox(height: 10),

        // ==========================================================
        // PHONE
        // ==========================================================

        _textField(
          controller: phoneController,
          hint: "Phone Number",
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
        ),

        const SizedBox(height: 10),

        // ==========================================================
        // ADDRESS
        // ==========================================================

        _textField(
          controller: addressController,
          hint: "House / Street Address",
          icon: Icons.home_outlined,
          maxLines: 3,
        ),

        const SizedBox(height: 10),

        // ==========================================================
        // PLACE
        // ==========================================================

        _textField(
          controller: placeController,
          hint: "Place",
          icon: Icons.location_on_outlined,
        ),

        const SizedBox(height: 10),

        // ==========================================================
        // LANDMARK
        // ==========================================================

        _textField(
          controller: landmarkController,
          hint: "Landmark",
          icon: Icons.flag_outlined,
        ),

        const SizedBox(height: 10),

        // ==========================================================
        // DISTRICT + STATE
        // ==========================================================

        Row(
          children: [
            Expanded(
              child: _textField(
                controller: districtController,
                hint: "District",
                icon: Icons.location_city_outlined,
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: _textField(
                controller: stateController,
                hint: "State",
                icon: Icons.map_outlined,
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        // ==========================================================
        // PINCODE
        // ==========================================================

        _textField(
          controller: pincodeController,
          hint: "Pincode",
          icon: Icons.pin_drop_outlined,
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  // ==============================================================
  // TEXT FIELD
  // ==============================================================

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: GoogleFonts.outfit(
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      cursorColor: Colors.white,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.outfit(
          color: Colors.white38,
          fontSize: 12,
        ),
        prefixIcon: Icon(
          icon,
          color: Colors.white70,
          size: 19,
        ),
        filled: true,
        fillColor: const Color(0xff191D1E),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 15,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(.06),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(.06),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(.25),
            width: 1,
          ),
        ),
      ),
    );
  }
}