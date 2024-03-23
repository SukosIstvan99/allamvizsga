import 'package:flutter/material.dart';
import 'package:allamvizsga/screens/BusTT/bus_screen.dart';
import 'package:allamvizsga/screens/Culture/culture_screen.dart';
import 'package:allamvizsga/screens/Mainscreens/ProfileScreen/profile_screen.dart';
import 'package:allamvizsga/screens/Mainscreens/ReportScreen/report_screen.dart';
import 'package:allamvizsga/screens/News/news_screen.dart';
import 'package:allamvizsga/screens/test_screen.dart';
import 'package:flutter/widgets.dart';

class MainScreen extends StatefulWidget {
  final String userId;

  const MainScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          TabBarView(
            controller: tabController,
            physics: const BouncingScrollPhysics(),
            children: [
              NewsScreen(),
              CultureScreen(),
              ReportScreen(), // Placeholder for the space between icons 2 and 4
              BusScreen(),
              ProfileScreen(userId: widget.userId),
            ],
          ),
          Positioned(
            bottom: 10,
            left: MediaQuery.of(context).size.width * 0.1,
            right: MediaQuery.of(context).size.width * 0.1,
            child: BottomAppBar(
              color: Colors.transparent,
              elevation: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: TabBar(
                  controller: tabController,
                  indicatorColor: Colors.transparent,
                  labelPadding: EdgeInsets.zero,
                  tabs: [
                    Tab(
                      icon: Icon(Icons.newspaper),
                    ),
                    Tab(
                      icon: Icon(Icons.account_balance),
                    ),
                    Tab(
                      icon: Icon(Icons.add,color: Colors.red), // Add the Icons.add icon
                    ),
                    Tab(
                      icon: Icon(Icons.directions_bus),
                    ),
                    Tab(
                      icon: Icon(Icons.perm_contact_cal_rounded),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
