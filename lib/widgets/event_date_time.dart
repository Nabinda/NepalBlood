import 'dart:math';

import 'package:bloodnepal/provider/events_provider.dart';
import 'package:bloodnepal/screens/add_events.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bloodnepal/custom_theme.dart' as style;
import 'package:provider/provider.dart';

class EventDateTime extends StatefulWidget {
  @override
  _EventDateTimeState createState() => _EventDateTimeState();
}

class _EventDateTimeState extends State<EventDateTime> {
  double _height;
  double _width;
  String _startTime, _startDate, _endDate, _endTime;
  String _startHour, _startMinute, _startTim;
  String _endHour, _endMinute, _endTim;
  String dateTime;
  DateTime selectedStartDate = DateTime.now();
  DateTime selectedEndDate = DateTime.now();
  TimeOfDay selectedStartTime = TimeOfDay(hour: 00, minute: 00);
  TimeOfDay selectedEndTime = TimeOfDay(hour: 00, minute: 00);
  DateTime recentSelectedStartDate;
  TextEditingController _startDateController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();
  TextEditingController _startTimeController = TextEditingController();
  TextEditingController _endTimeController = TextEditingController();
  Future<Null> _selectStartDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedStartDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null) {
      recentSelectedStartDate = picked;
      setState(() {
        selectedStartDate = picked;
        _startDateController.text = DateFormat.yMd().format(selectedStartDate);
      });
      Provider.of<EventProvider>(context,listen: false).uStartDate=picked;
    }
  }

  Future<Null> _selectEndDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedEndDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if(!picked.difference(selectedStartDate).isNegative) {
      if (picked != null) {
        setState(() {
          selectedEndDate = picked;
          _endDateController.text = DateFormat.yMd().format(selectedEndDate);
        });
        Provider.of<EventProvider>(context,listen: false).uEndDate=picked;
      }
    }
    else{
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Event does not End before Starting'),
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

  Future<Null> _selectStartTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedStartTime,
    );
    if (picked != null) {
      setState(() {
        selectedStartTime = picked;
        _startHour = selectedStartTime.hour.toString();
        _startMinute = selectedStartTime.minute.toString();
        _startTim = _startHour + ' : ' + _startMinute;
        _startTimeController.text = _startTim;
        _startTimeController.text = formatDate(
            DateTime(
                2019, 08, 1, selectedStartTime.hour, selectedStartTime.minute),
            [hh, ':', nn, " ", am]).toString();
      });
      Provider.of<EventProvider>(context,listen: false).uStartTime=_startTimeController.text;
    }
  }
  Future<Null> _selectEndTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedEndTime,
    );

        if (picked != null) {
      setState(() {
        selectedEndTime = picked;
        _endHour = selectedEndTime.hour.toString();
        _endMinute = selectedEndTime.minute.toString();
        _endTim = _endHour + ' : ' + _endMinute;
        _endTimeController.text = _endTim;
        _endTimeController.text = formatDate(
            DateTime(2019, 08, 1, selectedEndTime.hour, selectedEndTime.minute),
            [hh, ':', nn, " ", am]).toString();
      });
      Provider.of<EventProvider>(context,listen: false).uEndTime=_endTimeController.text;
    }
  }
  @override
  void initState() {
    _startDateController.text = DateFormat.yMd().format(DateTime.now());
    _endDateController.text = DateFormat.yMd().format(DateTime.now());
    _startTimeController.text =
        formatDate(DateTime(0, 0, 0, 0, 0), [hh, ':', nn, " ", am]).toString();
    _endTimeController.text =
        formatDate(DateTime(0, 0, 0, 0, 0), [hh, ':', nn, " ", am]).toString();
    super.initState();
  }
  DateTime selectedStartD(){
    return selectedStartDate;
  }
  @override
  Widget build(BuildContext context) {
    dateTime = DateFormat.yMd().format(DateTime.now());
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Text(
          "Event Date",
          style: style.CustomTheme.normalHeader,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Text(
                  "Start Date",
                  style: style.CustomTheme.normalText,
                ),
                InkWell(
                  onTap: () {
                    _selectStartDate(context);
                  },
                  child: Container(
                    width: _width * 0.4,
                    alignment: Alignment.center,
                    decoration:
                    BoxDecoration(color: Colors.grey[200]),
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      enabled: false,
                      keyboardType: TextInputType.text,
                      controller: _startDateController,
                      onSaved: (String val) {
                        _startDate = val;
                      },
                      decoration: InputDecoration(
                          disabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide.none),
                          // labelText: 'Time',
                          contentPadding:
                          EdgeInsets.only(top: 0.0)),
                    ),
                  ),
                )
              ],
            ),
            Container(
              child: Column(
                children: [
                  Text(
                    "End Date",
                    style: style.CustomTheme.normalText,
                  ),
                  InkWell(
                    onTap: () {
                      _selectEndDate(context);
                    },
                    child: Container(
                      width: _width * 0.4,
                      alignment: Alignment.center,
                      decoration:
                      BoxDecoration(color: Colors.grey[200]),
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        enabled: false,
                        keyboardType: TextInputType.text,
                        controller: _endDateController,
                        onSaved: (String val) {
                          _endDate = val;
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
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Text("Event Time", style: style.CustomTheme.normalHeader),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Text(
                  "Start Time",
                  style: style.CustomTheme.normalText,
                ),
                InkWell(
                  onTap: () {
                    _selectStartTime(context);
                  },
                  child: Container(
                    width: _width * 0.4,
                    alignment: Alignment.center,
                    decoration:
                    BoxDecoration(color: Colors.grey[200]),
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      enabled: false,
                      keyboardType: TextInputType.text,
                      controller: _startTimeController,
                      onSaved: (String val) {
                        _startTime = val;
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
              ],
            ),
            Container(
              child: Column(
                children: [
                  Text(
                    "End Time",
                    style: style.CustomTheme.normalText,
                  ),
                  InkWell(
                    onTap: () {
                      _selectEndTime(context);
                    },
                    child: Container(
                      width: _width * 0.4,
                      alignment: Alignment.center,
                      decoration:
                      BoxDecoration(color: Colors.grey[200]),
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        enabled: false,
                        keyboardType: TextInputType.text,
                        controller: _endTimeController,
                        onSaved: (String val) {
                          _endTime = val;
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
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
