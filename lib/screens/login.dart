import 'package:bloodnepal/provider/auth_provider.dart';
import 'package:bloodnepal/screens/bottom_bar_screen.dart';
import 'package:bloodnepal/screens/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:bloodnepal/custom_clipper.dart';
import 'package:bloodnepal/custom_theme.dart' as style;
import 'package:bloodnepal/helper/loading_helper.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = "/login_Screen";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final emailController = TextEditingController();
  final _form = GlobalKey<FormState>();
  bool pass = true;
  bool _isLoading = false;
  String _email, _password;
  _validate() {
    if (_form.currentState.validate()) {
      _form.currentState.save();
      _login();
    }
  }

  Future<void> _checkVerification() async{
      var user = _firebaseAuth.currentUser;
      if(user.emailVerified){
        Provider.of<AuthProvider>(context,listen: false).getCurrentUserInfo(user.uid);
        await Provider.of<AuthProvider>(context,listen: false).updateVerification(user.uid);
        Navigator.of(context).pushNamedAndRemoveUntil(
            BottomBarScreen.routeName, (Route<dynamic> route) => false);
      } else{
        setState(() {
          _isLoading = false;
        });
        return showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Please verify your email first"),
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
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });
    try{
      await _firebaseAuth.signInWithEmailAndPassword(email: _email, password: _password).then((authResult){
        _checkVerification();
      }).catchError((error){
        setState(() {
          _isLoading= false;
        });
        if(error.code=="invalid-email"){
          return showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Email does not exists!!!"),
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
        if(error.code=="wrong-password"){
          return showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Wrong Password!!! Try again"),
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
        print(error.code);
      });
    }catch(error){
      setState(() {
        _isLoading = false;
      });
      print(error);
    }
  }
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
            _isLoading
                ? LoadingHelper(loadingText: "Logging In")
                : Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 30.0,
                        ),
                        Form(
                          key: _form,
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 20.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                ),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value.trim() == null) {
                                      return 'Field must not be empty';
                                    }
                                    return null;
                                  },
                                  controller: emailController,
                                  onSaved: (value) {
                                    _email = value;
                                  },
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.email,
                                      color: style.CustomTheme.themeColor,
                                    ),
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
                                  validator: (value) {
                                    if (value.trim() == null) {
                                      return 'Field must not be empty';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _password = value;
                                  },
                                  keyboardType: TextInputType.visiblePassword,
                                  obscureText: pass,
                                  decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      color: style.CustomTheme.themeColor,
                                      icon: Icon(pass
                                          ? Icons.remove
                                          : Icons.remove_red_eye),
                                      onPressed: () {
                                        setState(() {
                                          pass = !pass;
                                        });
                                      },
                                    ),
                                    prefixIcon: Icon(
                                      Icons.vpn_key,
                                      color: style.CustomTheme.themeColor,
                                    ),
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
                          onTap: _validate,
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
                            Navigator.of(context)
                                .pushNamed(SignUpScreen.routeName);
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
