import 'package:custom_radio_grouped_button/CustomButtons/ButtonTextStyle.dart';
import 'package:custom_radio_grouped_button/CustomButtons/CustomRadioButton.dart';
import 'package:dazle/app/utils/app.dart';
import 'package:flutter/material.dart';

class CustomRadioGroupButton extends StatelessWidget {
  final double radioPadding;
  final double radioWidth;
  final List<String> radioList;
  final Function radioButtonValues;

  CustomRadioGroupButton({
    this.radioPadding = 6.0,
    this.radioWidth = 100.0,
    @required this.radioList,
    @required this.radioButtonValues
  });

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
          textStyle: App.textStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600
          ),
        ),
        padding: radioPadding,
        width: radioWidth,
        buttonLables: radioList,
        buttonValues: radioList,
        radioButtonValue: radioButtonValues
      ),
    );
  }
}
