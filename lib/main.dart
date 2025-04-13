import 'package:aurio/global_constants/color/color_constants.dart';
import 'package:aurio/view/splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primaryColor: ColorConstants.backgroundColor),
      home: const SplashScreen(),
    );
  }
}
