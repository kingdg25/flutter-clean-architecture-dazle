import 'package:dazle/app/widgets/custom_text.dart';
import 'package:dazle/app/widgets/form_fields/custom_button.dart';
import 'package:flutter/material.dart';


class AppConstant{
  
  static statusDialog({
    BuildContext context,
    bool success = false,
    String title,
    String text,
    Function onPressed
  }){
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0)
          ),
          actionsPadding: EdgeInsets.all(20.0),
          title: CustomText(
            text: title ?? ( success ? 'Success!' : 'Failed!' ),
            fontSize: 18.0,
            textAlign: TextAlign.center,
          ),
          content: CustomText(
            text: text ?? ( success ? 'success' : 'failed' ),
            fontSize: 13.0,
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            CustomButton(
              text: 'OK',
              expanded: true,
              borderRadius: 20.0,
              onPressed: (onPressed != null) ? onPressed : () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

}