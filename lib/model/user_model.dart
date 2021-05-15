import 'package:flutter/material.dart';

class UserModel {
  String uid;
  String firstName;
  String lastName;
  String contactNo;
  String localLocation;
  String district;
  String bloodGroup;
  String status;
  String email;
  String role;
  String lat;
  String long;
  String imageUrl;
  UserModel(
      {@required this.uid,
      @required this.firstName,
      @required this.lastName,
      @required this.contactNo,
      @required this.localLocation,
      @required this.district,
      @required this.role,
      @required this.lat,
      @required this.long,
      @required this.imageUrl,
      this.status,
      @required this.email,
      this.bloodGroup});
}
