import 'package:bloodnepal/helper/loading_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:bloodnepal/custom_theme.dart' as style;

class DonorLists extends StatefulWidget {
  static const routeName = "/donor_lists";
  const DonorLists({Key key}) : super(key: key);

  @override
  _DonorListsState createState() => _DonorListsState();
}

class _DonorListsState extends State<DonorLists> {
  final List<String> status = ["All", "Active", "InActive"];
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
  String selectedStatus = "All";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: style.CustomTheme.themeColor,
        title: Text("Donor Lists"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Filter by Status:",
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
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Filter by Blood Group:",
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
            Container(
              height: MediaQuery.of(context).size.height * 0.75,
              child: StreamBuilder<QuerySnapshot>(
                stream: selectedBloodGroup == "All" && selectedStatus == "All"
                    ? FirebaseFirestore.instance
                        .collection('Users')
                        .where('Role', isEqualTo: 'Donor')
                        .snapshots()
                    : selectedStatus == "All"
                        ? FirebaseFirestore.instance
                            .collection('Users')
                            .where('Role', isEqualTo: 'Donor')
                            .where("Blood_Group", isEqualTo: selectedBloodGroup)
                            .snapshots()
                        : selectedBloodGroup == "All"
                            ? FirebaseFirestore.instance
                                .collection('Users')
                                .where("Status", isEqualTo: selectedStatus)
                                .where('Role', isEqualTo: 'Donor')
                                .snapshots()
                            : FirebaseFirestore.instance
                                .collection('Users')
                                .where("Status", isEqualTo: selectedStatus)
                                .where('Role', isEqualTo: 'Donor')
                                .where("Blood_Group",
                                    isEqualTo: selectedBloodGroup)
                                .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.docs.length != 0) {
                      return ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (BuildContext context, index) {
                          DocumentSnapshot ds = snapshot.data.docs[index];
                          return Container(
                            decoration: BoxDecoration(
                                color: index % 2 == 0
                                    ? Colors.white
                                    : style.CustomTheme.themeColor,
                                borderRadius: BorderRadius.circular(15.0)),
                            padding: EdgeInsets.symmetric(
                                horizontal: 5.0, vertical: 5.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: Container(
                                          height: 120,
                                          width: 100,
                                          child: Image.network(
                                            ds["Image_URL"],
                                            fit: BoxFit.cover,
                                          )),
                                    ),
                                    SizedBox(
                                      width: 5.0,
                                    ),
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            ds["First_Name"] +
                                                " " +
                                                ds["Last_Name"],
                                            style: style.CustomTheme.normalText,
                                          ),
                                          Text(
                                            ds["Blood_Group"],
                                            style: style.CustomTheme.normalText,
                                          ),
                                          Text(
                                            ds["Email"],
                                            overflow: TextOverflow.ellipsis,
                                            style: style.CustomTheme.normalText,
                                          ),
                                          Text(
                                            ds["Contact"],
                                            style: style.CustomTheme.normalText,
                                          ),
                                          Text(
                                            ds["Local_Location"] +
                                                ", " +
                                                ds["District"],
                                            overflow: TextOverflow.ellipsis,
                                            style: style.CustomTheme.normalText,
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    } else {
                      return Text("No Result Found!!!");
                    }
                  } else {
                    return LoadingHelper(loadingText: "Searching...");
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
