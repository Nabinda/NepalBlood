import 'package:bloodnepal/provider/auth_provider.dart';
import 'package:bloodnepal/widgets/message_box.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bloodnepal/custom_theme.dart' as style;
import 'package:provider/provider.dart';

class MessageScreen extends StatefulWidget {
  static const String routeName = "/message_screen";

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  @override
  Widget build(BuildContext context) {
    final userId =
        Provider.of<AuthProvider>(context, listen: false).getCurrentUser().uid;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: style.CustomTheme.themeColor,
        title: Text("Messages"),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Users")
            .doc(userId)
            .collection("Messages")
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text("No Data Found");
          } else {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              child: ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (BuildContext context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    return StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("Users")
                          .doc(ds['donor_id'])
                          .snapshots(),
                      builder: (context, docSnap) {
                        if (!docSnap.hasData) {
                          return Text("No Data Found");
                        } else {
                          return MessageBox(donorName: docSnap.data['First_Name']+" "+ docSnap.data["Last_Name"],
                          donorContact: docSnap.data["Contact"],
                            donorEmail: docSnap.data["Email"],
                            bloodRequestId: ds["blood_request_id"],
                          );

                            Text(docSnap.data['First_Name']);
                        }
                      },
                    );
                  }),
            );
          }
        },
      ),
    );
  }
}
