import 'package:dazle/app/pages/delete_account/delete_account_controller.dart';
import 'package:dazle/app/utils/app_constant.dart';
import 'package:dazle/app/widgets/custom_text.dart';
import 'package:dazle/app/widgets/form_fields/custom_button.dart';
import 'package:dazle/app/widgets/form_fields/custom_field_layout.dart';
import 'package:dazle/app/widgets/form_fields/custom_password_field.dart';
import 'package:dazle/app/widgets/form_fields/title_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class VerifyPassword extends StatelessWidget {
  const VerifyPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DeleteAccountController controller =
        FlutterCleanArchitecture.getController<DeleteAccountController>(
            context);
    var _formKey = controller.verifyPasswordFormKey;

    return SingleChildScrollView(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).orientation == Orientation.landscape
                ? 80.0
                : 20.0,
            bottom: 40.0,
            left: 40.0,
            right: 40.0),
        child: Container(
            constraints: BoxConstraints(maxWidth: 300, minWidth: 250),
            child: Form(
              key: _formKey,
              child: Column(children: [
                Container(
                  child: Image(image: AssetImage('assets/reset_password.png')),
                ),
                CustomFieldLayout(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: 200.0,
                      child: CustomText(
                        text:
                            'Enter your password to ${controller.action} your account.',
                        fontSize: 30.0,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                // TitleField(title: 'Enter password'),
                CustomPasswordField(
                  controller: controller.verifyPasswordTextController,
                  hintText: 'Enter Password',
                ),
                SizedBox(height: 20.0),
                CustomButton(
                  text: 'Submit',
                  expanded: true,
                  onPressed: () {
                    FocusScope.of(context).unfocus();

                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      AppConstant.showLoader(context, true);
                      controller.verifypassword(
                          email: controller.currentUser?.email,
                          password:
                              controller.verifyPasswordTextController.text);
                    }
                  },
                )
              ]),
            )));
  }
}
