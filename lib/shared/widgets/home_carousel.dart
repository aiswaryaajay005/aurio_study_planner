import 'package:aurio/features/home_screen/controller/home_screen_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class homeCarousel extends StatelessWidget {
  const homeCarousel({super.key, required this.homeCtrl});

  final HomeScreenController homeCtrl;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: homeCtrl.carouselList.length,
      itemBuilder:
          (context, index, realIndex) => Container(
            margin: EdgeInsets.all(6.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              image: DecorationImage(
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.6),
                  BlendMode.darken,
                ),
                image: NetworkImage(
                  "https://images.pexels.com/photos/1925536/pexels-photo-1925536.jpeg",
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Text(
                homeCtrl.carouselList[index],
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      options: CarouselOptions(
        height: 180.0,
        enlargeCenterPage: true,
        autoPlay: true,
        aspectRatio: 16 / 9,
        autoPlayCurve: Curves.fastOutSlowIn,
        enableInfiniteScroll: true,
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        viewportFraction: 0.8,
      ),
    );
  }
}
