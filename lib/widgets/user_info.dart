import 'package:bloodnepal/helper/loading_helper.dart';
import 'package:bloodnepal/provider/auth_provider.dart';
import 'package:bloodnepal/screens/bottom_bar_screen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:bloodnepal/custom_theme.dart' as style;
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:bloodnepal/helper/manage_permission.dart' as mp;

class UserInfo extends StatefulWidget {
  final String contact;
  final String email;
  final String location;
  UserInfo(
      {@required this.contact, @required this.email, @required this.location});

  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  final _form = GlobalKey<FormState>();
  bool _isLoading = false;

  _getLocation(BuildContext context) async {
    String long;
    String lat;
    String localLocation;
    String district;
    bool status = await mp.ManagePermission.isLocationPermissionGranted();
    if (!status) {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                  'Location permission required to get your current location'),
              actions: <Widget>[
                new TextButton(
                    child: new Text('OK'),
                    onPressed: () {
                      openAppSettings();
                      Navigator.pop(context);
                    })
              ],
            );
          });
    } else {
      setState(() {
        _isLoading = true;
      });
      final position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high)
          .timeout(Duration(seconds: 5), onTimeout: () {
        return showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(
                    'Failed to fetch the current Location. Please try again later.'),
                actions: <Widget>[
                  new TextButton(
                      child: new Text('OK'),
                      onPressed: () {
                        setState(() {
                          _isLoading = false;
                        });
                        BottomBarScreen();
                        Navigator.pop(context);
                      })
                ],
              );
            });
      });
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      long = position.longitude.toString();
      lat = position.latitude.toString();
      setState(() {
        localLocation = placemarks[1].name;
        district = placemarks[1].subAdministrativeArea;
        _isLoading = false;
      });
      Provider.of<AuthProvider>(context, listen: false).updateUserLocation({
        "Local_Location": localLocation,
        "District": district,
        "Latitude": lat,
        "Longitude": long,
      });
    }
  }

  void updateNumber(String contact) {
    Provider.of<AuthProvider>(context, listen: false)
        .updateUserInfo("Contact", contact).then((value){
          setState(() {
            _isLoading = false;
          });
          Navigator.pop(context);
    });
  }
  void displayBottomSheet(BuildContext context) {
    String userInput;
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (ctx) {
          return Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom, top: 50
            ),
            child: Form(
              key: _form,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: TextFormField(
                      maxLength: 10,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      onSaved: (value) {
                        userInput = value;
                      },
                      validator: (value) {
                        if (value.length < 10) {
                          return 'Invalid Number';
                        }
                        if (value.trim() == "") {
                          return 'Field should not be empty';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          hintText: "Contact No",
                          prefixIcon: Icon(
                            Icons.phone,
                            color: style.CustomTheme.themeColor,
                          )),
                    )
                  ),
                  SizedBox(height: 30,),
                  GestureDetector(
                    onTap: () {
                      if (_form.currentState.validate()) {
                        _form.currentState.save();
                        setState(() {
                          _isLoading = true;
                        });
                        updateNumber(userInput);
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(
                          top: 20, left: 30, right: 30, bottom: 40),
                      height: 50,
                      decoration: style.CustomTheme.buttonDecoration,
                      child: Text(
                        'Update',
                        style: style.CustomTheme.buttonText,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Container(
            height: 100,
            child: LoadingHelper(loadingText: "Fetching Current Location"))
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onLongPress: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title:
                              Text("Do you want to change your phone number?"),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("No")),
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  displayBottomSheet(context);
                                },
                                child: Text("Yes")),
                          ],
                        );
                      });
                },
                child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    padding: EdgeInsets.only(bottom: 10),
                    child: ListTile(
                        leading: Icon(
                          Icons.phone,
                          color: style.CustomTheme.themeColor,
                        ),
                        title: Text("+977-" + widget.contact),
                        tileColor:
                            style.CustomTheme.themeColor.withOpacity(0.5))),
              ),
              Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  padding: EdgeInsets.only(bottom: 10),
                  child: ListTile(
                      leading: Icon(
                        Icons.email,
                        color: style.CustomTheme.themeColor,
                      ),
                      title: Text(widget.email),
                      tileColor:
                          style.CustomTheme.themeColor.withOpacity(0.5))),
              InkWell(
                onLongPress: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Do you want to update your Location?"),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("No")),
                            TextButton(
                                onPressed: () {
                                  _getLocation(context);
                                  Navigator.pop(context);
                                },
                                child: Text("Yes")),
                          ],
                        );
                      });
                },
                child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    padding: EdgeInsets.only(bottom: 10),
                    child: ListTile(
                        leading: Icon(
                          Icons.location_pin,
                          color: style.CustomTheme.themeColor,
                        ),
                        title: Text(widget.location),
                        tileColor:
                            style.CustomTheme.themeColor.withOpacity(0.5))),
              ),
            ],
          );
  }
}
