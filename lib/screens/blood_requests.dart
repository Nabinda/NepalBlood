import 'package:bloodnepal/helper/loading_helper.dart';
import 'package:bloodnepal/model/blood_request_model.dart';
import 'package:bloodnepal/provider/auth_provider.dart';
import 'package:bloodnepal/provider/blood_requests_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:bloodnepal/custom_theme.dart'as style;
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';
import 'package:bloodnepal/helper/date_format_helper.dart' as dfh;

class BloodRequests extends StatefulWidget {
  static const routeName = "/blood_requests";

  @override
  _BloodRequestsState createState() => _BloodRequestsState();
}

class _BloodRequestsState extends State<BloodRequests> {
  _confirm(String id,String donorId) async{
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Are You Sure?'),
            actions: <Widget>[
              new TextButton(
                  child: new Text('No'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              new TextButton(
                  child: new Text('Yes'),
                  onPressed: () {
                    Provider.of<BloodRequestsProvider>(context,listen: false).updateStatus(id,donorId).whenComplete(()=>complete);
                    Navigator.pop(context);
                  }),
            ],
          );
  });
  }
  complete() async{
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Donation Request Accepted. \n Do you want to add on reminder?'),
            actions: <Widget>[
              new TextButton(
                  child: new Text('No'),
                  onPressed: () {
                    Navigator.pop(context);
                    Phoenix.rebirth(context);
                  }),
              new TextButton(
                  child: new Text('Yes'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ],
          );
        });
  }
  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<AuthProvider>(context,listen: false).currentUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: style.CustomTheme.themeColor,
        title: Text("Blood Requests"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("Blood-Request").snapshots(),
        builder: (context,snapshot){
          if(!snapshot.hasData){
            return Text("No Data Found");
          }else{
            print(snapshot.data.docs[0]["name"]);
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 5.0),
              child: ListView.builder(itemCount: snapshot.data.docs.length,itemBuilder:(BuildContext context,index){
                DocumentSnapshot ds = snapshot.data.docs[index];
                Timestamp timeInMillis = ds['date'];
                DateTime date = DateTime.parse(timeInMillis.toDate().toString());
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 15.0,vertical: 5.0),
                  decoration: BoxDecoration(
                    color: index%2==0?Colors.white:style.CustomTheme.themeColor,
                    borderRadius: BorderRadius.circular(15.0)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Name: "+ds["name"],style: style.CustomTheme.normalText,),
                      Text("Patient Name: "+ds["patientName"],style: style.CustomTheme.normalText,),
                      Text("Contact: "+ds["contact"],style: style.CustomTheme.normalText,),
                      Text("Location: "+ds["location"],style: style.CustomTheme.normalText,),
                      Text("Blood Group: "+ds["bloodGroup"],style: style.CustomTheme.normalText,),
                      Text("Date: "+dfh.DateFormatHelper.eventDate.format(date),style: style.CustomTheme.normalText,),
                      Text("Time: "+ds["timeHour"].toString()+":"+ds["timeMinute"],style: style.CustomTheme.normalText,),
                      GestureDetector(
                        onTap: () {

                        },
                        child: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(
                              top: 20, left: 30, right: 30, bottom: 10),
                          height: 50,
                          decoration: BoxDecoration(
                            color: index%2==0?style.CustomTheme.themeColor:Colors.white,
                          ),
                          child: Text(
                            'Accept',
                            style: index%2==0?style.CustomTheme.buttonText:style.CustomTheme.blackButtonText,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            );
          }
        },
      ),
    );
  }
}
