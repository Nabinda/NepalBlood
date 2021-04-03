import 'dart:convert';

import 'package:bloodnepal/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  Map<String, dynamic> userInfo;
  UserModel currentUser;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Future<void> getCurrentUserInfo(String uid) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .get()
        .then((DocumentSnapshot docs) {
      userInfo = docs.data();
      currentUser = UserModel(
          uid: userInfo['User_Id'],
          firstName: userInfo["First_Name"],
          lastName: userInfo["Last_Name"],
          contactNo: userInfo["Contact"],
          location: userInfo["Location"],
          role: userInfo["Role"],
          lat: userInfo["Latitude"],
          long: userInfo["Longitude"],
          bloodGroup: userInfo["Blood_Group"],
          status: userInfo["Status"],
          email: userInfo["Email"]);
    }).catchError((error) {
      print(error.toString());
    });
  }
  Future<void> updateVerification(String uid) async{
    await FirebaseFirestore.instance.collection('Users').doc(uid).update({
      "Email_verification":true
    }).catchError((error){
      print("Error on Updating Verification:"+error.toString());
    });
  }
  Future<void> addUserInfo(UserModel userModel) async {
    var user = _firebaseAuth.currentUser;
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(userModel.uid)
        .set({
      "First_Name": userModel.firstName,
      "Last_Name": userModel.lastName,
      "Contact": userModel.contactNo,
      "User_Id": userModel.uid,
      "Location": userModel.location,
      "Latitude": userModel.lat,
      "Longitude": userModel.long,
      "Role": userModel.role,
      "Email":userModel.email,
      "Blood_Group":userModel.bloodGroup,
      "Status":userModel.status,
      "Email_verification": user.emailVerified,
      "Phone_verification": false
    });
  }
  void addToPrefs() async{
    final userData = json.encode({
      "userId":currentUser.uid,
    });
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("userData", userData);
  }
  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("userData")) {
      return false;
    }
    final extractedData =
    json.decode(prefs.getString("userData")) as Map<String, Object>;
    await getCurrentUserInfo(extractedData['userId']);
    notifyListeners();
    return true;
  }
  UserModel getCurrentUser(){
    return currentUser;
}
}
