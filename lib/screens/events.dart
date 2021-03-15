import 'package:flutter/material.dart';
import 'package:bloodnepal/custom_theme.dart' as style;

class Events extends StatelessWidget {
  static const String routeName = "/Events_Nearby";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: style.CustomTheme.themeColor,
        title: Text("Events Nearby"),
      ),
    );
  }
}
