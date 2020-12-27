import 'package:bloodnepal/screens/bottom_bar_screen.dart';
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
      home: BottomBarScreen()
    );
  }
}

