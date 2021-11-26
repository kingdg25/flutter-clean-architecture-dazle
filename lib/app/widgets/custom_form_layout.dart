import 'package:flutter/material.dart';

class CustomFormLayout extends StatelessWidget {
  final Widget child;
  final EdgeInsets margin;
  final Key formKey;
  
  CustomFormLayout({
    @required this.child,
    this.formKey,
    this.margin
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 5,
            color: Color.fromRGBO(0, 0, 0, 0.25)
          )
        ]
      ),
      child: Form(
        key: formKey,
        child: child
      )
    );
  }
}
