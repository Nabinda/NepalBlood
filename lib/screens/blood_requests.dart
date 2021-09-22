import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:bloodnepal/model/user_model.dart';
import 'package:bloodnepal/provider/auth_provider.dart';
import 'package:bloodnepal/provider/blood_requests_provider.dart';
import 'package:bloodnepal/provider/messages_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bloodnepal/custom_theme.dart' as style;
import 'package:bloodnepal/helper/manage_permission.dart' as mp;
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:bloodnepal/helper/date_format_helper.dart' as dfh;
class BloodRequests extends StatefulWidget {
  static const routeName = "/blood_requests";

  @override
  _BloodRequestsState createState() => _BloodRequestsState();
}

class _BloodRequestsState extends State<BloodRequests> {
  UserModel currentUser;
  String name;
  String location;
  DateTime dateTime;
  String hour;
  String minute;
  String description;
  bool connection = false;
  final List<String> bloodGroupCategories = [
    "All",
    "O+",
    "O-",
    "A+",
    "A-",
    "B+",
    "B-",
    "AB+",
    "AB-"
  ];
  String selectedBloodGroup = "All";

  bool checkDonorStatus(UserModel userInfo){
    print(userInfo.status);
    if(userInfo.status=="Inactive"){
      return false;
    }else if(userInfo.status == "Active"){
      return true;
    }else{
      return false;
    }
  }
  _confirm(String id, UserModel userInfo) async {
    bool status = checkDonorStatus(userInfo);
    print(status);
    return status? showDialog(
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
                    Provider.of<BloodRequestsProvider>(context, listen: false)
                        .updateStatus(id, userInfo.uid)
                        .whenComplete(() {
                      Provider.of<MessageProvider>(context, listen: false)
                          .createMessage(userInfo.uid, id)
                          .whenComplete(() {
                        complete();
                      });
                    }());
                    Navigator.pop(context);
                  }),
            ],
          );
        }):showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('You need some rest.'),
            actions: <Widget>[
              new TextButton(
                  child: new Text('Ok'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ],
          );
        });
  }

  complete() async {
    Provider.of<AuthProvider>(context, listen: false)
        .updateUserInfo("Status", "Inactive");
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
                'Donation Request Accepted. \n Do you want to add on reminder?'),
            actions: <Widget>[
              new TextButton(
                  child: new Text('No'),
                  onPressed: () {
                    Phoenix.rebirth(context);
                    Navigator.pop(context);
                  }),
              new TextButton(
                  child: new Text('Yes'),
                  onPressed: () {
                    _addReminder(context);
                  }),
            ],
          );
        });
  }

  _addReminder(BuildContext context) async {
    bool status = await mp.ManagePermission.isCalendarPermissionGranted();
    if (status) {
      Event event = Event(
        title: "Blood Donation to $name",
        location: location,
        endDate: dateTime
            .add(Duration(hours: int.parse(hour), minutes: int.parse(minute))),
        startDate: dateTime
            .add(Duration(hours: int.parse(hour), minutes: int.parse(minute))),
        description: description,
      );
      Add2Calendar.addEvent2Cal(event, androidNoUI: false);
    } else {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Calendar permission required to add reminder'),
              actions: <Widget>[
                new TextButton(
                    child: new Text('OK'),
                    onPressed: () {
                      openAppSettings();
                      Navigator.pop(context);
                    })
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userInfo =
        Provider.of<AuthProvider>(context, listen: false).currentUser;
    int themeColor = 0;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: style.CustomTheme.themeColor,
        title: Text("Blood Requests"),
      ),
      body: Column(
        children: [
          Container(
            height: 50,
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Filter Blood Group:",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  width: 20,
                ),
                DropdownButton<String>(
                  iconEnabledColor: style.CustomTheme.themeColor,
                  dropdownColor: style.CustomTheme.themeColor,
                  items: bloodGroupCategories.map((dropdownItem) {
                    return DropdownMenuItem<String>(
                      value: dropdownItem,
                      child: Text(dropdownItem),
                    );
                  }).toList(),
                  value: selectedBloodGroup,
                  onChanged: (value) {
                    setState(() {
                      selectedBloodGroup = value;
                    });
                  },
                ),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.8,
            child: StreamBuilder<QuerySnapshot>(
              stream: selectedBloodGroup == "All"
                  ? FirebaseFirestore.instance
                      .collection("Blood-Request")
                      .snapshots()
                  : FirebaseFirestore.instance
                      .collection("Blood-Request")
                      .where("bloodGroup", isEqualTo: selectedBloodGroup)
                      .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Text("No Data Found");
                } else {
                  return Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                    child: ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (BuildContext context, index) {
                          DocumentSnapshot ds = snapshot.data.docs[index];
                          Timestamp timeInMillis = ds['date'];
                          DateTime date =
                              DateTime.parse(timeInMillis.toDate().toString());
                          if (DateTime.now().difference(date).isNegative &&
                              ds['status'] != "Accepted") {
                            themeColor++;
                            return Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 5.0),
                              decoration: BoxDecoration(
                                  color: themeColor % 2 == 0
                                      ? Colors.white
                                      : style.CustomTheme.themeColor,
                                  borderRadius: BorderRadius.circular(15.0)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Name: " + ds["name"],
                                    style: style.CustomTheme.normalText,
                                  ),
                                  Text(
                                    "Patient Name: " + ds["patientName"],
                                    style: style.CustomTheme.normalText,
                                  ),
                                  Text(
                                    "Contact: " + ds["contact"],
                                    style: style.CustomTheme.normalText,
                                  ),
                                  Text(
                                    "Location: " + ds["location"],
                                    style: style.CustomTheme.normalText,
                                  ),
                                  Text(
                                    "Blood Group: " + ds["bloodGroup"],
                                    style: style.CustomTheme.normalText,
                                  ),
                                  Text(
                                    "Date: " +
                                        dfh.DateFormatHelper.eventDate
                                            .format(date),
                                    style: style.CustomTheme.normalText,
                                  ),
                                  Text(
                                    "Time: " +
                                        ds["timeHour"].toString() +
                                        ":" +
                                        ds["timeMinute"],
                                    style: style.CustomTheme.normalText,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      name = ds['patientName'];
                                      location = ds['location'];
                                      dateTime = date;
                                      hour = ds["timeHour"].toString();
                                      minute = ds["timeMinute"].toString();
                                      description =
                                          "Blood Group:" + ds["bloodGroup"];
                                      currentUser = userInfo;
                                      _confirm(ds['id'], userInfo);
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.only(
                                          top: 20,
                                          left: 30,
                                          right: 30,
                                          bottom: 10),
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: themeColor % 2 == 0
                                            ? style.CustomTheme.themeColor
                                            : Colors.white,
                                      ),
                                      child: Text(
                                        'Accept',
                                        style: themeColor % 2 == 0
                                            ? style.CustomTheme.buttonText
                                            : style.CustomTheme.blackButtonText,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else
                            return Container();
                        }),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
