import 'package:dazle/app/pages/login/login_controller.dart';
import 'package:dazle/app/widgets/custom_text.dart';
import 'package:dazle/app/widgets/form_fields/custom_email_field.dart';
import 'package:dazle/app/widgets/form_fields/custom_field_layout.dart';
import 'package:dazle/app/widgets/form_fields/custom_icon_button.dart';
import 'package:dazle/app/widgets/form_fields/title_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LoginController controller = FlutterCleanArchitecture.getController<LoginController>(context);
    var _formKey = controller.forgotPasswordFormKey;

    return SingleChildScrollView(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).orientation == Orientation.landscape ? 80.0 : 20.0,
        bottom: 40.0,
        left: 40.0,
        right: 40.0
      ),
      child: Container(
        constraints: BoxConstraints(maxWidth: 300, minWidth: 250),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                child: Image(
                  image: AssetImage('assets/forgot_password.png')
                ),
              ),
              CustomFieldLayout(
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: 200.0,
                    child: CustomText(
                      text: 'Forgot Password?',
                      fontSize: 30.0,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                    ),
                  ),
                ),
              ),
              CustomFieldLayout(
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: CustomText(
                    text: 'Please enter your email address that is associated with your account',
                    fontSize: 13.0,
                    color: Color.fromRGBO(154, 160, 166, 1.0),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              TitleField(
                title: 'Email Address'
              ),
              CustomEmailField(
                controller: controller.forgotPasswordEmailTextController,
                hintText: 'Email Address'
              ),
              SizedBox(height: 20.0),
              CustomIconButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();

                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    
                    controller.forgotPassword();
                  }
                },
              )
            ]
          ),
        )
      )
    );
  }
}