import 'package:dazle/app/widgets/custom_text.dart';
import 'package:dazle/app/widgets/form_fields/custom_button.dart';
import 'package:dazle/app/widgets/form_fields/custom_field_layout.dart';
import 'package:flutter/material.dart';



class SendRequestScreen extends StatelessWidget {

  const SendRequestScreen({ Key key }) : super(key: key);

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
                    image: AssetImage('assets/send_request.png')
                  ),
                ),
                SizedBox(height: 30.0),
                CustomFieldLayout(
                  child: CustomText(
                    text: "An invite has been sent to your Broker. Your account status is currently pending.\n\nMake sure your Broker logs on to Brooky to change your status to Verified.\n\nIn the meantime, enjoy using the Brooky app!",
                    fontSize: 14.0,
                    fontWeight: FontWeight.w300,
                    textAlign: TextAlign.justify,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(height: 50.0),
                CustomButton(
                  text: 'Continue',
                  expanded: true,
                  onPressed: () {
                    Navigator.pop(context);
                  }
                )
              ]
            )
          )
        ),
      )
    );
  }
}