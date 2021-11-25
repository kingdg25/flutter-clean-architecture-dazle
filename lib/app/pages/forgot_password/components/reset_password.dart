import 'package:dazle/app/pages/forgot_password/forgot_password_controller.dart';
import 'package:dazle/app/widgets/custom_text.dart';
import 'package:dazle/app/widgets/form_fields/custom_button.dart';
import 'package:dazle/app/widgets/form_fields/custom_field_layout.dart';
import 'package:dazle/app/widgets/form_fields/custom_password_field.dart';
import 'package:dazle/app/widgets/form_fields/title_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ForgotPasswordController controller = FlutterCleanArchitecture.getController<ForgotPasswordController>(context);
    var _formKey = controller.resetPasswordFormKey;

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
                  image: AssetImage('assets/reset_password.png')
                ),
              ),
              CustomFieldLayout(
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: 200.0,
                    child: CustomText(
                      text: 'Reset Password',
                      fontSize: 30.0,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              TitleField(
                title: 'New Password'
              ),
              CustomPasswordField(
                controller: controller.resetPasswordTextController,
                hintText: 'New Password',
              ),
              SizedBox(height: 20.0),
              CustomButton(
                text: 'Submit',
                expanded: true,
                onPressed: () {
                  FocusScope.of(context).unfocus();

                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    
                    controller.resetPassword();
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