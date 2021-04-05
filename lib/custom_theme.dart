import 'package:flutter/material.dart';

class CustomTheme{
  static const TextStyle headerRoboto = TextStyle(
      color: Colors.white,
      fontFamily: 'Roboto',
      fontStyle: FontStyle.italic,
      fontSize: 25,
      fontWeight: FontWeight.w400
  );
  static const TextStyle kTextGreyStyle = TextStyle(
      color: Colors.blueGrey,
      fontFamily: 'Noto',
      fontStyle: FontStyle.italic,
  );
  static const TextStyle largeHeader = TextStyle(
      color: Colors.white,
      fontFamily: 'Roboto',
      fontSize: 40,
      fontWeight: FontWeight.w500
  );
  static const TextStyle boldHeader = TextStyle(
      color: Colors.black,
      fontFamily: 'Roboto',
      fontSize: 18,
      fontWeight: FontWeight.w900
  );
  static const TextStyle buttonText = TextStyle(
      color: Colors.white,
      fontFamily: 'Roboto',
      fontSize: 16,
      fontWeight: FontWeight.w500
  );
  static const TextStyle headerBlackRoboto = TextStyle(
      fontFamily: 'Roboto',
      fontStyle: FontStyle.italic,
      fontSize: 25,
      fontWeight: FontWeight.w400
  );
  static const TextStyle eventTitle = TextStyle(
      fontFamily: 'Roboto',
      fontSize: 30,
      fontWeight: FontWeight.w500
  );
  static const TextStyle headerNoto = TextStyle(
      color: Colors.white,
      fontFamily: 'NotoSans',
      fontStyle: FontStyle.italic,
      fontSize: 25,
      fontWeight: FontWeight.bold
  );
  static const TextStyle headerBlackNoto = TextStyle(
      fontFamily: 'NotoSans',
      fontStyle: FontStyle.italic,
      fontSize: 25,
      fontWeight: FontWeight.bold
  );
  static const TextStyle normalHeader = TextStyle(
      fontFamily: 'NotoSans',
      fontStyle: FontStyle.italic,
      color:Colors.black,
      fontSize: 20,
      fontWeight: FontWeight.bold
  );
  static const TextStyle eventHeader = TextStyle(
      fontFamily: 'NotoSans',
      fontSize: 18,
    color: Colors.black
  );
  static const TextStyle normalText = TextStyle(
      fontFamily: 'Roboto',
      fontSize: 16,
      color: Colors.black
  );
  static const TextStyle normalNotoText = TextStyle(
      fontFamily: 'Noto',
      fontSize: 16,
      color: Colors.black
  );
  static const TextStyle calendarText = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w700,
    fontFamily: 'Roboto',
    fontSize: 22,
  );
  static const Color themeColor = Color(0xffF99297);
  static const buttonDecoration = const BoxDecoration(
    boxShadow: [
      BoxShadow(
        color: Colors.white70,
        offset: Offset(0,8),
        blurRadius: 10.0,
      ),
    ],
    color: themeColor
  );

}
