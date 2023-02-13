import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:untitled/constants/colors.dart';
import 'package:untitled/screens/cart/cart_screen.dart';
import 'package:untitled/screens/catalog/catalog_screen.dart';
import 'package:untitled/screens/featured/featured.dart';
import 'package:untitled/screens/profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  int _currentTab = 0;

  late List<Widget> _tabs;

  List<BottomNavigationBarItem> _bottomItems = [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: tr('tab_home')),
    BottomNavigationBarItem(icon: Icon(Icons.dashboard_rounded), label: tr('tab_search')),

    // BottomNavigationBarItem(
    //   label: 'Icon',
    //   icon: Container(
    //     padding: EdgeInsets.fromLTRB(4,8,8,8),
    //     decoration: BoxDecoration(
    //       shape: BoxShape.circle,
    //       color: Colors.indigo,
    //     ),
    //     child: FlutterLogo(
    //       size: 38.0,
    //     ),
    //   ),
    // ),

    BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: tr('tab_cart')),
    BottomNavigationBarItem(icon: Icon(Icons.account_box), label: tr('tab_profile')),
  ];

  void _openStore() {
    setState(() {
      _currentTab = 0;
    });
  }

  @override
  void initState() {
    super.initState();
    _tabs = [
      FeaturedScreen(),
      CatalogScreen(),
      CartScreen(() => _openStore()),
      ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: _tabs[_currentTab],
      body: IndexedStack(
        children: _tabs,
        index: _currentTab,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: AppColor.bottomBarIconUnselected,
        selectedItemColor: AppColor.bottomBarIconSelected,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          setState(() {
            _currentTab = index;
            if (index == 2) {
              (_tabs[2] as CartScreen).refresh();
            }
          });
        },
        currentIndex: _currentTab,
        items: _bottomItems,
      ),
    );
  }
}
