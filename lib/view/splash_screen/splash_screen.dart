import 'dart:async';

import 'package:aurio/global_constants/color/color_constants.dart';
import 'package:aurio/view/login_screen/login_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Image.asset('assets/images/lightlogo.png', width: 200, height: 200),
            const SizedBox(height: 20),
            Text(
              'Plan Smarter, Study Lighter',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: ColorConstants.TextColor,
              ),
            ),
            SizedBox(height: 30),
            CircularProgressIndicator(color: ColorConstants.primaryColor),
          ],
        ),
      ),
    );
  }
}
