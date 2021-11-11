import 'dart:ui';

import 'package:dwellu/app/utils/dwellu.dart';
import 'package:dwellu/app/widgets/form%20fields/custom_field_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;

  final String initialValue;
  final bool readOnly;
  final bool isRequired;
  
  final TextInputType keyboardType;
  final double fontSize;
  final double labelFontSize;

  final Function validator;
  final Function onTap;
  final Function onSaved;

  final List<TextInputFormatter> inputFormatters;
  
  CustomTextField({
    this.hintText,
    this.controller,
    this.initialValue,
    this.readOnly = false,
    this.isRequired = false,
    this.keyboardType = TextInputType.text,
    this.fontSize = 16.0,
    this.labelFontSize = 16.0,
    this.validator,
    this.onTap,
    this.onSaved,
    this.inputFormatters
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
          color: Dwellu.appTextColor,
          fontFamily: "Poppins",
          fontSize: fontSize
        ),
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.all(14.0),
          border: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
            borderSide:  BorderSide(color: Color.fromRGBO(154, 160, 166, 1.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:  BorderSide(color: Color.fromRGBO(154, 160, 166, 1.0)),
          ),
          hintText: hintText,
          hintStyle: TextStyle(
            color: Color.fromRGBO(154, 160, 166, 1.0)
          )
        ),
      )
    );
  }
}
