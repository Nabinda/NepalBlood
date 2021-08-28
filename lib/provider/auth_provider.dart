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
      print(userInfo["Image_URL"]);
      currentUser = UserModel(
          uid: userInfo['User_Id'],
          firstName: userInfo["First_Name"],
          lastName: userInfo["Last_Name"],
          contactNo: userInfo["Contact"],
          localLocation: userInfo["Local_Location"],
          district: userInfo["District"],
          role: userInfo["Role"],
          lat: userInfo["Latitude"],
          long: userInfo["Longitude"],
          imageUrl: userInfo["Image_URL"],
          bloodGroup: userInfo["Blood_Group"],
          status: userInfo["Status"],
          email: userInfo["Email"]);
    }).catchError((error) {
      print(error.toString());
    });
  }

  Future<void> updateVerification(String uid) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .update({"Email_verification": "true"}).catchError((error) {
      print("Error on Updating Verification:" + error.toString());
    });
  }

  Future<void> updateUserInfo(String key, String value) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser.uid)
        .update({key: value}).catchError((error) {
      print("Error on Updating Verification:" + error.toString());
    });
  }

  Future<void> updateUserLocation(Map<String, dynamic> map) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser.uid)
        .update(map)
        .catchError((error) {
      print("Error on Updating Verification:" + error.toString());
    });
  }

  Future<void> updateUserphoto(String imageURL) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser.uid)
        .update({"Image_URL": imageURL}).catchError((error) {
      print("Error on Updating ImageURL:" + error.toString());
    });
  }

  Future<void> updateBloodGroup(String bloodGroup) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser.uid)
        .update({
      "Blood_Group": bloodGroup,
      "Role": "Donor",
      "Status": "Active"
    }).catchError((error) {
      print("Error on Updating Blood Group:" + error.toString());
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
      "Local_Location": userModel.localLocation,
      "District": userModel.district,
      "Latitude": userModel.lat,
      "Longitude": userModel.long,
      "Role": userModel.role,
      "Email": userModel.email,
      "Blood_Group": userModel.bloodGroup,
      "Status": userModel.status,
      "Email_verification": user.emailVerified,
      "Image_URL":
          "https://firebasestorage.googleapis.com/v0/b/nepal-blood-123.appspot.com/o/default_profile.png?alt=media&token=529650be-828d-42ba-bc43-7b9fcc2c5503"
    });
  }

  void addToPrefs() async {
    print(currentUser.uid);
    final userData = json.encode({
      "userId": currentUser.uid,
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

  UserModel getCurrentUser() {
    return currentUser;
  }

  Future<String> onSignOut() async {
    String returnValue = "error";
    try {
      await _firebaseAuth.signOut();
      userInfo = null;
      currentUser = null;
      final prefs = await SharedPreferences.getInstance();
      prefs.clear();
      notifyListeners();
      returnValue = "success";
    } catch (error) {
      print(error);
    }
    return returnValue;
  }
}
