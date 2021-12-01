import 'package:dazle/app/utils/app.dart';
import 'package:dazle/app/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class HeaderListTile extends StatelessWidget {
  final String text;
  final Function onTap;


  HeaderListTile({
    @required this.text,
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
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
        title: CustomText(
          text: text,
          color: Color.fromRGBO(0, 191, 166, 1.0),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_sharp,
          size: 22,
          color: App.textColor,
        ),
        onTap: onTap,
      ),
    );
  }
}