import 'dart:convert';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bloodnepal/custom_theme.dart' as style;
import 'package:http/http.dart' as http;
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
   List<BloodBankModel> bankModel = [];
   var fetchedData;
  final url = "blood-bank-nepal.herokuapp.com";
  final insideKTMURL = '/inside_kathmandu';
  Future<void> fetchBloodBankInsideKathmandu() async{
    final response = await http.get(Uri.https(url, insideKTMURL));
    if(response.statusCode==200){
       var decoded = json.decode(response.body) ;
     
    }else{
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error fetching data. Error Code:'+response.statusCode.toString()),
              actions: <Widget>[
                new TextButton(
                    child: new Text('OK'),
                    onPressed: () {
                      Navigator.pop(context);
                    })
              ],
            );
          });
    }
  }
  @override
  void initState() {
  fetchedData = fetchBloodBankInsideKathmandu();
  print(fetchedData);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: style.CustomTheme.themeColor,
        title: Text("Blood Bank"),
      ),
      body: Text(""),
    );
  }
}
