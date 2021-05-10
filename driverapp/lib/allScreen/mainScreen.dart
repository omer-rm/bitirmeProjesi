import 'package:flutter/material.dart';
import '../TabPages/ProfileTabPage.dart';
import '../TabPages/earningsPage.dart';
import '../TabPages/hometabPage.dart';
import '../TabPages/ratingPage.dart';
import '../allwidgets/CustomColors.dart';

class MainScreen extends StatefulWidget {
  static const String idScreen = 'mainScreen';
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  TabController tabController;

  int selectIndex = 0;

  void onItemClicked(int index) {
    setState(() {
      selectIndex = index;
      tabController.index = selectIndex;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: tabController,
        children: [
          HomeTabPage(),
          EarningsTabPage(),
          RatingTabPage(),
          ProfileTabPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.red,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card),
            label: "My profit",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: "My Rates",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "My profile",
          ),
        ],
        unselectedItemColor: Colors.white,
        selectedItemColor: CostumColors.asfar_color,
        type: BottomNavigationBarType.shifting,
        showUnselectedLabels: true,
        onTap: onItemClicked,
        currentIndex: selectIndex,
      ),
    );
  }
}
