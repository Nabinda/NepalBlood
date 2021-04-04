import 'package:flutter/material.dart';

class EventModel{
  String id;
  String title;
  String description;
  String contactNo;
  String email;
  DateTime startDate;
  DateTime endDate;
  TimeOfDay startTime;
  TimeOfDay endTime;
  String location;
  EventModel({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.contactNo,
    @required this.email,
    @required this.startDate,
    @required this.endDate,
    @required this.startTime,
    @required this.endTime,
    @required this.location}
      );
}
