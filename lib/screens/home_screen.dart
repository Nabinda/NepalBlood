import 'package:bloodnepal/provider/auth_provider.dart';
import 'package:bloodnepal/widgets/admin_panel.dart';
import 'package:bloodnepal/widgets/categories.dart';
import 'package:bloodnepal/widgets/curved_design.dart';
import 'package:bloodnepal/widgets/funfacts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum _SelectedTabs {home,notifications,profile}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _selectedTab = _SelectedTabs.home;
  void changeIndexPage(int i){
    setState(() {
      _selectedTab = _SelectedTabs.values[i];
    });
  }
  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<AuthProvider>(context,listen: false).getCurrentUser();
    print("User Id: $userInfo");
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            CurvedDesign(),
            Categories(role:userInfo.role),
            if(userInfo.role=="Admin")
              AdminPanel(),
            FunFacts(),

          ],
        ),
      ),

    );
  }
}
