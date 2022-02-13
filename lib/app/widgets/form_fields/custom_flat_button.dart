import 'package:dazle/app/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class CustomFlatButton extends StatelessWidget {
  final String? text;
  final double fontSize;
  final Color color;
  final Function? onPressed;
  final FontWeight fontWeight;
  final EdgeInsets padding;
  

  CustomFlatButton({
    required this.text,
    required this.onPressed,
    this.fontSize = 14.0,
    this.color = Colors.blue,
    this.fontWeight = FontWeight.normal,
    this.padding = const EdgeInsets.all(8.0),
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0)
      ),
      onPressed: onPressed as void Function()?,
      minWidth: 0,
      height: 0,
      padding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      child: Container(
        padding: padding,
        child: CustomText(
          text: text,
          fontSize: fontSize,
          color: color,
          fontWeight: fontWeight,
        ),
      )
    );
  }
}
