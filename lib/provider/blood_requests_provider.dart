import 'package:bloodnepal/model/blood_request_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BloodRequestsProvider extends ChangeNotifier {
  List<BloodRequestModel> _requestList = [];
  Future<void> addRequest(String name, String patientName, String location,
      String contact, String bloodGroup, DateTime date, TimeOfDay time) async {
    final docRef = FirebaseFirestore.instance.collection('Blood-Request').doc();
    await docRef.set({
      "id": docRef.id,
      "name": name,
      "patientName": patientName,
      "location": location,
      "contact": contact,
      "bloodGroup": bloodGroup,
      "date": date,
      "timeHour": time.hour,
      "timeMinute": time.minute,
      "status": "Pending",
      "donorId":null
    });
    _requestList.add(BloodRequestModel(
        donorId: null,
        id: DateTime.now().toString(),
        name: name,
        patientName: patientName,
        bloodGroup: bloodGroup,
        date: date,
        time: time,
        contact: contact,
        location: location,
        status: 'Pending'));
  }

  Future<void> getBloodRequests() async {
    _requestList = [];
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Blood-Request')
        .orderBy('date')
        .get();
    final allData = querySnapshot.docs.map((e) => e.data()).toList();
    List<BloodRequestModel> fetchedRequest = [];
    for (int i = 0; i < allData.length; i++) {
      Timestamp timeInMillis = allData[i]['date'];
      DateTime date = DateTime.parse(timeInMillis.toDate().toString());
      TimeOfDay time = TimeOfDay(
          hour: allData[i]['timeHour'], minute: allData[i]['timeMinute']);
      print(date);
      print(time);
      fetchedRequest.add(BloodRequestModel(
          id: allData[i]['id'],
          name: allData[i]['name'],
          patientName: allData[i]['patientName'],
          bloodGroup: allData[i]['bloodGroup'],
          date: date,
          time: time,
          contact: allData[i]['contact'],
          status: allData[i]['status'],
          donorId: allData[i]['donorId'],
          location: allData[i]['location']));
    }
    _requestList = fetchedRequest;
    notifyListeners();
  }
  List<BloodRequestModel> getBloodRequest() {
    return [..._requestList];
  }
  Future<void> updateStatus(String id,String donorId) async{
    await FirebaseFirestore.instance.collection('Blood-Request').doc(id).update({
      "status":"Accepted",
      "donorId": donorId
    }).catchError((error){
      print("Error on Updating Status:"+error.toString());
    });
  }
}
