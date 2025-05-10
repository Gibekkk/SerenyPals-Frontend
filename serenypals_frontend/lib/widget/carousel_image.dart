import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class ImageCarousel extends StatefulWidget {
  const ImageCarousel({super.key});

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  final List<String> imagePaths = [
    "assets/img/gambarlogin1.png",
    "assets/img/gambarlogin2.png",
    "assets/img/gambarlogin3.png",
  ];

  // ignore: unused_field
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 250,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 2),
            enlargeCenterPage: true,
            viewportFraction: 1.0,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          items:
              imagePaths.map((path) {
                return Image.asset(path, width: 250, fit: BoxFit.cover);
              }).toList(),
        ),
        // Indikator bundar dihilangkan, sehingga bagian ini tidak diperlukan
      ],
    );
  }
}
