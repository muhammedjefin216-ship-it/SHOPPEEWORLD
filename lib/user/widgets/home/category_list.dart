// import 'package:flutter/material.dart';

// class CategoryList extends StatelessWidget {
//   const CategoryList({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final categories = [
//       ("Fashion", Icons.checkroom),
//       ("Shoes", Icons.hiking),
//       ("Watches", Icons.watch),
//       ("Electronics", Icons.devices),
//       ("Beauty", Icons.face),
//     ];

//     return SizedBox(
//       height: 90,
//       child: ListView.separated(
//         scrollDirection: Axis.horizontal,
//         itemCount: categories.length,
//         separatorBuilder: (_, __) => const SizedBox(width: 18),
//         itemBuilder: (_, index) {
//           return Column(
//             children: [
//               CircleAvatar(
//                 radius: 28,
//                 backgroundColor: Colors.grey.shade200,
//                 child: Icon(
//                   categories[index].$2,
//                   color: Colors.black,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 categories[index].$1,
//                 style: const TextStyle(fontSize: 12),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }