import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double fontSize;

  final Color color;
  final FontWeight fontWeight;
  final TextAlign textAlign;


  CustomText({
    @required this.text,
    this.fontSize = 14.0,
    this.color = Colors.black,
    this.fontWeight = FontWeight.normal,
    this.textAlign = TextAlign.left
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
      ),
      overflow: TextOverflow.ellipsis,
      textAlign: textAlign,
    );
  }
}