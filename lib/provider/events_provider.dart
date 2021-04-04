import 'package:bloodnepal/model/event_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventProvider with ChangeNotifier {
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  TimeOfDay startTime = TimeOfDay(hour: 00, minute: 00);
  TimeOfDay endTime = TimeOfDay(hour: 00, minute: 00);
  List<EventModel> _eventList = [];
  List<EventModel> getEvents() {
    return [..._eventList];
  }

  set uStartDate(DateTime date) {
    startDate = date;
    notifyListeners();
  }

  set uEndDate(DateTime date) {
    endDate = date;
    notifyListeners();
  }

  set uStartTime(TimeOfDay time) {
    startTime = time;
    notifyListeners();
  }

  set uEndTime(TimeOfDay time) {
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
    String email,
  ) async {
    await FirebaseFirestore.instance.collection('Events').doc().set({
      "id": DateTime.now(),
      "title": title,
      "description": description,
      "location": location,
      "contact": contact,
      "email": email,
      "startDate": startDate,
      "startTimeHour": startTime.hour,
      "startTimeMinute": startTime.minute,
      "endDate": endDate,
      "endTimeHour": endTime.hour,
      "endTimeMinute": endTime.minute,
    });
    _eventList.add(EventModel(id: DateTime.now().toString(),
    title: title,
    description: description,
    contactNo:  contact,
    email: email,
    startDate: startDate,
    endDate:endDate,
    startTime: startTime,
    endTime: endTime,
    location: location));
  }

  Future<void> getEventDetail() async {
    _eventList = [];
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Events')
        .orderBy('startDate')
        .get();
      final allData = querySnapshot.docs.map((e) => e.data()).toList();
      List<EventModel> fetchedEvent = [];
      for(int i = 0; i<allData.length;i++){
        Timestamp timeInMillis = allData[i]['startDate'];
        DateTime sDate = DateTime.parse(timeInMillis.toDate().toString());
        Timestamp eTimeInMillis = allData[i]['endDate'];
        DateTime eDate = DateTime.parse(eTimeInMillis.toDate().toString());
        TimeOfDay start = TimeOfDay(hour: allData[i]['startTimeHour'], minute: allData[i]['startTimeMinute']);
        TimeOfDay end = TimeOfDay(hour: allData[i]['endTimeHour'], minute: allData[i]['endTimeMinute']);
        print(start);
        print(end);
        fetchedEvent.add(EventModel(id: allData[i]['id'].toString(),
            title: allData[i]['title'],
            description: allData[i]['description'],
            contactNo:  allData[i]['contact'],
            email: allData[i]['email'],
            startDate: sDate,
            endDate:eDate,
            startTime: start,
            endTime: end,
            location: allData[i]['location']));
      }
      _eventList = fetchedEvent;
      notifyListeners();
  }
}
