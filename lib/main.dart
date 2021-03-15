import 'package:bloodnepal/screens/blood_bank.dart';
import 'package:bloodnepal/screens/bottom_bar_screen.dart';
import 'package:bloodnepal/screens/donor_screen.dart';
import 'package:bloodnepal/screens/events.dart';
import 'package:bloodnepal/screens/search_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nepal Blood',
      home: BottomBarScreen(),
        routes: {
      Events.routeName:(ctx)=>Events(),
      SearchScreen.routeName:(ctx)=>SearchScreen(),
      BloodBankScreen.routeName:(ctx)=>BloodBankScreen(),
      DonorScreen.routeName:(ctx)=>DonorScreen(),
    },
    );
  }
}

