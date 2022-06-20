import 'package:flutter/material.dart';

class ListingDetailsIconButton extends StatelessWidget {
  final EdgeInsets margin;
  final String? tooltip;
  final IconData iconData;
  final Function onPressed;
  final double iconPadding;
  final double iconSize;

  ListingDetailsIconButton(
      {this.margin = const EdgeInsets.only(right: 8),
      this.tooltip,
      required this.iconData,
      required this.onPressed,
      this.iconPadding = 12,
      this.iconSize = 20});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: EdgeInsets.all(iconPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        constraints: BoxConstraints(),
        iconSize: iconSize,
        icon: Icon(iconData, color: Colors.black),
        tooltip: tooltip,
        onPressed: onPressed as void Function()?,
      ),
    );
  }
}
