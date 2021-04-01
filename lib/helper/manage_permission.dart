import 'package:permission_handler/permission_handler.dart';
class ManagePermission{
  static Future<bool> isCalendarPermissionGranted() async{
    var status = await Permission.calendar.status;
    if(!status.isGranted){
      return false;
    }
    else{
      return true;
    }
  }
  static Future<bool> isLocationPermissionGranted() async{
    var status = await Permission.location.status;
    if(!status.isGranted){
      return false;
    }
    else{
      return true;
    }
  }
}
