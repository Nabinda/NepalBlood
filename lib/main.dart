import 'package:bloodnepal/provider/auth_provider.dart';
import 'package:bloodnepal/provider/events_provider.dart';
import 'package:bloodnepal/screens/blood_bank.dart';
import 'package:bloodnepal/screens/bottom_bar_screen.dart';
import 'package:bloodnepal/screens/donor_screen.dart';
import 'package:bloodnepal/screens/events.dart';
import 'package:bloodnepal/screens/events_detail_screen.dart';
import 'package:bloodnepal/screens/login.dart';
import 'package:bloodnepal/screens/search_screen.dart';
import 'package:bloodnepal/screens/signup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=>AuthProvider()),
        ChangeNotifierProvider(create: (_)=>EventProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Nepal Blood',
        home: LoginScreen(),
        //home: BottomBarScreen(),
          routes: {
        Events.routeName:(ctx)=>Events(),
        LoginScreen.routeName:(ctx)=>LoginScreen(),
        SignUpScreen.routeName:(ctx)=>SignUpScreen(),
        SearchScreen.routeName:(ctx)=>SearchScreen(),
        BloodBankScreen.routeName:(ctx)=>BloodBankScreen(),
        DonorScreen.routeName:(ctx)=>DonorScreen(),
        EventsDetailScreen.routeName:(ctx)=>EventsDetailScreen(),
      },
      ),
    );
  }
}

