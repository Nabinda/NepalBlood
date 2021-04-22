import 'package:bloodnepal/model/event_model.dart';
import 'package:bloodnepal/model/notification_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EventProvider with ChangeNotifier {
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  TimeOfDay startTime = TimeOfDay(hour: 00, minute: 00);
  TimeOfDay endTime = TimeOfDay(hour: 00, minute: 00);
  List<EventModel> _eventList = [];
  List<NotificationModel> _notificationList = [];
  List<NotificationModel> getNotifications() {
    return [..._notificationList];
  }
  List<EventModel> getEvents() {
    print("Get events");
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
    return _eventList.firstWhere((event) => event.id == id);
  }

  Future<void> addEvent(
    String title,
    String description,
    String location,
    String contact,
    String email,
  ) async {
    final docRef =  FirebaseFirestore.instance.collection('Events').doc();
    await docRef.set({
      "id": docRef.id,
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
    addNotification(title,  docRef.id, startDate, location);
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
  Future<void> addNotification(String title, String id, DateTime date, String location,) async {
    final docRef =  FirebaseFirestore.instance.collection('Notifications').doc();
    await docRef.set({
      "id": id,
      "title": title,
      "location": location,
      "startDate": date,
      "createdAt":DateTime.now()
    });
    _notificationList.add(
        NotificationModel(
            id: DateTime.now().toString(),
            title: title,
            date: date,
            location: location));
  }
  Future<void> deleteEvent(String id) async{
    await FirebaseFirestore.instance.collection('Events').doc(id).delete();
  }

  Future<void> getEventDetail() async {
    print("fetch event");
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
  Future<void> getNotificationDetail() async {
    _notificationList = [];
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Notifications')
        .orderBy('createdAt',descending: true)
        .get();
    final allData = querySnapshot.docs.map((e) => e.data()).toList();
    List<NotificationModel> fetchedNotification = [];
    for(int i = 0; i<allData.length;i++){
      Timestamp timeInMillis = allData[i]['startDate'];
      DateTime sDate = DateTime.parse(timeInMillis.toDate().toString());
      fetchedNotification.add(NotificationModel(
          id: allData[i]['id'].toString(),
          title: allData[i]['title'],
          date: sDate,
          location: allData[i]['location']));
    }
    _notificationList = fetchedNotification;
    notifyListeners();
  }
}
