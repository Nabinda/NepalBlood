import 'package:bloodnepal/provider/events_provider.dart';
import 'package:bloodnepal/screens/events_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:bloodnepal/custom_theme.dart' as style;
import 'package:provider/provider.dart';
import 'package:bloodnepal/helper/date_format_helper.dart' as dfh;

class Events extends StatelessWidget {
  static const String routeName = "/Events_Nearby";
  @override
  Widget build(BuildContext context) {
    final events =
        Provider.of<EventProvider>(context, listen: false).getEvents();
    return Scaffold(
        body: CustomScrollView(
      slivers: <Widget>[
        //------App Bar-----------
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
            title: Text("UpComing Events",
                style: style.CustomTheme.eventHeader //TextStyle
                ), //Text
          ), //FlexibleSpaceBar
          expandedHeight: 230,
          backgroundColor:
              style.CustomTheme.themeColor, //IconButton//<Widget>[]
        ),
        //Events List
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => Container(
              height: 70,
              child: InkWell(
                onTap: (){
                      Navigator.pushNamed(context, EventsDetailScreen.routeName,arguments: events[index].id);
                },
                child: ListTile(
                  tileColor: (index % 2 == 0)
                      ? Colors.white
                      : style.CustomTheme.themeColor.withOpacity(0.7),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(dfh.DateFormatHelper.eventDate
                          .format(events[index].startDate)),
                      Text(events[index].title)
                    ],
                    //Text
                  ), //Center
                ),
              ),
            ), //ListTile
            childCount: events.length,
          ), //SliverChildBuildDelegate
        ) //SliverList
      ], //<Widget>[]
    ));
  }
}

