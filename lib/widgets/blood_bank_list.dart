import 'dart:convert';
import 'package:bloodnepal/helper/loading_helper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class BloodBankList extends StatefulWidget {
  final String unEncodedPath;
  BloodBankList(this.unEncodedPath);
  @override
  _BloodBankListState createState() => _BloodBankListState();
}

class _BloodBankListState extends State<BloodBankList> {
  List data;
  bool isLoading = false;
  _makingPhoneCall(String number) async {
    var url = 'tel:$number';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      return SnackBar(
        content: Text("Something error occurred!!!"),
        duration: Duration(seconds: 3),
      );
    }
  }
  Future fetchData() async{
    Uri url =Uri.https("blood-bank-nepal.herokuapp.com", widget.unEncodedPath);
    http.Response response = await http.get(url);
    data = json.decode(response.body);
    setState(() {
      isLoading = false;
    });
  }
  showContact(String contact){
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Contact"),
            content: Text(contact),
            actions: <Widget>[
              new TextButton(
                  child: new Text('Call'),
                  onPressed: () {
                    _makingPhoneCall(contact);
                  }),
              new TextButton(
                  child: new Text('OK'),
                  onPressed: () {
                    Navigator.pop(context);
                  })
            ],
          );
        });
  }
  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    this.fetchData();
    super.initState();
  }
  @override
  Widget build(BuildContext context)  {
    return isLoading?LoadingHelper(loadingText: "Fetching Bank List"):Container(
      child: ListView.builder(
          itemCount: data.length,
          itemBuilder: (BuildContext context,int index){
            return ListTile(
              title: Text(data[index]["name"],style: TextStyle(
                color: index%2==0?Colors.black:Colors.white
              ),),
              subtitle: Text(data[index]["address"],style: TextStyle(
                  color: index%2==0?Colors.black:Colors.white
              ),),
              tileColor: index%2==0?Colors.white:Color(0xffF99297),
              onTap: (){
                showContact(data[index]["contact"]);
                },
            );
          }),
    );
  }
}
