import 'package:bloodnepal/helper/loading_helper.dart';
import 'package:bloodnepal/model/notification_model.dart';
import 'package:bloodnepal/provider/events_provider.dart';
import 'package:bloodnepal/screens/events_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:bloodnepal/helper/date_format_helper.dart' as dfh;
import 'package:bloodnepal/custom_theme.dart' as style;
import 'package:provider/provider.dart';
class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  bool isInit = true;
  bool isLoading = false;
  @override
  void didChangeDependencies() {
    if (isInit) {
      setState(() {
        isLoading = true;
      });
      Provider.of<EventProvider>(context, listen: false)
          .getNotificationDetail()
          .then((_) {
        Provider.of<EventProvider>(context, listen: false)
            .getEventDetail().then((_){
          setState(() {
            isLoading = false;
          });
        });

      });
    }
    isInit = false;
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    List<NotificationModel> notification = Provider.of<EventProvider>(context,listen: false).getNotifications();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: style.CustomTheme.themeColor,
        title: Text("Notifications"),
        centerTitle: true,
        actions: [
          IconButton(icon: Icon(Icons.chat_bubble,color: Colors.white,), onPressed: null)
          //TODO: Chatting features
        ],
      ),
      body: isLoading?Center(child: LoadingHelper(loadingText: "Fetching Data")):ListView.builder(itemBuilder: (builder,index){
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: (){
                print(notification[index].id);
                Navigator.of(context).pushNamed(EventsDetailScreen.routeName,arguments: notification[index].id);
              },
              child: Container(
                height: 50,
                padding: EdgeInsets.only(left: 10,top: 5),
                child: Text(notification[index].title.trimRight()+" is being held in "+notification[index].location.trim()+" at "+dfh.DateFormatHelper.eventDate
                    .format(notification[index].date)),
              ),
            ),
            Divider(
              thickness: 0.5,
              color: style.CustomTheme.themeColor,
            ),
          ],
        );
      },itemCount: notification.length),
    );
  }
}
