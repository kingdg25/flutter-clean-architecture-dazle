import 'package:dazle/app/utils/app.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class CustomIconButton extends StatelessWidget {
  final bool main;
  final Color backgroudColor;
  final double borderRadius;

  final IconData iconData;
  final Function onPressed;
  final Alignment? alignment;

  CustomIconButton({
    this.main = true,
    this.backgroudColor = App.mainColor,
    this.borderRadius = 5.0,
    this.iconData = Icons.arrow_right_alt,
    required this.onPressed,
    this.alignment = Alignment.centerRight
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      constraints: BoxConstraints(maxWidth: 300, minWidth: 100),
      child: FlatButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: EdgeInsets.symmetric(vertical: 6.0),
        color: main ? backgroudColor : Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: backgroudColor,
            width: 1.5
          )
        ),
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY( main ? 0: math.pi ),
          child: Icon(
            iconData, //Icons.arrow_right_alt,
            color: main ? Colors.white : backgroudColor,
            size: 35.0,
          ),
        ),
        onPressed: onPressed as void Function()?
      ),
    );
  }
}
