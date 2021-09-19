import 'package:bloodnepal/helper/loading_helper.dart';
import 'package:bloodnepal/provider/auth_provider.dart';
import 'package:bloodnepal/provider/blood_requests_provider.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:bloodnepal/custom_theme.dart' as style;
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class RequestBlood extends StatefulWidget {
  static const routeName = "/request_blood";

  @override
  _RequestBloodState createState() => _RequestBloodState();
}

class _RequestBloodState extends State<RequestBlood> {
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

  final _form = GlobalKey<FormState>();
  bool _isLoading = false;
  double _height;
  double _width;
  DateTime selectDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  DateTime recentSelectedDate;
  String _hour, _minute, _tim;
  String _date, _time;
  String _name, _patientName, _bloodGroup, _location, _contact;
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  final snackBar = SnackBar(content: Text("Request Created Successfully"));
  final errorSnackBar =
      SnackBar(content: Text("Error Occurred while creating request"));
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null) {
      recentSelectedDate = picked;
      setState(() {
        selectDate = picked;
        _dateController.text = DateFormat.yMd().format(selectDate);
      });
    }
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _tim = _hour + ' : ' + _minute;
        _timeController.text = _tim;
        _timeController.text = formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();
      });
    }
  }

  addRequest(String uid) async {
    setState(() {
      _isLoading = true;
    });
    if (_form.currentState.validate()) {
      _form.currentState.save();
      await Provider.of<BloodRequestsProvider>(context, listen: false)
          .addRequest(_name, _patientName, _location, _contact,
              selectedBloodGroup, selectDate, selectedTime,uid)
          .onError((error, stackTrace) {
        print(error);
        ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
      }).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    _dateController.text = DateFormat.yMd().format(DateTime.now());
    _timeController.text =
        formatDate(DateTime(0, 0, 0, 0, 0), [hh, ':', nn, " ", am]).toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    final userInfo =
        Provider.of<AuthProvider>(context, listen: false).getCurrentUser();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: style.CustomTheme.themeColor,
        title: Text("Request Blood"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: _width,
          height: _height,
          padding: EdgeInsets.only(left: 10, top: 10),
          child: _isLoading
              ? LoadingHelper(loadingText: "Creating a request")
              : Form(
                  key: _form,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        child: TextFormField(
                          onSaved: (value) {
                            _name = value;
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.deny(
                                RegExp('[0-9!@#%^&*(){}]')),
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
                            prefixIcon: Icon(
                              Icons.person,
                              color: style.CustomTheme.themeColor,
                            ),
                            hintText: "Name",
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
                          onSaved: (value) {
                            _patientName = value;
                          },
                          validator: (value) {
                            if (value.length < 3) {
                              return 'Name not long enough';
                            }
                            if (value.trim() == "") {
                              return 'Field should not be empty';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.person,
                              color: style.CustomTheme.themeColor,
                            ),
                            hintText: "Patient Name",
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
                          onSaved: (value) {
                            _location = value;
                          },
                          validator: (value) {
                            if (value.length < 2) {
                              return 'Location not long enough';
                            }
                            if (value.trim() == "") {
                              return 'Field should not be empty';
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.location_pin,
                              color: style.CustomTheme.themeColor,
                            ),
                            hintText: "Location",
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
                          maxLength: 10,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          onSaved: (value) {
                            _contact = value;
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
                              prefixIcon: Icon(
                                Icons.phone,
                                color: style.CustomTheme.themeColor,
                              )),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Date: ",
                            style: style.CustomTheme.normalText,
                          ),
                          Container(
                            child: InkWell(
                              onTap: () {
                                _selectDate(context);
                              },
                              child: Container(
                                width: _width * 0.3,
                                alignment: Alignment.center,
                                decoration:
                                    BoxDecoration(color: Colors.grey[200]),
                                child: TextFormField(
                                  textAlign: TextAlign.center,
                                  enabled: false,
                                  keyboardType: TextInputType.text,
                                  controller: _dateController,
                                  onSaved: (String val) {
                                    _date = val;
                                  },
                                  decoration: InputDecoration(
                                      disabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide.none),
                                      // labelText: 'Time',
                                      contentPadding:
                                          EdgeInsets.only(top: 0.0)),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              _selectTime(context);
                            },
                            child: Container(
                              width: _width * 0.3,
                              alignment: Alignment.center,
                              decoration:
                                  BoxDecoration(color: Colors.grey[200]),
                              child: TextFormField(
                                textAlign: TextAlign.center,
                                enabled: false,
                                keyboardType: TextInputType.text,
                                controller: _timeController,
                                onSaved: (String val) {
                                  _time = val;
                                },
                                decoration: InputDecoration(
                                    disabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide.none),
                                    // labelText: 'Time',
                                    contentPadding: EdgeInsets.only(top: 0.0)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
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
                              setState(() {
                                selectedBloodGroup = value;
                              });
                            },
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          addRequest(userInfo.uid);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(
                              top: 20, left: 30, right: 30, bottom: 10),
                          height: 50,
                          decoration: style.CustomTheme.buttonDecoration,
                          child: Text(
                            'Request Blood',
                            style: style.CustomTheme.buttonText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
