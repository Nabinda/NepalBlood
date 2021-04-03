import 'package:flutter/material.dart';
import 'package:bloodnepal/custom_theme.dart' as style;
class BloodBankScreen extends StatefulWidget {
  static const String routeName = "/blood_bank_screen";

  @override
  _BloodBankScreenState createState() => _BloodBankScreenState();
}

class _BloodBankScreenState extends State<BloodBankScreen> {
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
