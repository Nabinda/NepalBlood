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
    
  BloodRequestModel.fromJson(Map<String, dynamic> parsedJSON):
    id = parsedJSON['id'],
    name = parsedJSON['name'],
    patientName = parsedJSON['patientName'],
    contact = parsedJSON['contact'],
    date = parsedJSON['date'],
    time = parsedJSON['time'],
    bloodGroup = parsedJSON['bloodGroup'],
    location = parsedJSON['location'],
    status = parsedJSON['status'],
    donorId = parsedJSON['donorId'];
}
