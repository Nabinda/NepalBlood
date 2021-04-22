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
  Stream<List<BloodRequestModel>> getBloodRequest(){
    return FirebaseFirestore.instance.collection('Blood-Request').snapshots().map((snapShot)=>snapShot.docs.map((e) => BloodRequestModel.fromJson(e.data())).toList());
  }
  // _confirm(String id,String donorId) async{
  //   return showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           title: Text('Are You Sure?'),
  //           actions: <Widget>[
  //             new TextButton(
  //                 child: new Text('No'),
  //                 onPressed: () {
  //                   Navigator.pop(context);
  //                 }),
  //             new TextButton(
  //                 child: new Text('Yes'),
  //                 onPressed: () {
  //                   Provider.of<BloodRequestsProvider>(context,listen: false).updateStatus(id,donorId).whenComplete(()=>complete);
  //                   Navigator.pop(context);
  //                 }),
  //           ],
  //         );
  // });
  // }
  // complete() async{
  //   return showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           title: Text('Donation Request Accepted. \n Do you want to add on reminder?'),
  //           actions: <Widget>[
  //             new TextButton(
  //                 child: new Text('No'),
  //                 onPressed: () {
  //                   Navigator.pop(context);
  //                   Phoenix.rebirth(context);
  //                 }),
  //             new TextButton(
  //                 child: new Text('Yes'),
  //                 onPressed: () {
  //                   Navigator.pop(context);
  //                 }),
  //           ],
  //         );
  //       });
  // }
  @override
  Widget build(BuildContext context) {
  List donorList = Provider.of<List<BloodRequestModel>>(context);
    final userInfo = Provider.of<AuthProvider>(context,listen: false).currentUser;
    final requestList =
    Provider.of<BloodRequestsProvider>(context, listen: false).getBloodRequest();
    final pendingRequest = requestList.where((element) => element.status=="Pending").toList();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: style.CustomTheme.themeColor,
        title: Text("Blood Requests"),
      ),
      body: StreamProvider(
        create: (BuildContext context)=>getBloodRequest(),
        initialData: [Text("Loading")],
        child: Text(donorList[0].name),
      ) 
    );
  }
}
