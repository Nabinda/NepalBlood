import 'package:bloodnepal/helper/loading_helper.dart';
import 'package:bloodnepal/provider/auth_provider.dart';
import 'package:bloodnepal/screens/login.dart';
import 'package:bloodnepal/widgets/profile_image.dart';
import 'package:bloodnepal/widgets/user_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';
import 'package:bloodnepal/custom_theme.dart' as style;

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = false;
  void logOut() async {
    setState(() {
      _isLoading = true;
    });
    String _returnValue =
        await Provider.of<AuthProvider>(context, listen: false).onSignOut();
    if (_returnValue == "success") {
      Navigator.of(context).pushNamedAndRemoveUntil(
          LoginScreen.routeName, (Route<dynamic> route) => false);
    } else {
      setState(() {
        _isLoading = false;
      });
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Something went wrong. Please try again later!'),
              actions: <Widget>[
                new TextButton(
                    child: new Text('OK'),
                    onPressed: () {
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
        Provider.of<AuthProvider>(context, listen: false).getCurrentUser();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: style.CustomTheme.themeColor,
          title: Text("PROFILE"),
          centerTitle: true,
          actions: [
            IconButton(
                icon: Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                onPressed: logOut)
          ],
        ),
        body: _isLoading
            ? Container(
                height: 500,
                child: Center(child: LoadingHelper(loadingText: "Logging Out")))
            : StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("Users")
                    .doc(userInfo.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState== ConnectionState.done && !snapshot.hasData) {
                    return Text("No Data Found");
                  }else if(snapshot.connectionState==ConnectionState.waiting){
                    return Center(child: LoadingHelper(loadingText: "Wait a moment"));
                  }else if(snapshot.connectionState == ConnectionState.none) {
                    return Text("No Internet Connection Available");
                  }
                    else {
                    DocumentSnapshot ds = snapshot.data;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Center(child: ProfileImage(ds["Image_URL"])),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                              color: style.CustomTheme.themeColor,
                              borderRadius: BorderRadius.circular(15.0)),
                          child: Text("Role:" + ds['Role']),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        userInfo.status != null
                            ? InkWell(
                                onLongPress: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text(
                                              "Do you want to change your status?"),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text("No")),
                                            TextButton(
                                                onPressed: () {
                                                  Provider.of<AuthProvider>(
                                                          context,
                                                          listen: false).updateUserInfo("Status",ds["Status"] == "Active" ? "Inactive" : "Active");
                                                  Navigator.pop(context);
                                                },
                                                child: Text("Yes")),
                                          ],
                                        );
                                      });
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                      color: style.CustomTheme.themeColor,
                                      borderRadius:
                                          BorderRadius.circular(15.0)),
                                  child: Text("Status:" + ds["Status"]),
                                ),
                              )
                            : Container(),
                        userInfo.role == "Donor"
                            ? SizedBox(
                                height: 10.0,
                              )
                            : Container(),
                        userInfo.role == "Donor"
                            ? Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                    color: style.CustomTheme.themeColor,
                                    borderRadius: BorderRadius.circular(15.0)),
                                child:
                                    Text("Blood Group:" + ds["Blood_Group"]),
                              )
                            : Container(),
                        userInfo.status != null
                            ? SizedBox(
                                height: 20,
                              )
                            : null,
                        Text(
                          ds["First_Name"] + " " + ds["Last_Name"],
                          style: style.CustomTheme.eventHeader,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        UserInfo(email: ds["Email"],contact: ds["Contact"],location: ds["Local_Location"]+", "+ds["District"],)
                      ],
                    );
                  }
                }));
  }
}
