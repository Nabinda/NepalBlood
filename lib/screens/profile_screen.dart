import 'package:bloodnepal/provider/auth_provider.dart';
import 'package:bloodnepal/widgets/profile_image.dart';
import 'package:bloodnepal/widgets/user_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';
import 'package:bloodnepal/custom_theme.dart' as style;

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<AuthProvider>(context,listen: false).getCurrentUser();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: style.CustomTheme.themeColor,
        title: Text("PROFILE"),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20,),
          Center(child: ProfileImage()),
          SizedBox(height: 20,),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
            decoration: BoxDecoration(
                color: style.CustomTheme.themeColor,
                borderRadius: BorderRadius.circular(15.0)
            ),
            child: Text("Role:"+userInfo.role),
          ),
          SizedBox(height: 10.0,),
          userInfo.status!=null?
          InkWell(
            onLongPress: (){
              showDialog(context: context, builder: (context){
                return AlertDialog(
                  title: Text("Do you want to change your status?"),
                  actions: [
                    TextButton(onPressed:(){
                      Navigator.pop(context);
                    }, child: Text("No")),
                    TextButton(onPressed:(){
                      Provider.of<AuthProvider>(context,listen: false).updateUserInfo("Status", userInfo.status=="Active"?"Inactive":"Active");
                      Phoenix.rebirth(context);
                    }, child: Text("Yes")),
                  ],
                );
              });

            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
              decoration: BoxDecoration(
                color: style.CustomTheme.themeColor,
               borderRadius: BorderRadius.circular(15.0)
              ),
              child: Text("Status:"+userInfo.status),
            ),
          ):null,
          userInfo.role=="Donor"?
          SizedBox(height: 10.0,):null,
          userInfo.role=="Donor"?
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
            decoration: BoxDecoration(
                color: style.CustomTheme.themeColor,
                borderRadius: BorderRadius.circular(15.0)
            ),
            child: Text("Blood Group:"+userInfo.bloodGroup),
          ):null,
          userInfo.status!=null?
          SizedBox(height: 20,):null,
          Text(userInfo.firstName+" "+userInfo.lastName,style: style.CustomTheme.eventHeader,),
          SizedBox(height: 20,),
         UserInfo(userInfo)
        ],
      ),
    );
  }
}
