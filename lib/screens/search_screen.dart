import 'package:bloodnepal/helper/loading_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:bloodnepal/custom_theme.dart' as style;
import 'package:url_launcher/url_launcher.dart';

class SearchScreen extends StatefulWidget {
  static const String routeName = "/search_screen";

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool showResult = false;
  final List<String> bloodGroupCategories = ["O+","O-","A+","A-","B+","B-","AB+","AB-"];
  List<String> _districts = [
    "Achham",
    "Arghakhanchi",
    "Baglung",
    "Baitadi",
    "Bajhang",
    "Bajura	",
    "Banke",
    "Bara",
    "Bardiya",
    "Bhaktapur",
    "Bhojpur",
    "Chitwan",
    "Dadeldhura",
    "Dailekh",
    "Dang",
    "Darchula",
    "Dhading",
    "Dhankuta",
    "Dhanusa",
    "Dolakha",
    "Dolpa",
    "Doti",
    "Gorkha",
    "Gulmi",
    "Humla",
    "Ilam",
    "Jajarkot",
    "Jhapa	",
    "Jumla	",
    "Kailali",
    "Kalikot",
    "Kanchanpur",
    "Kapilvastu",
    "Kaski",
    "Kathmandu",
    "Kavrepalanchok	",
    "Khotang",
    "Lalitpur",
    "Lamjung",
    "Mahottari",
    "Makwanpur",
    "Manang",
    "Morang",
    "Mugu",
    "Mustang",
    "Myagdi",
    "Nawalparasi",
    "Nuwakot",
    "Okhaldhunga",
    "Palpa",
    "Panchthar",
    "Parbat",
    "Parsa",
    "Pyuthan",
    "Ramechhap",
    "Rasuwa",
    "Rautahat",
    "Rolpa",
    "Rukum",
    "Rupandehi",
    "Salyan",
    "Sankhuwasabha",
    "Saptari",
    "Sarlahi",
    "Sindhuli",
    "Sindhupalchok",
    "Siraha	",
    "Solukhumbu	",
    "Sunsari",
    "Surkhet",
    "Syangja",
    "Tanahu",
    "Taplejung",
    "Terhathum",
    "Udayapur"
  ];
  String selectedDistrict = "Kathmandu";
  String selectedBloodGroup = "AB+";
  //Make Phone Call
  _makingPhoneCall(String number) async {
    var url = 'tel:$number';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      return SnackBar(
        content: Text("Something error occurred!!!"),
        duration: Duration(seconds: 3),
      );
    }
  }
  //Send Email
  _sendEmail(String email) async {
    var url = 'mailto:$email';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      return SnackBar(
        content: Text("Something error occurred!!!"),
        duration: Duration(seconds: 3),
      );
    }
  }
  _chooseOption(String email,String contact){
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Choose One!!!'),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                new IconButton(icon: Icon(Icons.email,size: 60,color: style.CustomTheme.themeColor,), onPressed: (){_sendEmail(email);}),
                new IconButton(icon: Icon(Icons.phone,size: 60,color: style.CustomTheme.themeColor,), onPressed: (){_makingPhoneCall(contact);}),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: style.CustomTheme.themeColor,
        title: Text("Search Donor"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left:10.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Select Blood Group:",style:TextStyle(fontSize: 16),),
                SizedBox(width: 20,),
                DropdownButton<String>(
                  iconEnabledColor: style.CustomTheme.themeColor,
                  dropdownColor: style.CustomTheme.themeColor,
                  items: bloodGroupCategories.map((dropdownItem){
                    return DropdownMenuItem<String>(
                      value: dropdownItem,
                      child: Text(dropdownItem),
                    );
                  }).toList(),
                  value: selectedBloodGroup,
                  onChanged: (value){
                    setState((){
                      selectedBloodGroup = value;
                    });
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Select District:",style:TextStyle(fontSize: 16),),
                SizedBox(width: 20,),
                DropdownButton<String>(
                  iconEnabledColor: style.CustomTheme.themeColor,
                  dropdownColor: style.CustomTheme.themeColor,
                  items: _districts.map((dropdownItem){
                    return DropdownMenuItem<String>(
                      value: dropdownItem,
                      child: Text(dropdownItem),
                    );
                  }).toList(),
                  value: selectedDistrict,
                  onChanged: (value){
                    setState((){
                      selectedDistrict = value;
                    });
                  },
                ),
              ],
            ),
            Divider(),
            Container(
              height: 250,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('Users').where("Role",isEqualTo: "Donor").where("Status",isEqualTo: "Active").where("District",isEqualTo:selectedDistrict).where("Blood_Group",isEqualTo: selectedBloodGroup).snapshots(),
                builder: (context,snapshot){
                  if(snapshot.hasData) {
                      if(snapshot.data.docs.length!=0) {
                            return ListView.builder(
                              itemCount: snapshot.data.docs.length,
                              itemBuilder: (BuildContext context, index) {
                                DocumentSnapshot ds = snapshot.data.docs[index];
                                return Container(
                                  decoration: BoxDecoration(
                                      color: index%2==0?Colors.white:style.CustomTheme.themeColor,
                                      borderRadius: BorderRadius.circular(15.0)
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 5.0,vertical: 5.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(100),
                                            child: Container(
                                              height: 120,
                                              width: 100,
                                              child:Image.network(
                                                ds["Image_URL"]
                                                ,fit: BoxFit.cover,
                                              )
                                            ),
                                          ),
                                          SizedBox(width: 5.0,),
                                          Flexible(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(ds["First_Name"]+" "+ds["Last_Name"],style: style.CustomTheme.normalText,),
                                                Text(ds["Blood_Group"],style: style.CustomTheme.normalText,),
                                                Text(ds["Email"],overflow:TextOverflow.ellipsis,style: style.CustomTheme.normalText,),
                                                Text(ds["Contact"],style: style.CustomTheme.normalText,),
                                                Text(ds["Local_Location"]+", "+ds["District"],overflow:TextOverflow.ellipsis,style: style.CustomTheme.normalText,),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          _chooseOption(ds["Email"],ds["Contact"]);
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.only(
                                              top: 20, left: 30, right: 30, bottom: 10),
                                          height: 50,
                                          decoration: style.CustomTheme.buttonDecoration,
                                          child: Text(
                                            'Contact',
                                            style: index%2==0?style.CustomTheme.buttonText:style.CustomTheme.blackButtonText,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          }
                      else{
                        return Text("No Result Found!!!");
                      }
                        }
                 else{
                    return LoadingHelper(loadingText: "Searching...");
                  }
                      },
              ),
            )
          ],
        ),
      ),
    );
  }
}

