// import 'package:custom_radio_grouped_button/CustomButtons/ButtonTextStyle.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:dazle/app/utils/app.dart';
import 'package:flutter/material.dart';

class CustomRadioGroupButton extends StatelessWidget {
  final double radioPadding;
  final double radioWidth;
  final List<String> buttonLables;
  final List<String> buttonValues;
  final Function radioButtonValue;
  final String? defaultSelected;
  final bool autowidth;

  CustomRadioGroupButton(
      {this.radioPadding = 6.0,
      this.radioWidth = 100.0,
      required this.buttonLables,
      required this.buttonValues,
      required this.radioButtonValue,
      this.defaultSelected,
      this.autowidth = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 15),
      child: CustomRadioButton(
        elevation: 0,
        unSelectedBorderColor: App.hintColor,
        unSelectedColor: Colors.white,
        selectedBorderColor: App.mainColor,
        selectedColor: Color.fromRGBO(51, 212, 157, 0.1),
        buttonTextStyle: ButtonTextStyle(
          unSelectedColor: App.textColor,
          selectedColor: App.textColor,
          textStyle: App.textStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
        padding: radioPadding,
        width: radioWidth,
        buttonLables: buttonLables,
        buttonValues: buttonValues,
        radioButtonValue: radioButtonValue as void Function(String),
        defaultSelected: defaultSelected,
        autoWidth: autowidth,
        height: autowidth == true ? 50 : 35,
        // enableShape: true,
        // radius: 5,
      ),
    );
  }
}
