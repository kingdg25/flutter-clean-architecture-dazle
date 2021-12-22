import 'package:custom_radio_grouped_button/CustomButtons/ButtonTextStyle.dart';
import 'package:custom_radio_grouped_button/CustomButtons/CustomCheckBoxGroup.dart';
import 'package:dazle/app/utils/app.dart';
import 'package:flutter/material.dart';

class CustomCheckBoxGroupButton extends StatelessWidget {
  final double checkBoxPadding;
  final double checkBoxWidth;
  final List<String> buttonLables;
  final List<String> buttonValuesList;
  final Function checkBoxButtonValues;
  final dynamic defaultSelected;

  CustomCheckBoxGroupButton({
    this.checkBoxPadding = 6.0,
    this.checkBoxWidth = 100.0,
    @required this.buttonLables,
    @required this.buttonValuesList,
    @required this.checkBoxButtonValues,
    this.defaultSelected
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 15),
      child: CustomCheckBoxGroup(
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
        padding: checkBoxPadding,
        width: checkBoxWidth,
        buttonLables: buttonLables,
        buttonValuesList: buttonValuesList,
        checkBoxButtonValues: checkBoxButtonValues,
        defaultSelected: defaultSelected,
      ),
    );
  }
}
