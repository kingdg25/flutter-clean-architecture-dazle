import 'dart:ui';

import 'package:dwellu/app/utils/app.dart';
import 'package:dwellu/app/widgets/form_fields/custom_field_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final Color hintColor;
  final TextEditingController controller;

  final String initialValue;
  final bool readOnly;
  final bool isRequired;
  
  final TextInputType keyboardType;
  final double fontSize;

  final Function validator;
  final Function onTap;
  final Function onSaved;

  final List<TextInputFormatter> inputFormatters;

  final Color fillColor;
  final bool filled;
  
  CustomTextField({
    this.hintText,
    this.hintColor = const Color.fromRGBO(154, 160, 166, 1.0),
    this.controller,
    this.initialValue,
    this.readOnly = false,
    this.isRequired = false,
    this.keyboardType = TextInputType.text,
    this.fontSize = 16.0,
    this.validator,
    this.onTap,
    this.onSaved,
    this.inputFormatters,
    this.fillColor = const Color.fromRGBO(255, 255, 255, 0.4),
    this.filled = false
  });

  @override
  Widget build(BuildContext context) {
    return CustomFieldLayout(
      child: TextFormField(
        controller: controller,
        inputFormatters: inputFormatters,
        initialValue: initialValue,
        readOnly: readOnly,
        onSaved: onSaved,
        validator: (isRequired && validator == null) ? (val) {
          if (val.length == 0){
            return "Required field.";
          }
          return null;
        } : validator,
        onTap: onTap,
        keyboardType: keyboardType,
        style: TextStyle(
          decorationStyle: TextDecorationStyle.dotted,
          color: App.appTextColor,
          fontFamily: "Poppins",
          fontSize: fontSize
        ),
        decoration: InputDecoration(
          isDense: true,
          filled: filled,
          fillColor: fillColor,
          contentPadding: EdgeInsets.all(14.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0)
          ),
          enabledBorder: OutlineInputBorder(
            borderSide:  BorderSide(
              color: filled ? fillColor : Color.fromRGBO(154, 160, 166, 1.0)
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:  BorderSide(
              color: filled ? fillColor : Color.fromRGBO(154, 160, 166, 1.0)
            ),
          ),
          hintText: hintText,
          hintStyle: TextStyle(
            color: hintColor
          )
        ),
      )
    );
  }
}
