import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bloodnepal/custom_theme.dart' as style;

class FunFacts extends StatelessWidget {
  List<FunFact> _funFacts = [
    FunFact("There's Gold in Your Blood.", "doremon.png", Colors.blue),
    FunFact("Nearly 7% of the body weight of a human is made up of blood.", "mickeymouse.png", Colors.red),
    FunFact("Donating blood never reduces a person’s physical energy.", "simpson.png", Colors.yellow),
    FunFact("One pint of blood is capable of saving 3 lives.", "sinchan.png", Colors.green),
    FunFact("Someone in the world actually donates blood every 8 minutes.", "spongebob.png", Colors.amberAccent),
    FunFact("Not Every Blood is Red.", "tomNjerry.png", Colors.redAccent),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Fun Facts",style: style.CustomTheme.headerBlackNoto,
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            margin: EdgeInsets.only(top: 8.0),
            child: CarouselSlider.builder(itemCount: _funFacts.length, itemBuilder:(ctx,index){
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: _funFacts[index].bgColor
                ),
                child: Row(
                children: [
                  Image.asset("assets/images/"+_funFacts[index].icon,height: 150,width: 100),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("DO YOU KNOW?",style: style.CustomTheme.normalHeader,),
                      Text(_funFacts[index].fact,style: style.CustomTheme.normalText,)
                      ],
                    ),
                  )
                ],
                ),
              );
            }, options: CarouselOptions(
              aspectRatio: 3/1.5,
              autoPlay: false,
              scrollDirection: Axis.horizontal,
              enlargeCenterPage: true,
              enableInfiniteScroll: false,
            )),
          )
        ],
      ),
    );
  }
}
class FunFact{
  final fact;
  final icon;
  Color bgColor;
  FunFact(this.fact,this.icon,this.bgColor);
}

