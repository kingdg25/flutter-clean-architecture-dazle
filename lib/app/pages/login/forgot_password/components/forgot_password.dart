import 'package:dwellu/app/pages/login/login_controller.dart';
import 'package:dwellu/app/widgets/custom_text.dart';
import 'package:dwellu/app/widgets/form_fields/custom_field_layout.dart';
import 'package:dwellu/app/widgets/form_fields/custom_icon_button.dart';
import 'package:dwellu/app/widgets/form_fields/custom_text_field.dart';
import 'package:dwellu/app/widgets/form_fields/title_field.dart';
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
                      overflow: TextOverflow.clip,
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
                    overflow: TextOverflow.clip,
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              TitleField(
                title: 'Email Address'
              ),
              CustomTextField(
                controller: controller.forgotEmailTextController,
                keyboardType: TextInputType.emailAddress,
                hintText: 'Email Address',
                validator: (value) {
                  Pattern emailPattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                  RegExp regex = new RegExp(emailPattern);
                  if (!regex.hasMatch(value)){
                    return 'Enter Valid Email';
                  }
                  return null;
                },
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