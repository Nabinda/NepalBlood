import 'package:bloodnepal/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<AuthProvider>(context,listen: false).getCurrentUser();
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child:Text(userInfo.firstName),
      ),
    );
  }
}
