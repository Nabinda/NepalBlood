import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:bloodnepal/custom_theme.dart' as style;
import 'package:url_launcher/url_launcher.dart';
import 'package:bloodnepal/helper/date_format_helper.dart' as dfh;

class MessageBox extends StatefulWidget {
  final String donorName;
  final String donorContact;
  final String donorEmail;
  final String bloodRequestId;
  MessageBox({
    @required this.donorName,
    @required this.donorContact,
    @required this.donorEmail,
    @required this.bloodRequestId,
  });

  @override
  State<MessageBox> createState() => _MessageBoxState();
}

class _MessageBoxState extends State<MessageBox> {
  TapGestureRecognizer _tapGestureRecognizer;
  @override
  void initState() {
    super.initState();
    _tapGestureRecognizer = TapGestureRecognizer()..onTap = _handleTap;
  }

  @override
  void dispose() {
    _tapGestureRecognizer.dispose();
    super.dispose();
  }

  _handleTap() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
          title: Text("Your Requests"),
            content: Container(
              height: 170,
              child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Blood-Request')
                    .doc(widget.bloodRequestId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if(snapshot.hasData){
                    DocumentSnapshot ds = snapshot.data;
                    Timestamp timeInMillis = ds['date'];
                    DateTime date =
                    DateTime.parse(timeInMillis.toDate().toString());
                    return Column(
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
                      ],
                    );
                  }
                  else{
                    return CircularProgressIndicator();
                  }
                },
              ),
            ),
            actions: [
              TextButton(onPressed: (){
                Navigator.pop(context);
              }, child: Text("OK",style: TextStyle(color: Colors.black),),
              )
            ],
          );
        });
  }

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

  _chooseOption(String email, String contact) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Choose One!!!'),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                new IconButton(
                    icon: Icon(
                      Icons.email,
                      size: 60,
                      color: style.CustomTheme.themeColor,
                    ),
                    onPressed: () {
                      _sendEmail(email);
                    }),
                new IconButton(
                    icon: Icon(
                      Icons.phone,
                      size: 60,
                      color: style.CustomTheme.themeColor,
                    ),
                    onPressed: () {
                      _makingPhoneCall(contact);
                    }),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
      child: Column(
        children: [
          RichText(
            text: TextSpan(
                text: widget.donorName,
                style: style.CustomTheme.eventHeader,
                children: [
                  TextSpan(
                    text: ' accepted your ',
                    style: DefaultTextStyle.of(context).style,
                  ),
                  TextSpan(
                      text: widget.bloodRequestId,
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          decorationColor: style.CustomTheme.themeColor,
                          decorationThickness: 3,
                          fontSize: 16),
                      recognizer: _tapGestureRecognizer),
                  TextSpan(
                    text: ' Blood Request.',
                    style: DefaultTextStyle.of(context).style,
                  )
                ]),
          ),
          GestureDetector(
            onTap: () {
              _chooseOption(widget.donorEmail, widget.donorContact);
            },
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 20, left: 30, right: 30, bottom: 10),
              height: 45,
              decoration: style.CustomTheme.buttonDecoration,
              child: Text(
                'Contact Donor',
                style: style.CustomTheme.buttonText,
              ),
            ),
          ),
          Divider(
            thickness: 3,
            color: style.CustomTheme.themeColor.withOpacity(0.5),
          )
        ],
      ),
    );
  }
}
