import 'package:bloodnepal/helper/loading_helper.dart';
import 'package:bloodnepal/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:bloodnepal/custom_theme.dart' as style;
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';

class DonorScreen extends StatefulWidget {
  static const String routeName = "/donor_screen";

  @override
  _DonorScreenState createState() => _DonorScreenState();
}

class _DonorScreenState extends State<DonorScreen> {
  final List<String> bloodGroupCategories = [
    "O+",
    "O-",
    "A+",
    "A-",
    "B+",
    "B-",
    "AB+",
    "AB-"
  ];

  String selectedBloodGroup = "O+";
  bool isChecked = false;
  bool autoFocus = false;
  bool _isLoading = false;
  void displayBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter stateSetter) {
            return _isLoading
                ? Center(child: LoadingHelper(loadingText: "Wait a minute"))
                : Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Select Blood Group:",
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            DropdownButton<String>(
                              iconEnabledColor: style.CustomTheme.themeColor,
                              dropdownColor: style.CustomTheme.themeColor,
                              items: bloodGroupCategories.map((dropdownItem) {
                                return DropdownMenuItem<String>(
                                  value: dropdownItem,
                                  child: Text(dropdownItem),
                                );
                              }).toList(),
                              value: selectedBloodGroup,
                              onChanged: (value) {
                                stateSetter(() {
                                  selectedBloodGroup = value;
                                });
                              },
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isLoading = true;
                            });
                            Provider.of<AuthProvider>(context, listen: false)
                                .updateBloodGroup(selectedBloodGroup)
                                .then((_) {
                              setState(() {
                                _isLoading = false;
                              });
                              Phoenix.rebirth(context);
                            }).catchError((error) {
                              print(error);
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(
                                top: 20, left: 30, right: 30, bottom: 10),
                            height: 50,
                            decoration: style.CustomTheme.buttonDecoration,
                            child: Text(
                              'Submit',
                              style: style.CustomTheme.buttonText,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
          });
        });
  }

  check() {
    if (isChecked) {
      displayBottomSheet(context);
    } else {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                  'Please read the instruction first and click the checkBox'),
              actions: <Widget>[
                new TextButton(
                    child: new Text('OK'),
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        autoFocus = true;
                      });
                    })
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: style.CustomTheme.themeColor,
        title: Text("Become Donor"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                "Read this instruction carefully before becoming a donor:",
                style: style.CustomTheme.normalHeader,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "1. You must be above or 19 years to be a donor.",
                style: style.CustomTheme.eventHeader,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "2. Your weight must be minimum of 50 kg.",
                style: style.CustomTheme.eventHeader,
              ),
              SizedBox(
                height: 5,
              ),
              RichText(
                text: TextSpan(
                    text:
                        "3. You must be in good health, if you are not then switch your status to ",
                    style: style.CustomTheme.eventHeader,
                    children: [
                      TextSpan(
                          text: "'Not Available'.",
                          style: style.CustomTheme.normalHeader)
                    ]),
              ),
              SizedBox(
                height: 5,
              ),
              RichText(
                text: TextSpan(
                  text:
                      "4. If you are taking medicine you are not allowed to donate. So keep your status to ",
                  style: style.CustomTheme.eventHeader,
                  children: [
                    TextSpan(
                        text: "'Not Available'  ",
                        style: style.CustomTheme.normalHeader),
                    TextSpan(
                        text: "in case you are taking medicine.",
                        style: style.CustomTheme.eventHeader)
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                  "5. Once you donate blood you won't be able to donate within 56 days.",
                  style: style.CustomTheme.eventHeader),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                      autofocus: true,
                      activeColor: style.CustomTheme.themeColor,
                      value: isChecked,
                      onChanged: (_) {
                        setState(() {
                          isChecked = !isChecked;
                        });
                      }),
                  SizedBox(
                    width: 5,
                  ),
                  Text("I have read all the instructions")
                ],
              ),
              GestureDetector(
                onTap: check,
                child: Container(
                  alignment: Alignment.center,
                  margin:
                      EdgeInsets.only(top: 20, left: 30, right: 30, bottom: 10),
                  height: 50,
                  decoration: style.CustomTheme.buttonDecoration,
                  child: Text(
                    'Submit',
                    style: style.CustomTheme.buttonText,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
