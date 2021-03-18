import 'package:flutter/material.dart';

class EventModel{
  String title;
  String description;
  DateTime startDate;
  DateTime endDate;
  Duration alarmInterval;
  String location;
  EventModel({
    @required this.title,
    @required this.description,
    @required this.startDate,
    @required this.endDate,
    @required this.alarmInterval,
    @required this.location}
      );
}
