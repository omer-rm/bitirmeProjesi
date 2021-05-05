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
        backgroundColor: CostumColors.petroly_color,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            title: Text(
              "Home",
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.credit_card,
            ),
            title: Text(
              "My profit",
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.star,
            ),
            title: Text(
              "My Rates",
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            title: Text(
              "My profile",
            ),
          ),
        ],
        unselectedItemColor: Colors.white60,
        selectedItemColor: CostumColors.asfar_color,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        onTap: onItemClicked,
        currentIndex: selectIndex,
      ),
    );
  }
}
