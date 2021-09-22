import 'package:bloodnepal/model/Categories_model.dart';
import 'package:bloodnepal/screens/add_events.dart';
import 'package:bloodnepal/screens/all_events.dart';
import 'package:bloodnepal/screens/blood_request_status.dart';
import 'package:bloodnepal/screens/donor_lists.dart';
import 'package:flutter/material.dart';
import 'package:bloodnepal/custom_theme.dart' as style;

class AdminPanel extends StatefulWidget {
  const AdminPanel({Key key}) : super(key: key);

  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  final List<CategoriesModel> _categories = [
    CategoriesModel(
        name: "Add Events",
        icon: "add_event.png",
        routeName: AddEventsScreen.routeName),
    CategoriesModel(
        name: "All Events",
        icon: "events.png",
        routeName: AllEvents.routeName),
    CategoriesModel(
        name: "Requests Status",
        icon: "request.png",
        routeName: BloodRequestStatus.routeName),
    CategoriesModel(
        name: "Donor Lists",
        icon: "top.png",
        routeName: DonorLists.routeName),
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Admin Access",
            style: style.CustomTheme.headerBlackNoto,
          ),
          Container(
            height: 150,
            margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (ctx, ind) {
                return InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, _categories[ind].routeName);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.35,
                    decoration: BoxDecoration(
                        border: Border.all(color: Color(0xffF99297), width: 1)),
                    margin: EdgeInsets.symmetric(horizontal: 8.0),
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/images/" + _categories[ind].icon,
                          height: 100,
                          width: 100,
                          color: Color(0xffF99297),
                        ),
                        FittedBox(
                            fit: BoxFit.fill,
                            child: Text(_categories[ind].name))
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
