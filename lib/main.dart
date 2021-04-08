import 'package:bloodnepal/helper/loading_helper.dart';
import 'package:bloodnepal/provider/auth_provider.dart';
import 'package:bloodnepal/provider/blood_requests_provider.dart';
import 'package:bloodnepal/provider/events_provider.dart';
import 'package:bloodnepal/screens/add_events.dart';
import 'package:bloodnepal/screens/blood_bank.dart';
import 'package:bloodnepal/screens/blood_requests.dart';
import 'package:bloodnepal/screens/bottom_bar_screen.dart';
import 'package:bloodnepal/screens/donor_screen.dart';
import 'package:bloodnepal/screens/events.dart';
import 'package:bloodnepal/screens/events_detail_screen.dart';
import 'package:bloodnepal/screens/login.dart';
import 'package:bloodnepal/screens/request_blood.dart';
import 'package:bloodnepal/screens/search_screen.dart';
import 'package:bloodnepal/screens/signup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().whenComplete(() {
    runApp(Phoenix(child: MyApp()));
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => EventProvider()),
        ChangeNotifierProvider(create: (_) => BloodRequestsProvider()),
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
          BloodRequests.routeName: (ctx) => BloodRequests(),
          RequestBlood.routeName: (ctx) => RequestBlood(),
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
