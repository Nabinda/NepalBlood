import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bloodnepal/custom_theme.dart' as style;
import 'package:bloodnepal/helper/date_format_helper.dart' as dfh;

class BloodRequestStatus extends StatefulWidget {
  static const routeName = "/blood_request_status";
  const BloodRequestStatus({Key key}) : super(key: key);

  @override
  _BloodRequestStatusState createState() => _BloodRequestStatusState();
}

class _BloodRequestStatusState extends State<BloodRequestStatus> {
  final List<String> status = ["All", "Pending", "Accepted", "Failed"];
  String selectedStatus = "All";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: style.CustomTheme.themeColor,
        title: Text("Blood Request Status"),
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
                  "Filter By Status:",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  width: 20,
                ),
                DropdownButton<String>(
                  iconEnabledColor: style.CustomTheme.themeColor,
                  dropdownColor: style.CustomTheme.themeColor,
                  items: status.map((dropdownItem) {
                    return DropdownMenuItem<String>(
                      value: dropdownItem,
                      child: Text(dropdownItem),
                    );
                  }).toList(),
                  value: selectedStatus,
                  onChanged: (value) {
                    setState(() {
                      selectedStatus = value;
                    });
                  },
                ),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.8,
            child: StreamBuilder<QuerySnapshot>(
              stream: selectedStatus == "All"
                  ? FirebaseFirestore.instance
                      .collection("Blood-Request")
                      .snapshots()
                  : selectedStatus == "Failed"
                  ? FirebaseFirestore.instance
                  .collection("Blood-Request")
                  .where("status", isEqualTo: "Pending")
                  .where("date", isLessThan: DateTime.now())
                  .orderBy("date")
                  .snapshots()
                  :FirebaseFirestore.instance
                          .collection("Blood-Request")
                          .where("status", isEqualTo: selectedStatus)
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
                          return Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 5.0),
                            decoration: BoxDecoration(
                                color: index % 2 == 0
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
                                Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.only(
                                      top: 20, left: 30, right: 30, bottom: 10),
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: index % 2 == 0
                                        ? style.CustomTheme.themeColor
                                        : Colors.white,
                                  ),
                                  child: Text(
                                    DateTime.now()
                                                .difference(date)
                                                .isNegative &&
                                            ds['status'] != "Accepted"
                                        ? 'Pending'
                                        : DateTime.now()
                                                .difference(date)
                                                .isNegative
                                            ? 'Accepted'
                                            : 'Failed to Donate',
                                    style: index % 2 == 0
                                        ? style.CustomTheme.buttonText
                                        : style.CustomTheme.blackButtonText,
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
          ),
        ],
      ),
    );
  }
}
