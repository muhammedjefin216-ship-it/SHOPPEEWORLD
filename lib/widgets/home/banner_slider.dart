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
        return Stack(
          children: [
            AppNetworkImage(
              imageUrl: banners[index],
              height: 180,
              width: double.infinity,
              borderRadius: BorderRadius.circular(20),
            ),

            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(.65),
                    Colors.transparent,
                  ],
                ),
              ),
            ),

            const Positioned(
              left: 20,
              bottom: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "New Collection",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "UP TO 50% OFF",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
      options: CarouselOptions(
        height: 180,
        viewportFraction: 1,
        autoPlay: true,
        enlargeCenterPage: false,
        autoPlayInterval: const Duration(seconds: 4),
      ),
    );
  }
}