import 'package:dazle/app/utils/app_constant.dart';
import 'package:flutter/material.dart';

class CustomFormLayout extends StatelessWidget {
  final Widget child;
  final EdgeInsets? margin;
  final Key? formKey;
  final bool? isAutoValidate;

  CustomFormLayout(
      {required this.child, this.formKey, this.margin, this.isAutoValidate});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: margin,
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
            boxShadow: [AppConstant.boxShadow]),
        child: Form(
            key: formKey,
            autovalidateMode: isAutoValidate == true
                ? AutovalidateMode.onUserInteraction
                : null,
            child: child));
  }
}
