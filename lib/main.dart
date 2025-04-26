import 'package:aurio/controller/login_screen_scontroller.dart';
import 'package:aurio/controller/signup_screen_controller.dart';
import 'package:aurio/global_constants/color/color_constants.dart';
import 'package:aurio/view/bottom_navbar/bottom_navbar.dart';
import 'package:aurio/view/splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://dzhyuvsfxdjwndeeycni.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImR6aHl1dnNmeGRqd25kZWV5Y25pIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDQ5NDYzMzgsImV4cCI6MjA2MDUyMjMzOH0.Qu6W9Dcmaqw2dFGF0gNVkZMaIf1alHpszUjz1b90FXo',
  );
  runApp(MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LoginScreenController()),
        ChangeNotifierProvider(create: (context) => SignupScreenController()),
      ],
      child: MaterialApp(
        title: 'Aurio Study Panner',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primaryColor: ColorConstants.backgroundColor),
        home: const BottomNavbar(),
      ),
    );
  }
}
