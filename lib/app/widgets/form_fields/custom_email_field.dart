import 'package:dazle/app/utils/app.dart';
import 'package:dazle/app/widgets/form_fields/custom_field_layout.dart';
import 'package:flutter/material.dart';

class CustomEmailField extends StatelessWidget {
  final String? hintText;
  final Color hintColor;
  final double fontSize;

  final TextEditingController? controller;

  final Function? onSaved;

  final Color fillColor;
  final bool filled;

  final bool readOnly;

  const CustomEmailField(
      {this.hintText,
      this.hintColor = App.hintColor,
      this.controller,
      this.fontSize = 16.0,
      this.onSaved,
      this.fillColor = const Color.fromRGBO(255, 255, 255, 0.4),
      this.filled = false,
      this.readOnly = false});

  @override
  Widget build(BuildContext context) {
    return CustomFieldLayout(
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        onSaved: onSaved as void Function(String?)?,
        validator: (val) {
          Pattern emailPattern =
              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
          RegExp regex = new RegExp(emailPattern as String);

          if (val!.length == 0) {
            return "Required field.";
          } else if (!regex.hasMatch(val)) {
            return 'Enter Valid Email';
          }

          return null;
        },
        keyboardType: TextInputType.emailAddress,
        style: TextStyle(
            decorationStyle: TextDecorationStyle.dotted,
            color: App.fieldTextColor,
            fontFamily: "Poppins",
            fontSize: fontSize),
        decoration: InputDecoration(
            isDense: true,
            filled: filled,
            fillColor: fillColor,
            contentPadding: EdgeInsets.all(14.0),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: filled ? fillColor : App.hintColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: filled ? fillColor : App.hintColor),
            ),
            hintText: hintText,
            hintStyle: TextStyle(color: hintColor)),
      ),
    );
  }
}
