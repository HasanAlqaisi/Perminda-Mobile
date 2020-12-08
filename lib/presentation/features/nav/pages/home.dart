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
    return Scaffold(
      // body: navigationWidgets[_currentIndex],
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: navigationWidgets,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'home',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.apps_outlined),
            label: 'categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            label: 'cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            label: 'profile',
          ),
        ],
      ),
    );
  }
}
