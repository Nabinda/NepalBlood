import 'package:bloodnepal/model/event_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EventProvider with ChangeNotifier {
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  String startTime ="";
  String endTime = "";
  List<EventModel> _eventList = [];
  List<EventModel> getEvents() {
    notifyListeners();
    return [..._eventList];
  }
  set uStartDate(DateTime date){
    startDate = date;
    notifyListeners();
  }
  set uEndDate(DateTime date){
    endDate = date;
    notifyListeners();
  }
  set uStartTime(String time){
    startTime = time;
    notifyListeners();
  }
  set uEndTime(String time){
    endTime = time;
    notifyListeners();
  }

  EventModel findEventById(String id) {
    notifyListeners();
    return _eventList.firstWhere((event) => event.id == id);
  }

  Future<void> addEvent(
      String title,
      String description,
      String location,
      String contact,
      String email,) async{

    await FirebaseFirestore.instance
        .collection('Events')
        .doc()
        .set({
      "id":DateTime.now(),
      "title": title,
      "description": description,
      "location": location,
      "contact": contact,
      "email": email,
      "start_date": startDate,
      "start_time": startTime,
      "end_date":endDate,
      "end_time":endTime,
    });


  }
}
