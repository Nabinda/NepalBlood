import 'package:bloodnepal/provider/auth_provider.dart';
import 'package:bloodnepal/provider/blood_requests_provider.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:bloodnepal/custom_theme.dart'as style;
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';
import 'package:bloodnepal/helper/date_format_helper.dart' as dfh;

class BloodRequests extends StatefulWidget {
  static const routeName = "/blood_requests";

  @override
  _BloodRequestsState createState() => _BloodRequestsState();
}

class _BloodRequestsState extends State<BloodRequests> {
  bool isInit = true;
  bool isLoading = false;
  SnackBar snackBar = SnackBar(content: Text("Donation Request Accepted"),);
  @override
  void didChangeDependencies() {
    if (isInit) {
      setState(() {
        isLoading = true;
      });
      Provider.of<BloodRequestsProvider>(context, listen: false)
          .getBloodRequests()
          .then((_) {
        setState(() {
          isLoading = false;
        });
      });
    }
    isInit = false;
    super.didChangeDependencies();
  }

  _confirm(String id,String donorId) async{
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Are You Sure?'),
            actions: <Widget>[
              new TextButton(
                  child: new Text('No'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              new TextButton(
                  child: new Text('Yes'),
                  onPressed: () {
                    Provider.of<BloodRequestsProvider>(context,listen: false).updateStatus(id,donorId).whenComplete(()=>complete);
                    Navigator.pop(context);
                  }),
            ],
          );
  });
  }
  complete() async{
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Donation Request Accepted. \n Do you want to add on reminder?'),
            actions: <Widget>[
              new TextButton(
                  child: new Text('No'),
                  onPressed: () {
                    Navigator.pop(context);
                    Phoenix.rebirth(context);
                  }),
              new TextButton(
                  child: new Text('Yes'),
                  onPressed: () {
                    Provider.of<BloodRequestsProvider>(context,listen: false).updateStatus(id,donorId).whenComplete(()=>complete);
                    Navigator.pop(context);
                  }),
            ],
          );
        });
  }
  Stream
  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<AuthProvider>(context,listen: false).currentUser;
    final requestList =
    Provider.of<BloodRequestsProvider>(context, listen: false).getBloodRequest();
    final pendingRequest = requestList.where((element) => element.status=="Pending").toList();
    return Scaffold(
      body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              pinned: true,
              floating: true,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                background: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        dfh.DateFormatHelper.dayFormat.format(DateTime.now()),
                        style: style.CustomTheme.calendarText,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        dfh.DateFormatHelper.dateFormat.format(DateTime.now()) +
                            "," +
                            dfh.DateFormatHelper.monthFormat.format(DateTime.now()),
                        style: style.CustomTheme.calendarText,
                      ),
                      Text(
                        dfh.DateFormatHelper.yearFormat.format(DateTime.now()),
                        style: style.CustomTheme.calendarText,
                      ),
                    ],
                  ),
                ),
                title: Text("Blood Requests",
                    style: style.CustomTheme.eventHeader //TextStyle
                ), //Text
              ), //FlexibleSpaceBar
              expandedHeight: 230,
              backgroundColor:
              style.CustomTheme.themeColor, //IconButton//<Widget>[]
            ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                (context,index){
                  if(DateTime.now().difference(pendingRequest[index].date).isNegative) {
                return

                  Container(
                  margin: EdgeInsets.symmetric(horizontal: 15.0,vertical: 10.0),
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color:style.CustomTheme.themeColor.withOpacity(0.7),
                  ),
                  child: Container(
                        padding: EdgeInsets.only(left: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Requestor Name: "+pendingRequest[index].name,style: style.CustomTheme.normalText,),
                            Text("Patient Name: "+pendingRequest[index].patientName,style: style.CustomTheme.normalText,),
                            Text("Location: "+pendingRequest[index].location,style: style.CustomTheme.normalText,),
                            Text("Blood Group: "+pendingRequest[index].bloodGroup,style: style.CustomTheme.normalText,),
                            Text("Contact: "+pendingRequest[index].contact,style: style.CustomTheme.normalText,),
                            Text("Date: "+dfh.DateFormatHelper.eventDate.format(pendingRequest[index].date)+" "+formatDate(
                                DateTime(2019, 08, 1, requestList[index].time.hour, pendingRequest[index].time.minute),
                                [hh, ':', nn, " ", am]).toString(),style: style.CustomTheme.normalText,),
                            Center(
                              child: TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: style.CustomTheme.themeColor,
                                    primary: Colors.white,
                                    elevation: 10,minimumSize: Size(100, 40),),
                                  onPressed: () {
                                    _confirm(requestList[index].id,userInfo.uid);
                                  },
                                  child: Text("Donate")),
                            ),
                          ],
                        ),
                  ),
                );
              }
              return null;
                },
                childCount: pendingRequest.length
            ),
          ),
        ],
      ),
    );
  }
}
