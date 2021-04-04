import 'package:bloodnepal/provider/auth_provider.dart';
import 'package:bloodnepal/provider/events_provider.dart';
import 'package:bloodnepal/screens/home_screen.dart';
import 'package:bloodnepal/screens/notification_screen.dart';
import 'package:bloodnepal/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class BottomBarScreen extends StatefulWidget {
  static const routeName = "/bottom_bar_screen";
  @override
  _BottomBarScreenState createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  List<Map<String, Object>> _pages = [];
  int _selectedPageIndex = 0;
  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  void initState() {
    Provider.of<AuthProvider>(context,listen: false).addToPrefs();
    _pages = [
      {'page': HomeScreen(), 'title': "Home"},
      {
        'page': NotificationScreen(),
        'title': "Notification",
      },
      {
        'page': ProfileScreen(),
        'title': "Profile",
      }
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedPageIndex]['page'],
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _selectedPageIndex,
        onTap: _selectPage,
        duration: const Duration(milliseconds: 500),
        unselectedItemColor: Colors.grey,
        selectedItemColor: Color(0xffF77B7F),
        items: [
          SalomonBottomBarItem(
            icon: Icon(Icons.home),
            title: Text("Home"),
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.notifications),
            title: Text("Notification"),
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.person),
            title: Text("Profile"),
          ),
        ],
      ),
    );
  }
}
