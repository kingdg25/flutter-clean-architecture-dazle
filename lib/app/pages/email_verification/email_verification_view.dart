import 'package:dazle/app/pages/email_verification/email_verification_controller.dart';
import 'package:dazle/app/pages/login/login_view.dart';
import 'package:dazle/app/utils/app.dart';
import 'package:dazle/app/widgets/custom_text.dart';
import 'package:dazle/app/widgets/form_fields/custom_button.dart';
import 'package:dazle/app/widgets/form_fields/custom_field_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class EmailVerificationPage extends View {
  @override
  _EmailVerificationPage createState() => _EmailVerificationPage();
}

class _EmailVerificationPage extends ViewState {
  _EmailVerificationPage() : super(EmailVerificationPageController());

  @override
  Widget get view {
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
                    text: "A link has been sent to your email for verification. After you verify your email, click the confirm button below.",
                    fontSize: 14.0,
                    fontWeight: FontWeight.w300,
                    textAlign: TextAlign.justify,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(height: 50.0),
                CustomButton(
                  text: 'Confirm Email',
                  expanded: true,
                  onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
                    (Route<dynamic> route) => false);
                  }
                ),
                SizedBox(height: 15.0),
                CustomButton(
                  text: 'Log out',
                  expanded: true,
                  onPressed: () async {
                    await App.logOutUser();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
                      (Route<dynamic> route) => false);
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