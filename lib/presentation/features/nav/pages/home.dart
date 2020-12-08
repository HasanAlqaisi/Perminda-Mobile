import 'package:flutter/material.dart';
import 'package:perminda/presentation/features/cart/pages/cart_screen.dart';
import 'package:perminda/presentation/features/categories/pages/categories_screen.dart';
import 'package:perminda/presentation/features/home/pages/home_screen.dart';
import 'package:perminda/presentation/features/profile/pages/profile_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class Home extends StatefulWidget {
  static const String route = '/home';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  PersistentTabController _navController;
  int _currentIndex = 0;
  List<Widget> navigationWidgets = [
    HomeScreen(),
    CategoriesScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _navController = PersistentTabController();
  }

  @override
  void dispose() {
    super.dispose();
    _navController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _navController,
      screens: navigationWidgets,
      items: _buildItems(),
      handleAndroidBackButtonPress: true,
      navBarStyle: NavBarStyle.simple,
      // body: navigationWidgets[_currentIndex],
    );
  }

  List<PersistentBottomNavBarItem> _buildItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home_outlined),
        title: 'home',
        activeColor: Colors.blue,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.apps_outlined),
        title: 'categories',
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.shopping_cart_outlined),
        title: 'cart',
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.person_outlined),
        title: 'profile',
      ),
    ];
  }
}
