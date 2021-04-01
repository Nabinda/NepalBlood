import 'package:bloodnepal/screens/blood_bank.dart';
import 'package:bloodnepal/screens/donor_screen.dart';
import 'package:bloodnepal/screens/events.dart';
import 'package:bloodnepal/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:bloodnepal/custom_theme.dart' as style;

class Categories extends StatelessWidget{
  final List<Cat> _categories = [
    Cat("Events Nearby", "events.png",Events.routeName),
    Cat("Find a Donor", "search.png",SearchScreen.routeName),
    Cat("Blood Bank", "blood-bank.png",BloodBankScreen.routeName),
    Cat("Become a Donor", "donor.png",DonorScreen.routeName)
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Categories",style: style.CustomTheme.headerBlackNoto,
          ),
          Container(
            height: 150,
            margin: EdgeInsets.symmetric(horizontal: 5.0,vertical: 10.0),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (ctx,ind){
                return InkWell(
                  onTap: (){
                    Navigator.pushNamed(context, _categories[ind].routeName);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xffF99297),
                        width: 1
                      )
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 8.0),
                    padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 5.0),
                    child: Column(
                      children: [
                          Image.asset("assets/images/"+_categories[ind].icon,height: 100,width: 100,color: Color(0xffF99297),),
                          Text(_categories[ind].name)
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
class Cat{
  final name;
  final icon;
  final routeName;
  Cat(this.name,this.icon,this.routeName);
}
