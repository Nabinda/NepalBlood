import 'package:flutter/material.dart';

import 'package:bloodnepal/custom_theme.dart' as style;

class SearchScreen extends StatelessWidget {
  static const String routeName = "/search_screen";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: style.CustomTheme.themeColor,
        title: Text("Search Donor"),
      ),
    );
  }
}

