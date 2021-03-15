import 'package:flutter/material.dart';

class CustomTheme{
  static const TextStyle headerRoboto = TextStyle(
      color: Colors.white,
      fontFamily: 'Roboto',
      fontStyle: FontStyle.italic,
      fontSize: 25,
      fontWeight: FontWeight.w400
  );
  static const TextStyle headerBlackRoboto = TextStyle(

      fontFamily: 'Roboto',
      fontStyle: FontStyle.italic,
      fontSize: 25,
      fontWeight: FontWeight.w400
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
      fontSize: 20,
      fontWeight: FontWeight.bold
  );
  static const TextStyle normalText = TextStyle(
      fontFamily: 'Roboto',
      fontSize: 16,
  );
  static const Color themeColor = Color(0xffF99297);
}
