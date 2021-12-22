import 'package:flutter/material.dart';

class ListingDetailsIconButton extends StatelessWidget {
  final EdgeInsets margin;
  final String tooltip;
  final IconData iconData;
  final Function onPressed;

  ListingDetailsIconButton({
    this.margin = const EdgeInsets.only(right: 8),
    this.tooltip,
    @required this.iconData,
    @required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        constraints: BoxConstraints(),
        iconSize: 20,
        icon: Icon(
          iconData, 
          color: Colors.black
        ),
        tooltip: tooltip,
        onPressed: onPressed,
      ),
    );
  }
}