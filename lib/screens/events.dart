import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/material.dart';
import 'package:bloodnepal/custom_theme.dart' as style;
import 'package:permission_handler/permission_handler.dart';

class Events extends StatelessWidget {
  static const String routeName = "/Events_Nearby";
  Event event = Event(
  title: "Birthday",
    description: "Nidhisha Mandevkars Birthday",
    startDate: DateTime.now(),
    location: "Nepal",
    alarmInterval: Duration(hours: 1),
    allDay:false,
    endDate: DateTime(2021,3,26),

  );
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          backgroundColor: style.CustomTheme.themeColor,
          title: Text("Events Nearby"),
        ),
        body: Center(
          child: FlatButton(
            child: Text("Add to Calendar"),
            onPressed: () async{
              var status = await Permission.calendar.status;
              if(!status.isGranted){
                return showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Calendar permission required to add reminder'),
                        actions: <Widget>[
                          new FlatButton(
                              child: new Text('OK'),
                              onPressed: (){
                              openAppSettings();
                                Navigator.pop(context);
                              }
                          )
                        ],
                      );
                    });
              }
              else{
                Add2Calendar.addEvent2Cal(event,androidNoUI: false);
              }
            },
          ),
        ),
    );
  }
}
