// import 'dart:ui';

import 'package:dazle/app/utils/app.dart';
// import 'package:dazle/app/widgets/form_fields/custom_field_layout.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

class CustomDropdownSearch extends StatelessWidget {
  final List<String>? items;
  final Function(String?)? onChangeEvent;
  final double fontSize;
  final String hintText;
  final Color fillColor;
  final bool filled;
  final Color hintColor;
  final String? selctedItem;
  final bool isEnabled;

  CustomDropdownSearch({
    required this.items,
    this.hintColor = App.hintColor,
    required this.onChangeEvent,
    this.fontSize = 16.0,
    this.hintText = '',
    this.fillColor = const Color.fromRGBO(255, 255, 255, 0.4),
    this.selctedItem,
    this.isEnabled = true,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<String>(
      enabled: isEnabled,
      mode: Mode.DIALOG,
      showSelectedItem: true,
      items: items,
      showSearchBox: true,
      validator: (String? item) {
        if (item == null) {
          return "Required field";
        } else {
          return null;
        }
      },
      dropdownSearchDecoration: InputDecoration(
          labelStyle: TextStyle(
              decorationStyle: TextDecorationStyle.dotted,
              color: App.fieldTextColor,
              fontFamily: "Poppins",
              fontSize: fontSize),
          isDense: false,
          filled: filled,
          fillColor: fillColor,
          contentPadding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: filled ? fillColor : App.hintColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: filled ? fillColor : App.hintColor),
          ),
          hintText: hintText,
          hintStyle: TextStyle(color: hintColor)),
      hint: hintText,
      selectedItem: selctedItem,
      onChanged: onChangeEvent,
    );
  }
}
