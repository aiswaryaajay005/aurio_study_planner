import 'package:aurio/features/leaderboards_screen/view/leaderboards_screen.dart';
import 'package:aurio/shared/constants/color/color_constants.dart';
import 'package:aurio/features/analytics_screen/view/analytics_screen.dart';
import 'package:aurio/features/home_screen/view/home_screen.dart';
import 'package:aurio/view/progress_screen/progress_screen.dart';
import 'package:aurio/features/settings_screen/view/settings_screen.dart';
import 'package:aurio/view/study_plan_screen/study_plan_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({super.key});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  final PersistentTabController _controller = PersistentTabController(
    initialIndex: 0,
  );

  List<Widget> _buildScreens() {
    return [
      HomeScreen(), // You’ll replace these with your actual widgets
      LeaderboardScreen(),
      AnalyticsScreen(),
      SettingsScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home_outlined),
        title: "Home",
        activeColorPrimary: Theme.of(context).colorScheme.secondary,
        inactiveColorPrimary: Theme.of(context).textTheme.bodyLarge?.color,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.leaderboard_outlined),
        title: "Leaderboards",
        activeColorPrimary: Theme.of(context).colorScheme.secondary,
        inactiveColorPrimary: Theme.of(context).textTheme.bodyLarge?.color,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.bar_chart_outlined),
        title: "Stats",
        activeColorPrimary: Theme.of(context).colorScheme.secondary,
        inactiveColorPrimary: Theme.of(context).textTheme.bodyLarge?.color,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.settings),
        title: "Settings",
        activeColorPrimary: Theme.of(context).colorScheme.secondary,
        inactiveColorPrimary: Theme.of(context).textTheme.bodyLarge?.color,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),

      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      hideNavigationBarWhenKeyboardAppears: true,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.black,
        boxShadow: [
          BoxShadow(color: Theme.of(context).primaryColor, blurRadius: 12),
        ],
      ),
      navBarHeight: 80.0,
      navBarStyle: NavBarStyle.style1,
    );
  }
}
