import 'package:flutter/material.dart';

enum Status { Active, Offline }

class UserModel {
  String uid;
  String firstName;
  String lastName;
  String contactNo;
  String location;
  String bloodGroup;
  Status status;
  String email;
  String role;
  String lat;
  String long;
  UserModel(
      {@required this.uid,
      @required this.firstName,
      @required this.lastName,
      @required this.contactNo,
      @required this.location,
      @required this.role,
      @required this.lat,
      @required this.long,
      this.status,
      @required this.email,
      this.bloodGroup});
}
