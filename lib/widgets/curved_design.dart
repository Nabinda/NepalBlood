import 'package:flutter/material.dart';
import 'package:bloodnepal/custom_theme.dart' as style;
import '../custom_clipper.dart';

class CurvedDesign extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return  Stack(
      alignment: Alignment.center,
      children: [
        ClipPath(
          clipper: CustomClip(),
          child: Container(
            height: size.height * 0.5,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xffF77B7F), Color(0xffF99297)])),
          ),
        ),
        Container(
          padding: EdgeInsets.only(bottom: 50),
          child: Text(
            "GIVE THE GIFT OF LIFE",
            style: style.CustomTheme.headerRoboto,
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "DONATE",
                style: style.CustomTheme.headerNoto,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                " BLOOD ",
                style: TextStyle(
                    color: Color(0xffF77B7F),
                    backgroundColor: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        )
      ],
    );
  }
}
