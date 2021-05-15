import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bloodnepal/custom_theme.dart' as style;
import '../custom_clipper.dart';

class ResetPasswordScreen extends StatefulWidget {
  static const routeName = "/reset_password_screen";

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _form = GlobalKey<FormState>();
  String _email;
  void checkLogin() {
    if (_form.currentState.validate()) {
      _form.currentState.save();
      resetPassword();
    }
  }
  Future<void> resetPassword() async{
    FirebaseAuth.instance.sendPasswordResetEmail(email: _email).then((email){
      return showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: Text("Email Send Successfully"),
              actions: <Widget>[
                InkWell(
                    child: Text("OK"),
                    onTap: () {
                      Navigator.pop(context);
                    })
              ],
            );
          });
    }).catchError((error){
      return showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: Text("Unable to send password reset mail"),
              actions: <Widget>[
                InkWell(
                    child: Text("OK"),
                    onTap: () {
                      Navigator.pop(context);
                    })
              ],
            );
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    var deviceSizeHeight = MediaQuery.of(context).size.height;
    var deviceSizeWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: deviceSizeHeight,
        width: deviceSizeWidth,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              "assets/back.jpg",
            ),
            fit: BoxFit.cover,
          ),
        ),
        child:  SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.4,
                child: ClipPath(
                  clipper: CustomClip(),
                  child: Container(
                    decoration:
                    BoxDecoration(color: style.CustomTheme.themeColor),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Nepal', style: style.CustomTheme.largeHeader),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Blood',
                          style: style.CustomTheme.largeHeader,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                height: 30,
                width: double.infinity,
                child: Center(
                  child: Text(
                    "Reset Your Password",
                    style: style.CustomTheme.normalHeader,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: deviceSizeHeight * 0.7,
                width: deviceSizeWidth,
                child: Column(
                  children: <Widget>[
                    Form(
                      key: _form,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40.0),
                        child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 10),
                              TextFormField(
                                validator: (value) {
                                  if (value.trim() == null) {
                                    return 'Field must not be empty';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _email = value;
                                },
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    labelStyle: style.CustomTheme.normalText,
                                    labelText: "Email",),
                                keyboardType:
                                TextInputType.emailAddress,
                              ),
                              SizedBox(height: 20),

                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: checkLogin,
                      child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(
                            top: 20, left: 30, right: 30, bottom: 10),
                        height: 50,
                        decoration: style.CustomTheme.buttonDecoration,
                        child: Text(
                          'Reset Password',
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
