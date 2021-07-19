import 'package:bloodnepal/widgets/blood_bank_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bloodnepal/custom_theme.dart' as style;
class BloodBankModel {
  String name;
  String location;
  String contact;
  BloodBankModel({
    @required this.name,
    @required this.location,
    @required this.contact,
  });
}
class BloodBankScreen extends StatefulWidget {
  static const String routeName = "/blood_bank_screen";

  @override
  _BloodBankScreenState createState() => _BloodBankScreenState();
}

class _BloodBankScreenState extends State<BloodBankScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: style.CustomTheme.themeColor,
          title: Text("Blood Bank"),
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: [
            Tab(text: "Inside Valley",),
            Tab(text: "Outside Valley",)
          ],

          ),
        ),
        body: TabBarView(
          children: [
            BloodBankList("/inside_kathmandu"),
            BloodBankList("/outside_kathmandu"),
          ],
        ),

      ),
    );
  }
}
