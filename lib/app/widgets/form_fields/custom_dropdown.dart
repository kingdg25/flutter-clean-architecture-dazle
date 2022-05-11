import 'dart:ui';

import 'package:dazle/app/utils/app.dart';
import 'package:dazle/app/widgets/form_fields/custom_field_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomDropdownField extends StatelessWidget {
  final List<DropdownMenuItem<String>>? items;
  final Function(String?)? onChangeEvent;
  final double fontSize;
  String hintText;
  final Color fillColor;
  final bool filled;
  final Color hintColor;
  String? value;

  CustomDropdownField({
    this.items,
    this.hintColor = App.hintColor,
    this.onChangeEvent,
    this.fontSize = 16.0,
    this.hintText = '',
    this.fillColor = const Color.fromRGBO(255, 255, 255, 0.4),
    this.filled = false,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return CustomFieldLayout(
        child: DropdownButtonFormField(
      isExpanded: true,
      items: items,
      value: value,
      // iconSize: 35,
      onChanged: onChangeEvent,
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
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: filled ? fillColor : App.hintColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: filled ? fillColor : App.hintColor),
          ),
          hintText: hintText,
          hintStyle: TextStyle(color: hintColor)),
    ));
  }
}
