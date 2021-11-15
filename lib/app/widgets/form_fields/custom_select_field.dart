import 'package:dwellu/app/utils/app.dart';
import 'package:dwellu/app/widgets/custom_text.dart';
import 'package:dwellu/app/widgets/form_fields/custom_field_layout.dart';
import 'package:flutter/material.dart';

class CustomSelectField extends StatelessWidget {
  final bool isRequired;

  final String value;
  final Function onChanged;
  final List items;

  final String hintText;
  final double fontSize;

  final Function validator;
  final Function onTap;
  final Function onSaved;
  
  CustomSelectField({
    this.isRequired = false,
    @required this.value,
    @required this.onChanged,
    @required this.items,
    this.hintText,
    this.fontSize = 16.0,
    this.validator,
    this.onTap,
    this.onSaved
  });

  customSelectMenuItems(List arr){
    try {
      if(arr?.isNotEmpty ?? false){
        return arr.map<DropdownMenuItem<String>>((item) =>
          new DropdownMenuItem<String>(
            value: item ?? '',
            child: CustomText(
              text: item ?? '', 
              color: App.appTextColor
            ),
          )
        ).toList();
      }
    } catch (e) {
      print('customSelectMenuItems customSelectMenuItems error $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return CustomFieldLayout(
      child: DropdownButtonFormField<String>(
        value: value,
        onChanged: onChanged,
        onSaved: onSaved,
        isDense: true,
        isExpanded: true,
        items: customSelectMenuItems(items),
        style: TextStyle(
          decorationStyle: TextDecorationStyle.dotted,
          color: App.appTextColor,
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
        validator: (isRequired && validator == null) ? (val) {
          if (val == null || val.length == 0){
            return "Required field.";
          }
          return null;
        } : validator,
      )
    );
  }
}
