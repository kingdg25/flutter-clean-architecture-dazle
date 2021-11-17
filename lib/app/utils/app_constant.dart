import 'package:dazle/app/widgets/custom_text.dart';
import 'package:flutter/material.dart';


class AppConstant{
  
  static statusDialog(BuildContext context,bool success, String text){
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0)
          ),
          title: CustomText(
            text: success ? 'Success!' : 'Failed!',
            fontSize: 18.0,
          ),
          content: CustomText(
            text: text ?? ( success ? 'success' : 'failed' ),
            fontSize: 13.0,
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.pop(context);
              }
            ),
          ],
        );
      },
    );
  }

}