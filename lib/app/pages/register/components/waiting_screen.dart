import 'package:dazle/app/utils/app.dart';
import 'package:dazle/app/widgets/custom_text.dart';
import 'package:dazle/app/widgets/form_fields/custom_field_layout.dart';
import 'package:dazle/app/widgets/form_fields/custom_flat_button.dart';
import 'package:flutter/material.dart';



class WaitingScreen extends StatelessWidget {
  final String firstName;

  const WaitingScreen({
    Key key,
    @required this.firstName
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).orientation == Orientation.landscape ? 80.0 : 20.0,
            bottom: 40.0,
            left: 40.0,
            right: 40.0
          ),
          child: Container(
            constraints: BoxConstraints(maxWidth: 300, minWidth: 250),
            child: Column(
              children: [
                Container(
                  child: Image(
                    image: AssetImage('assets/waiting.png')
                  ),
                ),
                SizedBox(height: 30.0),
                CustomFieldLayout(
                  child: CustomText(
                    text: 'Hello $firstName, we have reserved a spot for you. We will text you as soon as your account is ready!',
                    fontSize: 19.0,
                    fontWeight: FontWeight.w500,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 10.0),
                CustomFieldLayout(
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          text: 'Got your invite text? ',
                          fontSize: 13.0,
                        ),
                        CustomFlatButton(
                          text: 'Sign in here',
                          fontSize: 13.0,
                          color: App.mainColor,
                          padding: EdgeInsets.all(0),
                          onPressed: () {
                            Navigator.pop(context);
                          }
                        )
                      ],
                    ),
                  ),
                )
              ]
            )
          )
        ),
      )
    );
  }
}