import 'package:bloodnepal/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:bloodnepal/custom_theme.dart' as style;
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class UserInfo extends StatefulWidget {
  final String contact;
  final String email;
  final String location;
  UserInfo({@required this.contact,@required this.email,@required this.location});

  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  final _form = GlobalKey<FormState>();

  void updateNumber(String contact){
    Provider.of<AuthProvider>(context,listen: false).updateUserInfo("Contact", contact);
  }

  void displayBottomSheet(BuildContext context) {
    String contact;
    showModalBottomSheet(
        context: context,
        builder: (ctx) {
                return SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 50.0),
                      child: Form(
                        key: _form,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                              ),
                              child: TextFormField(
                                maxLength: 10,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                onSaved: (value) {
                                  contact = value;
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
                                    prefixIcon:  Icon(Icons.phone,color: style.CustomTheme.themeColor,)),
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                if(_form.currentState.validate()){
                                  _form.currentState.save();
                                  updateNumber(contact);
                                }
                                Navigator.pop(context);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(
                                    top: 20, left: 30, right: 30, bottom: 10),
                                height: 50,
                                decoration: style.CustomTheme.buttonDecoration,
                                child: Text(
                                  'Update Number',
                                  style: style.CustomTheme.buttonText,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ),
                );
              }

        );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onLongPress: (){
            showDialog(context: context, builder: (context){
              return AlertDialog(
                title: Text("Do you want to change your phone number?"),
                actions: [
                  TextButton(onPressed:(){
                    Navigator.pop(context);
                  }, child: Text("No")),
                  TextButton(onPressed:(){
                    Navigator.pop(context);
                        displayBottomSheet(context);
                  }, child: Text("Yes")),
                ],
              );
            });

          },
          child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              padding: EdgeInsets.only(bottom: 10),
              child: ListTile(
                  leading: Icon(
                    Icons.phone,
                    color: style.CustomTheme.themeColor,
                  ),
                  title: Text("+977-"+widget.contact),
                  tileColor: style.CustomTheme.themeColor.withOpacity(0.5))),
        ),
        Container(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: EdgeInsets.only(bottom: 10),
            child: ListTile(
                leading: Icon(
                  Icons.email,
                  color: style.CustomTheme.themeColor,
                ),
                title: Text(widget.email),
                tileColor: style.CustomTheme.themeColor.withOpacity(0.5))),
        Container(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: EdgeInsets.only(bottom: 10),
            child: ListTile(
                leading: Icon(
                  Icons.location_pin,
                  color: style.CustomTheme.themeColor,
                ),
                title: Text(widget.location),
                tileColor: style.CustomTheme.themeColor.withOpacity(0.5))),
      ],
    );
  }
}
