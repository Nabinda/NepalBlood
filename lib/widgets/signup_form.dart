import 'package:bloodnepal/model/user_model.dart';
import 'package:bloodnepal/provider/auth_provider.dart';
import 'package:bloodnepal/screens/login.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bloodnepal/helper/manage_permission.dart' as mp;
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:bloodnepal/custom_theme.dart' as style;
import 'package:provider/provider.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  @override
  void initState() {
    Firebase.initializeApp();
    super.initState();
  }

  @override
  void dispose() {
    passwordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    contactController.dispose();
    super.dispose();
  }

  final _form = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final contactController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  bool hidePass = true;
  bool hideCon = true;
  bool _isLoading = false;
  String location = "Location";
  UserModel _newUser;
  String _firstName;
  String _lastName;
  String _contactNo;
  String _email, _password;
  String _long;
  String _lat;
  Future<void> verification() async {
    var user = FirebaseAuth.instance.currentUser;
     user.sendEmailVerification().then((push) {
      setState(() {
        _isLoading = false;
      });
      _newUser = UserModel(
          lat: _lat,
          long: _long,
          uid: user.uid,
          firstName: _firstName,
          lastName: _lastName,
          contactNo: _contactNo,
          location: location,
          role: "Seeker",
          email: _email);
      Provider.of<AuthProvider>(context,listen: false).addUserInfo(_newUser);

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => LoginScreen()));
    }).catchError((error) {
      print("Error Messages");
      print(error);
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error Sending Verification Mail'),
              actions: <Widget>[
                new TextButton(
                    child: new Text('OK'),
                    onPressed: () {
                      Navigator.pop(context);
                    })
              ],
            );
          });
    });
  }

  _getLocation(BuildContext context) async {
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
          desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      _long = position.longitude.toString();
      _lat = position.latitude.toString();
      setState(() {
        location = placemarks[1].name + "," + placemarks[3].name;
        _isLoading = false;
      });
    }
  }

  Future<void> _signUp() async {
    if (_form.currentState.validate()) {
      _form.currentState.save();
      try {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: _email, password: _password)
            .then((authResult) {
          verification();
        }).catchError((error) {
          print(error.code);
          if (error.code == "email-already-in-use") {
            return showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Email already exists!!!'),
                    actions: <Widget>[
                      new TextButton(
                          child: new Text('OK'),
                          onPressed: () {
                            Navigator.pop(context);
                          })
                    ],
                  );
                });
          }
        });
      } catch (error) {
        print(error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Container(
            height: MediaQuery.of(context).size.height * 0.4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(
                  style.CustomTheme.themeColor,
                )),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Getting Location",
                  style: style.CustomTheme.normalText,
                )
              ],
            ),
          )
        : Container(
            child: Form(
              key: _form,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: TextFormField(
                      onSaved: (value) {
                        _firstName = value;
                      },
                      controller: firstNameController,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')),
                      ],
                      validator: (value) {
                        if (value.length < 2) {
                          return 'Name not long enough';
                        }
                        if (value.trim() == "") {
                          return 'Field should not be empty';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                          hintText: "First Name",
                          contentPadding: EdgeInsets.only(left: 20)),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: TextFormField(
                      controller: lastNameController,
                      onSaved: (value) {
                        _lastName = value;
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')),
                      ],
                      validator: (value) {
                        if (value.length < 2) {
                          return 'Name not long enough';
                        }
                        if (value.trim() == "") {
                          return 'Field should not be empty';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                          hintText: "Last Name",
                          contentPadding: EdgeInsets.only(left: 20)),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: TextFormField(
                      controller: contactController,
                      maxLength: 10,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onSaved: (value) {
                        _contactNo = value;
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
                          contentPadding: EdgeInsets.only(left: 20)),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 5.0, left: 20, right: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: TextFormField(
                      readOnly: true,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.add_location_sharp,
                              color: style.CustomTheme.themeColor,
                            ),
                            onPressed: () {
                              _getLocation(context);
                            },
                          ),
                          hintText: location,
                          contentPadding: EdgeInsets.only(left: 20)),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: TextFormField(
                      onSaved: (value) {
                        _email = value;
                      },
                      validator: (value) {
                        if (EmailValidator.validate(value)) {
                          return null;
                        }
                        return 'Invalid Format';
                      },
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          hintText: "Email",
                          contentPadding: EdgeInsets.only(left: 20)),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: TextFormField(
                      controller: passwordController,
                      onSaved: (value) {
                        _password = value;
                      },
                      obscureText: hidePass,
                      validator: (value) {
                        if (value.length < 8) {
                          return 'Password length must be greater then 8';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          hintText: "Password",
                          suffixIcon: IconButton(
                              icon: Icon(
                                hidePass
                                    ? Icons.remove_red_eye
                                    : Icons.panorama_fish_eye_sharp,
                                size: 16,
                              ),
                              onPressed: () {
                                setState(() {
                                  hidePass = !hidePass;
                                });
                              }),
                          contentPadding: EdgeInsets.only(left: 20)),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: TextFormField(
                      obscureText: hideCon,
                      validator: (value) {
                        if (value != passwordController.text) {
                          return 'Password does not match';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                              icon: Icon(
                                hideCon
                                    ? Icons.remove_red_eye
                                    : Icons.panorama_fish_eye_sharp,
                                size: 16,
                              ),
                              onPressed: () {
                                setState(() {
                                  hideCon = !hideCon;
                                });
                              }),
                          hintText: "Confirm Password",
                          contentPadding: EdgeInsets.only(left: 20)),
                    ),
                  ),
                  GestureDetector(
                    onTap: _signUp,
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(
                          top: 20, left: 30, right: 30, bottom: 10),
                      height: 50,
                      decoration: style.CustomTheme.buttonDecoration,
                      child: Text(
                        'Create account',
                        style: style.CustomTheme.buttonText,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
