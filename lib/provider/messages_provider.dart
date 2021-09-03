import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageProvider extends ChangeNotifier{
  String bloodRequestorId;
  Map<String, dynamic> requestorInfo;
  Future<void> getRequestorId(String bloodRequestId) async{
    await FirebaseFirestore.instance.collection("Blood-Request").doc(bloodRequestId).get().then((DocumentSnapshot ds){
        requestorInfo = ds.data();
        bloodRequestorId = requestorInfo['requestId'];
    });
    notifyListeners();
  }
    Future<void> createMessage(String donorId, String bloodRequestId) async{
      getRequestorId(bloodRequestId).then((_) async{
        await FirebaseFirestore.instance.collection("Users").doc(bloodRequestorId).collection("Messages").doc().set({
          "blood_requestor_Id": bloodRequestorId,
          "donor_id" : donorId,
          "blood_request_id" : bloodRequestId
        });
      });
    }
}
