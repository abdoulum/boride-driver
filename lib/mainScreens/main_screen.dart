import 'package:boride_driver/brand_colors.dart';
import 'package:boride_driver/tabPages/earning_tab.dart';
import 'package:boride_driver/tabPages/home_tab.dart';
import 'package:boride_driver/tabPages/profile_tab.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  int selectedIndex = 0;

  onItemClicked(int index) {
    setState(() {
      selectedIndex = index;
      tabController!.index = selectedIndex;
    });
  }

  @override
  void initState() {
    super.initState();


    tabController = TabController(length: 3, vsync: this);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          controller: tabController,
          children: const [
            HomeTabPage(),
            EarningsTabPage(),
            ProfileTabPage(),
          ],
        ),
        bottomNavigationBar: CustomNavigationBar(
            iconSize: 30.0,
            selectedColor: Colors.blue,
            strokeColor: BrandColors.colorPrimary,
            unSelectedColor: BrandColors.tabAccent,
            backgroundColor: Colors.white,
            items: [
              CustomNavigationBarItem(
                icon: const Icon(Ionicons.home),
                title: const Text(
                  "Home",
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: "Brand-Regular",
                  ),
                ),
              ),
              CustomNavigationBarItem(
                icon: const Icon(Ionicons.card_outline),
                title: const Text(
                  "Earnings",
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: "Brand-Regular",
                  ),
                ),
              ),
              CustomNavigationBarItem(
                icon: const Icon(Ionicons.person_outline),
                title: const Text(
                  "Accounts",
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: "Brand-Regular",
                  ),
                ),
              ),
            ],
            currentIndex: selectedIndex,
            onTap: onItemClicked));
  }
}
