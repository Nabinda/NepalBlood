import 'package:bloodnepal/helper/loading_helper.dart';
import 'package:bloodnepal/provider/events_provider.dart';
import 'package:bloodnepal/screens/events_detail_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bloodnepal/custom_theme.dart' as style;
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';
import 'package:bloodnepal/helper/date_format_helper.dart' as dfh;

class AllEvents extends StatefulWidget {
  static const routeName = "/all_events";

  @override
  _AllEventsState createState() => _AllEventsState();
}

class _AllEventsState extends State<AllEvents> {
  final snackBar = SnackBar(content: Text("Events Deleted Successfully"));
  confirmDelete(String id) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Are You Sure?"),
            actions: [
              TextButton(
                  child: Text(
                    "No",
                    style: TextStyle(color: style.CustomTheme.themeColor),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              TextButton(
                  child: Text("Yes",
                      style: TextStyle(color: style.CustomTheme.themeColor)),
                  onPressed: () {
                    Provider.of<EventProvider>(context, listen: false)
                        .deleteEvent(id)
                        .then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      Phoenix.rebirth(context);
                    });
                  }),
            ],
          );
        });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: style.CustomTheme.themeColor,
          title: Text("All Events"),
        ),
        body: Column(
          children: [
            Container(),
            Container(
              height: MediaQuery.of(context).size.height * 0.85,
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection("Events").snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.none)
                    return Text("Check Your Connection");
                  else if (snapshot.hasData)
                    return Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                      child: ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot ds = snapshot.data.docs[index];
                            Timestamp timeInMillis = ds['startDate'];
                            DateTime sDate = DateTime.parse(
                                timeInMillis.toDate().toString());
                            return Container(
                              height: 70,
                              child: InkWell(
                                onTap: () {
                                  Provider.of<EventProvider>(context,
                                          listen: false)
                                      .getEventDetail()
                                      .then((_) {
                                    Navigator.pushNamed(
                                        context, EventsDetailScreen.routeName,
                                        arguments: ds["id"]);
                                  });
                                },
                                child: ListTile(
                                    tileColor: (index % 2 == 0)
                                        ? Colors.white
                                        : style.CustomTheme.themeColor
                                            .withOpacity(0.7),
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(dfh.DateFormatHelper.eventDate
                                            .format(sDate)),
                                        Text(ds["title"]),
                                      ],
                                      //Text
                                    ), //Center
                                    trailing: IconButton(
                                        icon: Icon(Icons.delete),
                                        color: style.CustomTheme.themeColor,
                                        onPressed: () {
                                          confirmDelete(ds["id"]);
                                        })),
                              ),
                            );
                          }),
                    );
                  else if (snapshot.connectionState == ConnectionState.waiting)
                    return Text("Some Error Occurred");
                  else
                    return LoadingHelper(
                      loadingText: "Loading",
                    );
                },
              ),
            ),
          ],
        ));
  }
}
