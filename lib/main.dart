import 'package:aurio/core/services/local_notification_helper.dart';
import 'package:aurio/core/services/theme_service.dart';
import 'package:aurio/features/auth/view/splash_screen.dart';
import 'package:aurio/features/leaderboards_screen/controller/leaderboard_controller.dart';
import 'package:aurio/features/auth/controller/login_screen_controller.dart';
import 'package:aurio/features/study/controller/daily_plan_controller.dart';
import 'package:aurio/features/home_screen/controller/home_screen_controller.dart';
import 'package:aurio/features/profile_setup/controller/profile_setup_controller.dart';
import 'package:aurio/features/rewards_screen/controller/rewards_controller.dart';
import 'package:aurio/view/missed_tasks_screen/controller/missed_tasks_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:aurio/features/auth/controller/signup_screen_controller.dart';
import 'package:aurio/core/theme/theme_data.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://dzhyuvsfxdjwndeeycni.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImR6aHl1dnNmeGRqd25kZWV5Y25pIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDQ5NDYzMzgsImV4cCI6MjA2MDUyMjMzOH0.Qu6W9Dcmaqw2dFGF0gNVkZMaIf1alHpszUjz1b90FXo',
  );

  await LocalNotificationHelper.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SignupScreenController()),
        ChangeNotifierProvider(create: (context) => LoginScreenController()),
        ChangeNotifierProvider(create: (context) => ProfileSetupController()),
        ChangeNotifierProvider(create: (context) => HomeScreenController()),
        ChangeNotifierProvider(create: (context) => DailyPlanController()),
        ChangeNotifierProvider(create: (context) => RewardsController()),
        ChangeNotifierProvider(create: (context) => ThemeService()),
        ChangeNotifierProvider(create: (context) => MissedTasksController()),
        ChangeNotifierProvider(create: (context) => LeaderboardController()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    themeNotifier.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      title: 'Aurio',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeService.themeMode,
      home: SplashScreen(),
    );
  }
}
