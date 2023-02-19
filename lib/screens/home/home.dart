import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wooapp/config/config.dart';
import 'package:wooapp/config/theme.dart';
import 'package:wooapp/screens/cart/cart_screen.dart';
import 'package:wooapp/screens/catalog/catalog_screen.dart';
import 'package:wooapp/screens/featured/featured.dart';
import 'package:wooapp/screens/profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  int _currentTab = 0;
  late List<Widget> _tabs;
  late List<BottomNavigationBarItem> _bottomItems;

  /*[
    BottomNavigationBarItem(icon: Icon(Icons.home), label: tr('tab_home')),
    BottomNavigationBarItem(icon: Icon(Icons.dashboard_rounded), label: tr('tab_search')),
    /*BottomNavigationBarItem(
      label: 'Icon',
      icon: Container(
        padding: EdgeInsets.fromLTRB(4,8,8,8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.indigo,
        ),
        child: FlutterLogo(
          size: 38.0,
        ),
      ),
    ),*/
    BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: tr('tab_cart')),
    BottomNavigationBarItem(icon: Icon(Icons.account_box), label: tr('tab_profile')),
  ];*/

  void _openStore() {
    if (!WooAppConfig.featureHomepage) return;
    setState(() {
      _currentTab = 0;
    });
  }

  @override
  void initState() {
    _bottomItems = [
      if (WooAppConfig.featureHomepage)
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: tr('tab_home'),
        ),
      if (WooAppConfig.featureCatalog)
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard_rounded),
          label: tr('tab_search'),
        ),
      if (WooAppConfig.featureCart)
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: tr('tab_cart'),
        ),
      if (WooAppConfig.featureProfile)
        BottomNavigationBarItem(
          icon: Icon(Icons.account_box),
          label: tr('tab_profile'),
        ),
    ];
    _tabs = [
      if (WooAppConfig.featureHomepage)
        FeaturedScreen(),
      if (WooAppConfig.featureCatalog)
        CatalogScreen(),
      if (WooAppConfig.featureCart)
        CartScreen(
          shoppingCallback: () => _openStore(),
        ),
      if (WooAppConfig.featureProfile)
        ProfileScreen(
          shoppingCallback: () => _openStore(),
        ),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: IndexedStack(
          children: _tabs,
          index: _currentTab,
        ),
        bottomNavigationBar: _buildBottomNavigation(),
      );

  Widget? _buildBottomNavigation() {
    if (_tabs.length < 2) return null;
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      unselectedItemColor: WooAppTheme.colorBottomBarIconNonActive,
      selectedItemColor: WooAppTheme.colorBottomBarIconActive,
      backgroundColor: WooAppTheme.colorBottomBarBackground,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      onTap: (index) {
        setState(() {
          _currentTab = index;
          if (index == _tabs.indexWhere((t) => t is CartScreen)) {
            (_tabs[index] as CartScreen).refresh();
          }
          if (index == _tabs.indexWhere((t) => t is ProfileScreen)) {
            (_tabs[index] as ProfileScreen).onTabOpened();
          }
        });
      },
      currentIndex: _currentTab,
      items: _bottomItems,
    );
  }
}
