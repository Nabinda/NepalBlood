import 'package:bloodnepal/helper/loading_helper.dart';
import 'package:bloodnepal/provider/events_provider.dart';
import 'package:bloodnepal/widgets/event_date_time.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:bloodnepal/custom_theme.dart' as style;
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';

class AddEventsScreen extends StatefulWidget {
  static const routeName = "/add_events_screen";

  @override
  _AddEventsScreenState createState() => _AddEventsScreenState();
}

class _AddEventsScreenState extends State<AddEventsScreen> {
  double _height;
  double _width;

  EventDateTime edt = new EventDateTime();
  final _form = GlobalKey<FormState>();
  String _location;
  String _title;
  String _description;
  String _contact;
  String _email;
  bool _isLoading = false;
  final snackBar = SnackBar(content: Text("Events Added Successfully"));
  final errorSnackBar = SnackBar(content: Text("Error Occurred while Adding"));
  _addEvents() async {
    setState(() {
      _isLoading = true;
    });
    if (_form.currentState.validate()) {
      _form.currentState.save();
      await Provider.of<EventProvider>(context, listen: false).addEvent(
        _title,
        _description,
        _location,
        _contact,
        _email,
      ).onError((error, stackTrace){
        print(error);
        ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
      }).then((_){
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Phoenix.rebirth(context);
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: style.CustomTheme.themeColor,
        title: Text("Add Events"),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: _width,
          height: _height,
          padding: EdgeInsets.only(left: 10, top: 10),
          child: _isLoading
              ? LoadingHelper(loadingText: "Adding Events")
              : Form(
                  key: _form,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      EventDateTime(),
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
                            _title = value;
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.deny(
                                RegExp('[0-9!@#%^&*(){}]')),
                          ],
                          validator: (value) {
                            if (value.length < 2) {
                              return 'Title not long enough';
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
                              Icons.title,
                              color: style.CustomTheme.themeColor,
                            ),
                            hintText: "Title",
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
                            _description = value;
                          },
                          validator: (value) {
                            if (value.length < 20) {
                              return 'Description not long enough';
                            }
                            if (value.trim() == "") {
                              return 'Field should not be empty';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.text,
                          maxLines: 3,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.description,
                              color: style.CustomTheme.themeColor,
                            ),
                            hintText: "Description",
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
                          onSaved: (value) {
                            _email = value;
                          },
                          validator: (value) {
                            if (EmailValidator.validate(value)) {
                              return null;
                            }
                            return 'Invalid Format';
                          },
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                              hintText: "Email",
                              prefixIcon: Icon(
                                Icons.email,
                                color: style.CustomTheme.themeColor,
                              )),
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
                      GestureDetector(
                        onTap: _addEvents,
                        child: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(
                              top: 20, left: 30, right: 30, bottom: 10),
                          height: 50,
                          decoration: style.CustomTheme.buttonDecoration,
                          child: Text(
                            'Add Event',
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
