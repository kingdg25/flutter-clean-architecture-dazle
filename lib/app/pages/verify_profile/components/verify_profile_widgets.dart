import 'package:flutter/material.dart';
import 'package:dazle/app/widgets/custom_text.dart';
// import 'package:dazle/app/utils/app.dart';

class VerifyProfileWidgets {
  List<Widget> requirementsGenerator(List<String> requirements) {
    List<Widget> requirementsWidgets = <Widget>[];

    for (var i = 0; i < requirements.length; i++) {
      requirementsWidgets.add(CustomText(
        text: requirements[i],
        fontSize: 13.0,
        fontWeight: FontWeight.w600,
      ));
      requirementsWidgets.add(Divider(
        height: 20.0,
      ));
    }

    return requirementsWidgets;
  }
}
