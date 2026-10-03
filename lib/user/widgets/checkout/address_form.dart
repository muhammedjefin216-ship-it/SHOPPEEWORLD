// import 'package:flutter/material.dart';

// class AddressForm extends StatelessWidget {
//   final TextEditingController nameController;
//   final TextEditingController phoneController;
//   final TextEditingController addressController;
//   final TextEditingController cityController;
//   final TextEditingController stateController;
//   final TextEditingController pincodeController;

//   const AddressForm({
//     super.key,
//     required this.nameController,
//     required this.phoneController,
//     required this.addressController,
//     required this.cityController,
//     required this.stateController,
//     required this.pincodeController,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           "Delivery Details",
//           style: TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),

//         const SizedBox(height: 20),

//         _textField(
//           controller: nameController,
//           hint: "Full Name",
//           icon: Icons.person_outline,
//         ),

//         const SizedBox(height: 15),

//         _textField(
//           controller: phoneController,
//           hint: "Phone Number",
//           icon: Icons.phone_outlined,
//           keyboardType: TextInputType.phone,
//         ),

//         const SizedBox(height: 15),

//         _textField(
//           controller: addressController,
//           hint: "House / Street Address",
//           icon: Icons.home_outlined,
//           maxLines: 3,
//         ),

//         const SizedBox(height: 15),

//         Row(
//           children: [
//             Expanded(
//               child: _textField(
//                 controller: cityController,
//                 hint: "City",
//                 icon: Icons.location_city_outlined,
//               ),
//             ),

//             const SizedBox(width: 12),

//             Expanded(
//               child: _textField(
//                 controller: stateController,
//                 hint: "State",
//                 icon: Icons.map_outlined,
//               ),
//             ),
//           ],
//         ),

//         const SizedBox(height: 15),

//         _textField(
//           controller: pincodeController,
//           hint: "Pincode",
//           icon: Icons.pin_drop_outlined,
//           keyboardType: TextInputType.number,
//         ),
//       ],
//     );
//   }

//   Widget _textField({
//     required TextEditingController controller,
//     required String hint,
//     required IconData icon,
//     TextInputType? keyboardType,
//     int maxLines = 1,
//   }) {
//     return TextField(
//       controller: controller,
//       keyboardType: keyboardType,
//       maxLines: maxLines,
//       decoration: InputDecoration(
//         hintText: hint,
//         prefixIcon: Icon(
//           icon,
//           color: Colors.black,
//         ),
//         filled: true,
//         fillColor: Colors.white,
//         contentPadding: const EdgeInsets.symmetric(
//           horizontal: 16,
//           vertical: 18,
//         ),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(16),
//           borderSide: BorderSide(
//             color: Colors.grey.shade300,
//           ),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(16),
//           borderSide: BorderSide(
//             color: Colors.grey.shade300,
//           ),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(16),
//           borderSide: const BorderSide(
//             color: Colors.black,
//             width: 1.5,
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddressForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final TextEditingController cityController;
  final TextEditingController stateController;
  final TextEditingController pincodeController;

  const AddressForm({
    super.key,
    required this.nameController,
    required this.phoneController,
    required this.addressController,
    required this.cityController,
    required this.stateController,
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
        // CITY + STATE
        // ==========================================================

        Row(
          children: [
            Expanded(
              child: _textField(
                controller: cityController,
                hint: "City",
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
          icon: Icons.location_on_outlined,
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