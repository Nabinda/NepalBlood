import 'package:flutter/material.dart';
import 'package:bloodnepal/custom_theme.dart' as style;
class BloodBankScreen extends StatelessWidget {
  static const String routeName = "/blood_bank_screen";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: style.CustomTheme.themeColor,
        title: Text("Blood Bank"),
      ),
    );
  }
}
