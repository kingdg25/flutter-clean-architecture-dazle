import 'package:flutter/material.dart';




statusDialog(BuildContext context,bool success, String text){
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0)),
        title: Text(success ? 'Success!' : 'Failed!', style: TextStyle(fontSize: 15.0)),
        content: Text(text ?? ( success ? 'success' : 'failed' ), style: TextStyle(fontSize: 15.0)),
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