import 'package:allamvizsga/screens/BusTT/bus_screen.dart';
import 'package:allamvizsga/screens/Culture/culture_screen.dart';
import 'package:allamvizsga/screens/Mainscreens/ProfileScreen/profile_screen.dart';
import 'package:allamvizsga/screens/Mainscreens/ReportScreen/report_screen.dart';
import 'package:allamvizsga/screens/News/news_screen.dart';
import 'package:allamvizsga/screens/test_screen.dart';
import 'package:flutter/material.dart';
import 'package:allamvizsga/screens/Auth/forgot_screen.dart';
import 'package:allamvizsga/screens/Auth/login_screen.dart';
import 'package:allamvizsga/screens/Auth/registration_screen.dart';
import 'package:curved_nav_bar/curved_bar/curved_action_bar.dart';
import 'package:curved_nav_bar/fab_bar/fab_bottom_app_bar_item.dart';
import 'package:curved_nav_bar/flutter_curved_bottom_nav_bar.dart';
import 'package:allamvizsga/providers/controller.dart';
import 'package:provider/provider.dart';
import 'package:flutter/widgets.dart';

class MainScreen extends StatefulWidget {
  final String userId;

  const MainScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late List<Widget> screens; // Declare screens variable

  int _currentIndex = 0;

  Controller controller = Controller();

  @override
  void initState() {
    super.initState();
    screens = [
      NewsScreen(),
      CultureScreen(),
      BusScreen(),
      ProfileScreen(userId: widget.userId),
    ];

    controller.initSetState(setState);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavBar(
        activeColor: Colors.white,
        navBarBackgroundColor: Colors.black,
        inActiveColor: Colors.white,
        appBarItems: [
          FABBottomAppBarItem(
            activeIcon: const Icon(
              Icons.newspaper,
              color: Colors.red,
            ),
            inActiveIcon: const Icon(
              Icons.newspaper,
              color: Colors.white,
            ),
            text: 'news',
          ),
          FABBottomAppBarItem(
            activeIcon: const Icon(
              Icons.account_balance,
              color: Colors.red,
            ),
            inActiveIcon: const Icon(
              Icons.account_balance,
              color: Colors.white,
            ),
            text: 'Culture',
          ),
          FABBottomAppBarItem(
            activeIcon: const Icon(
              Icons.directions_bus,
              color: Colors.red,
            ),
            inActiveIcon: const Icon(
              Icons.directions_bus,
              color: Colors.white,
            ),
            text: 'Bus',
          ),
          FABBottomAppBarItem(
            activeIcon: const Icon(
              Icons.perm_contact_cal_rounded,
              color: Colors.red,
            ),
            inActiveIcon: const Icon(
              Icons.perm_contact_cal_rounded,
              color: Colors.white,
            ),
            text: 'Profile',
          ),
        ],
        actionButton: CurvedActionBar(
          activeIcon: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.orangeAccent,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.add,
              size: 50,
              color: _currentIndex == 1 ? Colors.red : Colors.white,
            ),
          ),
          inActiveIcon: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.add,
              size: 50,
              color: _currentIndex == 0 ? Colors.white : Colors.red,
            ),
          ),
          text: 'Report',
        ),
        bodyItems: screens,
        actionBarView: ReportScreen(),
      ),
      body: screens[_currentIndex],
    );
  }
}
