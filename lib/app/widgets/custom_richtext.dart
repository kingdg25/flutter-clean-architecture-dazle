import 'package:dazle/app/utils/app.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CustomRichText extends StatelessWidget {
  final String mainText;
  final String? valueText;
  final FontWeight? mainTextFontWeight;
  final FontWeight? valueTextfontWeight;
  final TextDecoration? mainTextDecoration;
  final TextDecoration? valueTextDecoration;
  final mainTextCallback;
  final valueTextCallback;

  const CustomRichText({
    required this.mainText,
    this.mainTextFontWeight,
    this.mainTextDecoration,
    this.mainTextCallback,
    required this.valueText,
    this.valueTextfontWeight,
    this.valueTextDecoration,
    this.valueTextCallback,
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
              fontWeight: mainTextFontWeight == null
                  ? FontWeight.w700
                  : mainTextFontWeight,
              decoration: mainTextDecoration == null
                  ? TextDecoration.none
                  : mainTextDecoration,
            ),
            recognizer: TapGestureRecognizer()..onTap = mainTextCallback,
          ),
          TextSpan(
            text: valueText,
            style: TextStyle(
              fontSize: 15,
              fontWeight: valueTextfontWeight == null
                  ? FontWeight.normal
                  : valueTextfontWeight,
              color: App.textColor,
              decoration: valueTextDecoration == null
                  ? TextDecoration.none
                  : valueTextDecoration,
            ),
            recognizer: TapGestureRecognizer()..onTap = valueTextCallback,
          ),
        ],
      ),
    );
  }
}
