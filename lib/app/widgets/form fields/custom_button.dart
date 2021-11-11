import 'package:dwellu/app/utils/dwellu.dart';
import 'package:dwellu/app/widgets/custom_text.dart';
import 'package:flutter/material.dart';



class CustomButton extends StatelessWidget {
  
  final String text;
  final Function onPressed;
  final EdgeInsets padding;
  final bool expanded;
  final bool main;
  final double fontSize;
  final double height;
  final double width;
  final double borderRadius;
  final Color backgroudColor;
  final Color textColor;
  final double elevation;
  final Color disabledColor;

  CustomButton({
    @required this.text, 
    @required this.onPressed,
    this.padding, 
    this.expanded = false,
    this.main = true,
    this.fontSize = 13.0,
    this.height = 46.0,
    this.width,
    this.borderRadius = 15.0,
    this.backgroudColor = Dwellu.appMainColor,
    this.textColor,
    this.elevation = 0.0,
    this.disabledColor = Colors.white30,
  });

  Widget buttonText({
    String text,
    bool main,
    double fontSize,
  }) {
    return CustomText(
      text: text,
      color: (textColor != null) ? textColor : (main ? Colors.white : backgroudColor),
      fontSize: fontSize,
      fontWeight: FontWeight.w700,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: elevation,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
      child: Container(
        decoration: BoxDecoration(
          color: main ? backgroudColor : backgroudColor.withOpacity(0.01),
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: (onPressed != null) ? backgroudColor : disabledColor,
            width: 1.5,
          ),
        ),
        child: Container(
          constraints: BoxConstraints(
            minWidth: 100,
            maxWidth: 270,
          ),
          height: height,
          width: width,
          padding: padding,
          child: FlatButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(borderRadius))
            ),
            disabledColor: disabledColor,
            child: expanded ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buttonText(text: text, fontSize: fontSize, main: main)
              ]
            ) : buttonText(text: text, fontSize: fontSize, main: main),
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }
}
