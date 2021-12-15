import 'package:dazle/app/utils/app.dart';
import 'package:dazle/app/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class TitleField extends StatelessWidget {
  final String title;
  final double fontSize;
  final Alignment alignment;
  final bool optional;
  final optionalText;
  final Color color;
  final FontWeight fontWeight;


  TitleField({
    @required this.title,
    this.fontSize = 17.0,
    this.alignment = Alignment.centerLeft,
    this.optional = false,
    this.optionalText = 'Optional',
    this.color = App.textColor,
    this.fontWeight = FontWeight.w500,
  });

  Widget mainText() {
    return CustomText(
      text: title,
      color: color,
      fontSize: fontSize, 
      fontWeight: fontWeight,
    );
  }

  Widget mainTextWithOptional() {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: title,
          ),
          TextSpan(
            text: " ($optionalText)",
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.normal
            )
          )
        ]
      ),
      style: TextStyle(
        color: color,
        fontSize: fontSize, 
        fontWeight: fontWeight,
        fontFamily: 'Poppins',
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 300, minWidth: 250),
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: Align(
        alignment: alignment,
        child: optional ? mainTextWithOptional() : mainText(),
      ),
    );
  }
}