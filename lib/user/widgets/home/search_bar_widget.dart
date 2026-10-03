// import 'package:flutter/material.dart';

// class SearchBarWidget extends StatelessWidget {
//   const SearchBarWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       readOnly: true,
//       decoration: InputDecoration(
//         hintText: "Search products...",
//         prefixIcon: const Icon(Icons.search),
//         suffixIcon: const Icon(Icons.tune),
//         filled: true,
//         fillColor: Colors.grey.shade100,
//         contentPadding: const EdgeInsets.symmetric(vertical: 18),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(16),
//           borderSide: BorderSide.none,
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: TextField(
        readOnly: true,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
        decoration: InputDecoration(
          hintText: "Search for products...",
          hintStyle: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),

          // Search icon
          prefixIcon: const Icon(
            Icons.search,
            color: Colors.white,
            size: 21,
          ),

          // Filter icon
          suffixIcon: const Icon(
            Icons.tune,
            color: Colors.white70,
            size: 19,
          ),

          filled: true,
          fillColor: const Color(0xff191D1E),

          contentPadding: const EdgeInsets.symmetric(
            vertical: 0,
          ),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: BorderSide.none,
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: BorderSide.none,
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}