import 'package:dwellu/app/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class TitleField extends StatelessWidget {
  final String title;
  final double fontSize;
  final Alignment alignment;
  final bool optional;
  final optionalText;


  TitleField({
    @required this.title,
    this.fontSize = 17.0,
    this.alignment = Alignment.centerLeft,
    this.optional = false,
    this.optionalText = 'Optional'
  });

  Widget mainText() {
    return CustomText(
      text: title,
      color: Color.fromRGBO(46, 53, 61, 1.0),
      fontSize: fontSize, 
      fontWeight: FontWeight.w500,
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
        color: Color.fromRGBO(46, 53, 61, 1.0),
        fontSize: fontSize, 
        fontWeight: FontWeight.w500,
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