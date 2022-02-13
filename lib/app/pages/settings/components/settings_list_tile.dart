import 'package:dazle/app/utils/app.dart';
import 'package:dazle/app/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class SettingsListTile extends StatelessWidget {
  final String text;
  final Function? onTap;


  SettingsListTile({
    required this.text,
    this.onTap
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: App.hintColor,
            width: 0.3,
          )
        )
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
        title: CustomText(
          text: text,
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
        onTap: onTap as void Function()?,
      ),
    );
  }
}