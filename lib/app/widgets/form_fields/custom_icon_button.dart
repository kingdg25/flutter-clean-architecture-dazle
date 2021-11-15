import 'package:dwellu/app/utils/app.dart';
import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final IconData iconData;
  final Function onPressed;
  final Alignment alignment;

  CustomIconButton({
    this.iconData = Icons.arrow_right_alt,
    @required this.onPressed,
    this.alignment = Alignment.centerRight
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      constraints: BoxConstraints(maxWidth: 300, minWidth: 250),
      child: FlatButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: EdgeInsets.symmetric(vertical: 6.0),
        color: App.appMainColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0))
        ),
        child: Icon(
          iconData, //Icons.arrow_right_alt,
          color: Colors.white,
          size: 35.0,
        ),
        onPressed: onPressed
      ),
    );
  }
}