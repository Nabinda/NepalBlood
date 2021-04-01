import 'package:bloodnepal/screens/login.dart';
import 'package:bloodnepal/widgets/signup_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bloodnepal/custom_clipper.dart';
import 'package:bloodnepal/custom_theme.dart'as style;
class SignUpScreen extends StatelessWidget{
  static const routeName = "/signup_screen";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            //Navigation Bar
            Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: ClipPath(
                    clipper: CustomClip(),
                    child: Container(
                      decoration: BoxDecoration(
                          color: style.CustomTheme.themeColor
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Create an',
                              style: style.CustomTheme.largeHeader),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Account',
                            style: style.CustomTheme.largeHeader,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: IconButton(icon: Icon(CupertinoIcons.back,size: 40, color: Colors.white,), onPressed: (){
                    Navigator.of(context).pop();
                  }),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20,top: 10,right: 20),
              child: Column(
                children: <Widget>[
                  SignUpForm(),
                  SizedBox(height: 20,),
                  Text(
                    'Already have an account ?',
                    style: style.CustomTheme.kTextGreyStyle,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(LoginScreen.routeName);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(
                          top: 20, left: 30, right: 30, bottom: 10),
                      height: 50,
                      decoration: style.CustomTheme.buttonDecoration,
                      child: Text(
                        'Login',
                        style: style.CustomTheme.buttonText,
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
