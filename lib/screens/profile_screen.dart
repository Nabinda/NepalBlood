import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class ProfileScreen extends StatelessWidget {
  Future<Position> _checkPermission(BuildContext context) async{
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Turn On Location'),
              actions: <Widget>[
                new TextButton(
                    child: new Text('OK'),
                    onPressed: (){
                      AppSettings.openLocationSettings();
                      Navigator.pop(context);
                    }
                )
              ],
            );
          });
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return  showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Location Permission Required'),
                actions: <Widget>[
                  new TextButton(
                    child: new Text('OK'),
                    onPressed: (){
                      AppSettings.openAppSettings();
                      Navigator.pop(context);
                    }
                  )
                ],
              );
            });
      }
      if (permission == LocationPermission.denied) {
        return  showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Location Permission Required'),
                actions: <Widget>[
                  new TextButton(
                    child: new Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
      }
    }
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child:TextButton(
          onPressed: () async{
          final position = await _checkPermission(context);
          List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
          print("PlaceMark 1");
          print(placemarks[1]);
          print("PlaceMark 3");
          print(placemarks[3]);

          },
          child: Text("Get Location"),
        ),
      ),
    );
  }
}
