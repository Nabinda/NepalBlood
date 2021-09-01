import 'package:flutter/material.dart';
import 'package:bloodnepal/custom_theme.dart' as style;

class MessageScreen extends StatefulWidget {
  static const String routeName = "/message_screen";

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: style.CustomTheme.themeColor,
        title: Text("Messages"),
        centerTitle: true,
      ),
    );
  }
}
