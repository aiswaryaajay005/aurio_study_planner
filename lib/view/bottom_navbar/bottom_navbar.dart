import 'package:aurio/global_constants/color/color_constants.dart';
import 'package:aurio/view/analytics_screen/analytics_screen.dart';
import 'package:aurio/view/calender_screen/calender_screen.dart';
import 'package:aurio/view/home_screen/home_screen.dart';
import 'package:aurio/view/progress_screen/progress_screen.dart';
import 'package:aurio/view/settings_screen/settings_screen.dart';
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
      StudyPlanScreen(),
      AnalyticsScreen(),
      SettingsScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home_outlined),
        title: "Home",
        activeColorPrimary: ColorConstants.accentColor,
        inactiveColorPrimary: ColorConstants.textColor,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.calendar_today_outlined),
        title: "Tasks",
        activeColorPrimary: ColorConstants.accentColor,
        inactiveColorPrimary: ColorConstants.textColor,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.bar_chart_outlined),
        title: "Stats",
        activeColorPrimary: ColorConstants.accentColor,
        inactiveColorPrimary: ColorConstants.textColor,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.settings),
        title: "Settings",
        activeColorPrimary: ColorConstants.accentColor,
        inactiveColorPrimary: ColorConstants.textColor,
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

      backgroundColor: ColorConstants.backgroundColor,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      hideNavigationBarWhenKeyboardAppears: true,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.black,
        boxShadow: [
          BoxShadow(color: ColorConstants.primaryColor, blurRadius: 12),
        ],
      ),
      navBarHeight: 80.0,
      navBarStyle: NavBarStyle.style1,
    );
  }
}
