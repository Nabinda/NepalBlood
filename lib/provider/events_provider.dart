import 'package:bloodnepal/model/event_model.dart';
import 'package:flutter/material.dart';

class EventProvider with ChangeNotifier {
  List<EventModel> _eventList = [
    EventModel(
      id: "1",
      title: "Title",
      description: "Event Description",
      startDate: DateTime(2021, 3, 25),
      contactNo: "9803216622",
      email: "nabindangol2@gmail.com",
      location: "Nepal",
      alarmInterval: Duration(hours: 1),
      endDate: DateTime(2021, 3, 26),
    ),EventModel(
      id: "2",
      title: "The Day We Met",
      description: "When We were bored",
      contactNo: "9803216622",
      email: "nabindangol2@gmail.com",
      startDate: DateTime.now(),
      location: "Nepal",
      alarmInterval: Duration(hours: 1),
      endDate: DateTime(2021, 3, 26),
    ),EventModel(
      id: "3",
      title: "Birthday",
      contactNo: "9803216622",
      email: "nabindangol2@gmail.com",
      description: "Nidhisha Mandevkars Birthday",
      startDate: DateTime(2021, 3, 26),
      location: "Nepal",
      alarmInterval: Duration(hours: 1),
      endDate: DateTime(2021, 3, 26),
    )
  ];
  List<EventModel> getEvents(){
    notifyListeners();
    return [..._eventList];
  }

  EventModel findEventById(String id){
    notifyListeners();
    return _eventList.firstWhere((event) =>event.id==id);
  }

}
