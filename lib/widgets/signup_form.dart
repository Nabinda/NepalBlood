import 'package:bloodnepal/helper/loading_helper.dart';
import 'package:bloodnepal/model/user_model.dart';
import 'package:bloodnepal/provider/auth_provider.dart';
import 'package:bloodnepal/screens/login.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  bool _isSigning = false;
  bool hideCon = true;
  bool _isLoading = false;
  String localLocation = "Location";
  String district = "District";
  UserModel _newUser;
  String _firstName;
  String _lastName;
  String _contactNo;
  String _email, _password;
  String _long;
  String _lat;
  Future<void> verification() async {
    var user = FirebaseAuth.instance.currentUser;
     user.sendEmailVerification().onError((error, stackTrace){
       setState(() {
         _isLoading = false;
       });
     }).then((push) {
      setState(() {
        _isLoading = false;
      });
      _newUser = UserModel(
          imageUrl: "",
          lat: _lat,
          long: _long,
          uid: user.uid,
          status: null,
          bloodGroup: null,
          firstName: _firstName,
          lastName: _lastName,
          contactNo: _contactNo,
          district: district,
          localLocation: localLocation,
          role: "Seeker",
          email: _email);
      Provider.of<AuthProvider>(context,listen: false).addUserInfo(_newUser);

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => LoginScreen()));
    }).catchError((error) {
       setState(() {
         _isSigning = false;
       });
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
          desiredAccuracy: LocationAccuracy.high).timeout(Duration(seconds: 5), onTimeout: () {
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
                        Navigator.pop(context);
                      })
                ],
              );
            });
      });
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      _long = position.longitude.toString();
      _lat = position.latitude.toString();
      setState(() {
        localLocation = placemarks[1].name;
        district =placemarks[1].subAdministrativeArea;
        _isLoading = false;
      });
    }
  }

  Future<void> _signUp() async {
    setState(() {
      _isSigning = true;
    });
    if (_form.currentState.validate()) {
      _form.currentState.save();
      try {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: _email, password: _password)
            .then((authResult) {
          verification();
        }).catchError((error) {
          setState(() {
            _isSigning = false;
          });
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
    return _isSigning?
    LoadingHelper(loadingText: "Signing In")
        :_isLoading
        ? LoadingHelper(loadingText: "Fetching Your Location")
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
                        prefixIcon: Icon(Icons.person,color: style.CustomTheme.themeColor,),
                          hintText: "First Name",
                          ),
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
                         prefixIcon:  Icon(Icons.person,color: style.CustomTheme.themeColor,),),
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
                          prefixIcon:  Icon(Icons.phone,color: style.CustomTheme.themeColor,)),
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
                          hintText: localLocation+", "+district,
                          prefixIcon:  Icon(Icons.location_pin,color: style.CustomTheme.themeColor,)),
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
                          prefixIcon:  Icon(Icons.email,color: style.CustomTheme.themeColor,)),
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
                              color: style.CustomTheme.themeColor,
                              icon: Icon(
                                hidePass
                                    ? Icons.remove
                                    : Icons.remove_red_eye,
                                size: 16,
                              ),
                              onPressed: () {
                                setState(() {
                                  hidePass = !hidePass;
                                });
                              }),
                          prefixIcon:  Icon(Icons.vpn_key,color: style.CustomTheme.themeColor,)),
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
                            color: style.CustomTheme.themeColor,
                              icon: Icon(
                                hideCon
                                    ? Icons.remove
                                    : Icons.remove_red_eye,
                                size: 16,
                              ),
                              onPressed: () {
                                setState(() {
                                  hideCon = !hideCon;
                                });
                              }),
                          hintText: "Confirm Password",
                          prefixIcon:  Icon(Icons.vpn_key,color: style.CustomTheme.themeColor,)),
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
