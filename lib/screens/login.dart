import 'package:bloodnepal/screens/signup.dart';
import 'package:flutter/material.dart';
import 'package:bloodnepal/custom_clipper.dart';
import 'package:bloodnepal/custom_theme.dart' as style;

class LoginScreen extends StatelessWidget {
  static const routeName = "/login_Screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            //Navigation Bar
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
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 30.0,
                  ),
                  Form(
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                          child: TextFormField(
                            onSaved: (value) {
                              //_email = value;
                            },
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.email),
                              hintText: ' Email',
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40.0,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                          child: TextFormField(
                            onSaved: (value) {
                              // _password = value;
                            },
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: true,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.vpn_key),
                              hintText: ' Password',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  GestureDetector(
                    //onTap: checkLogin,
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(
                          top: 20, left: 30, right: 30, bottom: 10),
                      height: 50,
                      decoration: style.CustomTheme.buttonDecoration,
                      child: Text(
                        'Login',
                      ),
                    ),
                  ),
                  Text(
                    'Do not have account ?',
                    style: style.CustomTheme.kTextGreyStyle,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(SignUpScreen.routeName);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(
                          top: 20, left: 30, right: 30, bottom: 10),
                      height: 50,
                      decoration: style.CustomTheme.buttonDecoration,
                      child: Text(
                        'SignUp',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
