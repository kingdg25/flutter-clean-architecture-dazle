import 'package:dazle/app/pages/email_verification/email_verification_controller.dart';
import 'package:dazle/app/pages/login/login_view.dart';
import 'package:dazle/app/utils/app.dart';
import 'package:dazle/app/widgets/custom_text.dart';
import 'package:dazle/app/widgets/form_fields/custom_button.dart';
import 'package:dazle/app/widgets/form_fields/custom_field_layout.dart';
import 'package:dazle/app/widgets/form_fields/custom_flat_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class EmailVerificationPage extends View {

  EmailVerificationPage({Key key}) : super(key: key);

  @override
  _EmailVerificationPage createState() => _EmailVerificationPage();
}

class _EmailVerificationPage extends ViewState<EmailVerificationPage, EmailVerificationPageController> {
  _EmailVerificationPage() : super(EmailVerificationPageController());

  @override
  Widget get view {
    return Scaffold(
      key: globalKey,
      backgroundColor: Colors.white,
      body: ControlledWidgetBuilder<EmailVerificationPageController>(
        builder: (context, controller) {
          return Center(
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
                        text: "A link has been sent to your email for verification. Once you verify your email, click the confirm button below.",
                        fontSize: 14.0,
                        fontWeight: FontWeight.w300,
                        textAlign: TextAlign.justify,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    SizedBox(height: 30.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Flexible(
                          child: CustomText(
                            text: "Didn't get an email verification?",
                            // color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.italic,
                          )
                        ),
                        CustomFlatButton(
                          text: 'Click here',
                          color: Color.fromRGBO(0, 126, 203, 1.0),
                          fontWeight: FontWeight.w500,
                          onPressed: () {
                            controller.resendEmailVerification();
                          },
                        )
                      ]
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
          );
      })
    );
  }
}