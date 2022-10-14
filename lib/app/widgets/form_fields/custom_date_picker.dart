import 'dart:ui';

import 'package:dazle/app/utils/app.dart';
import 'package:dazle/app/widgets/form_fields/custom_field_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomDatePicker extends StatelessWidget {
  final String? hintText;
  final Color hintColor;
  final TextEditingController? controller;

  final String? initialValue;
  final bool readOnly;
  final bool isRequired;

  final TextInputType keyboardType;
  final double fontSize;

  final Function? validator;
  final Function? onTap;
  final Function? onSaved;

  final List<TextInputFormatter>? inputFormatters;

  final Color fillColor;
  final bool filled;

  final TextCapitalization textCapitalization;

  final int? minLines;
  final int? maxLines;

  final int? maxLength;

  final Function? suffixIconOnTap;

  CustomDatePicker(
      {this.hintText,
      this.hintColor = App.hintColor,
      this.controller,
      this.initialValue,
      this.readOnly = false,
      this.isRequired = false,
      this.keyboardType = TextInputType.text,
      this.fontSize = 14.0,
      this.validator,
      this.onTap,
      this.onSaved,
      this.inputFormatters,
      this.fillColor = const Color.fromRGBO(255, 255, 255, 0.4),
      this.filled = false,
      this.textCapitalization = TextCapitalization.none,
      this.minLines,
      this.maxLength,
      this.maxLines,
      this.suffixIconOnTap});

  @override
  Widget build(BuildContext context) {
    return CustomFieldLayout(
        child: TextFormField(
      controller: controller,
      inputFormatters: inputFormatters,
      initialValue: initialValue,
      readOnly: readOnly,
      onSaved: onSaved as void Function(String?)?,
      minLines: minLines,
      maxLines: maxLines,
      maxLength: maxLength == null ? null : maxLength,
      validator: (isRequired && validator == null)
          ? (val) {
              if (val?.length == 0) {
                return "Required field.";
              }
              return null;
            }
          : validator as String? Function(String?)?,
      onTap: onTap as void Function()?,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      style: TextStyle(
          decorationStyle: TextDecorationStyle.dotted,
          color: App.fieldTextColor,
          fontFamily: "Poppins",
          fontSize: fontSize),
      decoration: InputDecoration(
          suffixIcon: IconButton(
            onPressed: suffixIconOnTap as void Function()?,
            focusColor: App.mainColor,
            icon: Icon(
              Icons.calendar_month,
              size: 30,
              color: Colors.blue,
            ),
          ),
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
