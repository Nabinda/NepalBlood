import 'package:flutter/material.dart';
import 'package:bloodnepal/custom_theme.dart' as style;

class LoadingHelper extends StatelessWidget {
  final String loadingText;
  LoadingHelper({@required this.loadingText});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(
                style.CustomTheme.themeColor,
              )),
          SizedBox(
            height: 20,
          ),
          Text(
            loadingText,
            style: style.CustomTheme.normalText,
          )
        ],
      ),
    );
  }
}
