
import 'package:bloodnepal/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Future<void> addUserInfo(UserModel userModel) async{
    var user = _firebaseAuth.currentUser;
    await FirebaseFirestore.instance.collection('Users').doc(userModel.uid).set(
      {
        "First_Name":userModel.firstName,
        "Last_Name":userModel.lastName,
        "Contact":userModel.contactNo,
        "User_Id":userModel.uid,
        "Location":userModel.location,
        "Latitude":userModel.lat,
        "Longitude":userModel.long,
        "Role":userModel.role,
        "Email_verification":user.emailVerified,
        "Phone_verification":false
      }
    );
  }
}
