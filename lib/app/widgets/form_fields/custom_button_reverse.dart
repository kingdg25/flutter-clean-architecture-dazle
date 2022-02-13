import 'package:dazle/app/utils/app.dart';
import 'package:dazle/app/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class CustomButtonReverse extends StatelessWidget {
  final String text;
  final Function onPressed;
  final EdgeInsets? padding;
  final bool expanded;
  final bool main;
  final double fontSize;
  final double height;
  final double? width;
  final double borderRadius;
  final Color backgroudColor;
  final Color? textColor;
  final double elevation;
  final Color disabledColor;

  CustomButtonReverse({
    required this.text,
    required this.onPressed,
    this.padding,
    this.expanded = false,
    this.main = true,
    this.fontSize = 14.0,
    this.height = 40.0,
    this.width,
    this.borderRadius = 5.0,
    this.backgroudColor = App.mainColor,
    this.textColor,
    this.elevation = 0.0,
    this.disabledColor = Colors.white30,
  });

  Widget buttonText({
    String? text,
    bool? main,
    double? fontSize,
  }) {
    return CustomText(
      text: text,
      color: (textColor != null)
          ? textColor
          : (main! ? Colors.white : backgroudColor),
      fontSize: fontSize,
      fontWeight: FontWeight.w700,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: elevation,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius)),
      child: Container(
        decoration: BoxDecoration(
          color: main ? backgroudColor : Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: (onPressed != null) ? textColor! : disabledColor,
            width: 1.5,
          ),
        ),
        child: Container(
          constraints: BoxConstraints(
            minWidth: 100,
            maxWidth: 300,
          ),
          height: height,
          width: width,
          padding: padding,
          child: FlatButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(borderRadius))),
            disabledColor: disabledColor,
            child: expanded
                ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    buttonText(text: text, fontSize: fontSize, main: main)
                  ])
                : buttonText(text: text, fontSize: fontSize, main: main),
            onPressed: onPressed as void Function()?,
          ),
        ),
      ),
    );
  }
}
