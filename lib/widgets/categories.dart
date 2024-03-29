import 'package:bloodnepal/model/Categories_model.dart';
import 'package:bloodnepal/screens/add_events.dart';
import 'package:bloodnepal/screens/blood_bank.dart';
import 'package:bloodnepal/screens/blood_requests.dart';
import 'package:bloodnepal/screens/donor_screen.dart';
import 'package:bloodnepal/screens/events.dart';
import 'package:bloodnepal/screens/request_blood.dart';
import 'package:bloodnepal/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:bloodnepal/custom_theme.dart' as style;

class Categories extends StatelessWidget {
  final String role;
  Categories({@required this.role});
  @override
  Widget build(BuildContext context) {
    final List<CategoriesModel> _categories = [
      CategoriesModel(
          name: "Events Nearby",
          icon: "events.png",
          routeName: Events.routeName),
      CategoriesModel(
          name: "Find a Donor",
          icon: "search.png",
          routeName: SearchScreen.routeName),
      CategoriesModel(
          name: "Blood Bank",
          icon: "blood-bank.png",
          routeName: BloodBankScreen.routeName),
      CategoriesModel(
          name: "Request Blood",
          icon: "request.png",
          routeName: RequestBlood.routeName),
      if (role == "Donor" || role == "Admin")
        CategoriesModel(
            name: "Blood Requests",
            icon: "top.png",
            routeName: BloodRequests.routeName),
      if (role == "Seeker")
        CategoriesModel(
            name: "Become a Donor",
            icon: "donor.png",
            routeName: DonorScreen.routeName),
    ];
    return Container(
      padding: EdgeInsets.only(left: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Categories",
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
