import 'package:bloodnepal/helper/loading_helper.dart';
import 'package:bloodnepal/provider/auth_provider.dart';
import 'package:bloodnepal/provider/events_provider.dart';
import 'package:bloodnepal/screens/add_events.dart';
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
import 'custom_theme.dart' as style;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().whenComplete(() {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => EventProvider())
      ],
      child: MaterialApp(

        debugShowCheckedModeBanner: false,
        title: 'Nepal Blood',
        home: TryAutoLogin(),
        //home: BottomBarScreen(),
        routes: {
          Events.routeName: (ctx) => Events(),
          LoginScreen.routeName: (ctx) => LoginScreen(),
          BottomBarScreen.routeName: (ctx) => BottomBarScreen(),
          SignUpScreen.routeName: (ctx) => SignUpScreen(),
          SearchScreen.routeName: (ctx) => SearchScreen(),
          BloodBankScreen.routeName: (ctx) => BloodBankScreen(),
          DonorScreen.routeName: (ctx) => DonorScreen(),
          EventsDetailScreen.routeName: (ctx) => EventsDetailScreen(),
          AddEventsScreen.routeName: (ctx) => AddEventsScreen(),
        },
      ),
    );
  }
}

class TryAutoLogin extends StatefulWidget {
  @override
  _TryAutoLoginState createState() => _TryAutoLoginState();
}

class _TryAutoLoginState extends State<TryAutoLogin> {
  bool isInit = true;
  bool isLogin = false;
  bool isLoading = false;
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (isInit) {
      setState(() {
        isLoading = true;
      });
      checkLogin();
    }
    isInit = false;
  }

  void checkLogin() async {
    isLogin = await Provider.of<AuthProvider>(context).tryAutoLogin();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Scaffold(
            body: Center(
                child: LoadingHelper(loadingText: "Getting things ready")))
        : isLogin
            ? BottomBarScreen()
            : LoginScreen();
  }
}
