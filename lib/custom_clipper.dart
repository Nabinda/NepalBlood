import 'package:flutter/material.dart';

class CustomClip extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height*0.8);
    double xCenter = size.width*0.4;
    double yCenter = size.height;
    path.quadraticBezierTo(xCenter, yCenter, size.width, size.height*0.7);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }

}
