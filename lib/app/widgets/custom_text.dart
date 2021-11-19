import 'package:dazle/app/utils/app.dart';
import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double fontSize;

  final Color color;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final TextOverflow overflow;
  final double height;


  CustomText({
    @required this.text,
    this.fontSize = 14.0,
    this.color = App.textColor,
    this.fontWeight = FontWeight.normal,
    this.textAlign = TextAlign.left,
    this.overflow = TextOverflow.clip,
    this.height = 1.5
  });


  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
        fontFamily: "Poppins",
        height: height
      ),
      overflow: overflow,
      textAlign: textAlign,
    );
  }
}