import 'package:flutter/cupertino.dart';

class MessageModel{
  String requestCreatorId;
  String bloodRequestId;
  String donorId;
  MessageModel({
    @required this.requestCreatorId,
    @required this.bloodRequestId,
    @required this.donorId
});
}
