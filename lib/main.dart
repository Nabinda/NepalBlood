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
import 'package:bloodnepal/screens/reset_password_screen.dart';
import 'package:bloodnepal/screens/search_screen.dart';
import 'package:bloodnepal/screens/signup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:bloodnepal/helper/manage_permission.dart' as mp;

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
          ResetPasswordScreen.routeName: (ctx) => ResetPasswordScreen(),
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
  String loadingText = "Getting things ready";
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
        loadingText = "Fetching Current Location";
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
                          isLoading = false;
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
        isLoading = false;
      });
      Provider.of<AuthProvider>(context, listen: false).updateUserLocation({
        "Local_Location": localLocation,
        "District": district,
        "Latitude": lat,
        "Longitude": long,
      });
    }
  }

  void checkLogin() async {
    isLogin = await Provider.of<AuthProvider>(context).tryAutoLogin();
    if (isLogin) {
      _getLocation(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Scaffold(body: Center(child: LoadingHelper(loadingText: loadingText)))
        : isLogin
            ? BottomBarScreen()
            : LoginScreen();
  }
}
