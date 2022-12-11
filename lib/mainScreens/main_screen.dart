import 'package:boride_driver/assistants/assistant_methods.dart';
import 'package:boride_driver/tabPages/earning_tab.dart';
import 'package:boride_driver/tabPages/home_tab.dart';
import 'package:boride_driver/tabPages/profile_tab.dart';
import 'package:boride_driver/widgets/brand_colors.dart';
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
    initialization();
    tabController = TabController(length: 3, vsync: this);
  }

  initialization() {
    AssistantMethods.getBankData(context);
    AssistantMethods.readDriverTotalEarnings(context);
    AssistantMethods.readDriverWeeklyEarnings(context);
    AssistantMethods.readDriverRating(context);
    AssistantMethods.readTripsKeysForOnlineDriver(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
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
            selectedColor: Colors.indigo,
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
                icon: const Icon(Ionicons.card),
                title: const Text(
                  "Earnings",
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: "Brand-Regular",
                  ),
                ),
              ),
              CustomNavigationBarItem(
                icon: const Icon(Ionicons.person),
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
