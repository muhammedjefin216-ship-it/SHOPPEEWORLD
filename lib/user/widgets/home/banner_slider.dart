// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';

// import '../common/app_network_image.dart';

// class BannerSlider extends StatelessWidget {
//   const BannerSlider({super.key});

//   static const List<String> banners = [
//     "https://images.unsplash.com/photo-1523381210434-271e8be1f52b?w=1200",
//     "https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=1200",
//     "https://images.unsplash.com/photo-1483985988355-763728e1935b?w=1200",
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return CarouselSlider.builder(
//       itemCount: banners.length,
//       itemBuilder: (context, index, realIndex) {
//         return Stack(
//           children: [
//             AppNetworkImage(
//               imageUrl: banners[index],
//               height: 180,
//               width: double.infinity,
//               borderRadius: BorderRadius.circular(20),
//             ),

//             Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(20),
//                 gradient: LinearGradient(
//                   begin: Alignment.bottomCenter,
//                   end: Alignment.topCenter,
//                   colors: [
//                     Colors.black.withOpacity(.65),
//                     Colors.transparent,
//                   ],
//                 ),
//               ),
//             ),

//             const Positioned(
//               left: 20,
//               bottom: 20,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "New Collection",
//                     style: TextStyle(
//                       color: Colors.white70,
//                       fontSize: 14,
//                     ),
//                   ),
//                   SizedBox(height: 6),
//                   Text(
//                     "UP TO 50% OFF",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         );
//       },
//       options: CarouselOptions(
//         height: 180,
//         viewportFraction: 1,
//         autoPlay: true,
//         enlargeCenterPage: false,
//         autoPlayInterval: const Duration(seconds: 4),
//       ),
//     );
//   }
// }

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../common/app_network_image.dart';

class BannerSlider extends StatelessWidget {
  const BannerSlider({super.key});

  static const List<String> banners = [
    "https://images.unsplash.com/photo-1523381210434-271e8be1f52b?w=1200",
    "https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=1200",
    "https://images.unsplash.com/photo-1483985988355-763728e1935b?w=1200",
  ];

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: banners.length,
      itemBuilder: (context, index, realIndex) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background image
              AppNetworkImage(
                imageUrl: banners[index],
                height: double.infinity,
                width: double.infinity,
                borderRadius: BorderRadius.circular(14),
              ),

              // Dark overlay
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.black.withOpacity(.55),
                      Colors.black.withOpacity(.15),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),

              // Banner content
              const Positioned(
                left: 20,
                top: 35,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "New Arrivals",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    SizedBox(height: 4),

                    Text(
                      "Up to 50% Off",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),

                    SizedBox(height: 14),

                    // Shop Now button
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(9),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 8,
                        ),
                        child: Text(
                          "Shop Now",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },

      options: CarouselOptions(
        height: 155,
        viewportFraction: 1,
        autoPlay: true,
        enlargeCenterPage: false,
        autoPlayInterval: const Duration(seconds: 4),
      ),
    );
  }
}