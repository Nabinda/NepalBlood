import 'package:flutter/material.dart';

class BloodRequestModel{
  String id;
  String name;
  String patientName;
  String contact;
  DateTime date;
  TimeOfDay time;
  String bloodGroup;
  String location;
  String status;
  String donorId;
  BloodRequestModel({
    @required this.id,
    @required this.name,
    @required this.patientName,
    @required this.bloodGroup,
    @required this.date,
    @required this.time,
    @required this.contact,
    @required this.status,
    @required this.donorId,
    @required this.location}
      );
}
