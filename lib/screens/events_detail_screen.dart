import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:bloodnepal/model/event_model.dart';
import 'package:bloodnepal/provider/events_provider.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bloodnepal/custom_theme.dart' as style;
import 'package:bloodnepal/helper/date_format_helper.dart' as dfh;
import 'package:bloodnepal/helper/manage_permission.dart' as mp;
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class EventsDetailScreen extends StatelessWidget {
  //Make Phone Call
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
  //Send Email
  _sendEmail(String email) async {
    var url = 'mailto:$email';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      return SnackBar(
        content: Text("Something error occurred!!!"),
        duration: Duration(seconds: 3),
      );
    }
  }
  //Add Reminder to Calendar
  _addReminder(EventModel toAddEvent, BuildContext context) async {
    bool status = await mp.ManagePermission.isCalendarPermissionGranted();
    if (status) {
      Event event = Event(
        title: toAddEvent.title,
        location: toAddEvent.location,
        endDate: toAddEvent.endDate.add(Duration(hours: toAddEvent.endTime.hour,minutes: toAddEvent.endTime.minute)),
        startDate: toAddEvent.startDate.add(Duration(hours:toAddEvent.startTime.hour,minutes: toAddEvent.startTime.minute )),
        description: toAddEvent.description,
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

  static const routeName = "/events_detail_screen";
  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments;
    final event =
        Provider.of<EventProvider>(context, listen: false).findEventById(id);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Events Details"),
          backgroundColor: style.CustomTheme.themeColor,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: style.CustomTheme.eventTitle,
                  ),
                  Text(event.description)
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ListTile(
              leading: Icon(Icons.access_time,color:  style.CustomTheme.themeColor),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(dfh.DateFormatHelper.eventDate
                      .format(event.startDate)+
                      "-" +
                      dfh.DateFormatHelper.eventDate
                          .format(event.endDate)),
                  Text(formatDate(
                      DateTime(2019, 08, 1, event.startTime.hour, event.startTime.minute),
                      [hh, ':', nn, " ", am]).toString() +
                      " - " +
                      formatDate(
                          DateTime(2019, 08, 1, event.endTime.hour, event.endTime.minute),
                          [hh, ':', nn, " ", am]).toString()),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.location_pin,color:  style.CustomTheme.themeColor),
              title: Text(event.location),
            ),
            //------------------Contacts
            Container(
                padding: EdgeInsets.only(left: 20),
                child: Text("Contact For More Information:",style: TextStyle(
                  decoration: TextDecoration.underline
                ),)),

            ListTile(
              onTap: () {
                _makingPhoneCall(event.contactNo);
              },
              leading: Icon(Icons.call,color:  style.CustomTheme.themeColor),
              title: Text(event.contactNo),
            ),
            ListTile(
              onTap: () {
                _sendEmail(event.email);
              },
              leading: Icon(Icons.email,color:  style.CustomTheme.themeColor,),
              title: Text(event.email),
            ),
            Center(
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: style.CustomTheme.themeColor,
                  primary: Colors.white,
                  elevation: 10,minimumSize: Size(100, 40),),
                  onPressed: () {
                    _addReminder(event, context);
                  },
                  child: Text("Remind Me")),
            ),
            SizedBox(height: 20,),
            Container(
              padding: EdgeInsets.only(left: 20),
              child: Text("Tips: Tap on the provided contacts to make contact"),
            )
          ],
        ));
  }
}
