import 'package:flutter/material.dart';

class CustomFieldLayout extends StatelessWidget {
  final Widget child;
  final EdgeInsets margin;

  CustomFieldLayout(
      {required this.child,
      this.margin = const EdgeInsets.symmetric(vertical: 6.0)});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: margin,
        constraints: BoxConstraints(maxWidth: 300, minWidth: 250),
        child: child);
  }
}
