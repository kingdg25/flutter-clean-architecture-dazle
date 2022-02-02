import 'package:dazle/app/utils/app.dart';
import 'package:flutter/material.dart';

class CustomRichText extends StatelessWidget {
  final String mainText;
  final String valueText;

  const CustomRichText({
    @required this.mainText,
    @required this.valueText,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: mainText,
            style: TextStyle(
                fontSize: 15,
                color: App.textColor,
                fontWeight: FontWeight.w700),
          ),
          TextSpan(
            text: valueText,
            style: TextStyle(
              fontSize: 15,
              color: App.textColor,
            ),
          ),
        ],
      ),
    );
  }
}
