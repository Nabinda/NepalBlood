import 'package:flutter/material.dart';

class NotificationModel{
  String id;
  DateTime date;
  String title;
  String location;
  NotificationModel({
    @required this.id,
    @required this.date,
    @required this.title,
    @required this.location,
});
}
