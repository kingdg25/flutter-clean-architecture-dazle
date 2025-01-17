import 'package:dazle/app/pages/delete_account/delete_account_controller.dart';

import 'package:dazle/app/utils/app.dart';
import 'package:dazle/app/utils/app_constant.dart';
import 'package:dazle/app/widgets/custom_text.dart';
import 'package:dazle/app/widgets/form_fields/custom_field_layout.dart';
import 'package:dazle/app/widgets/form_fields/custom_flat_button.dart';
import 'package:dazle/app/widgets/form_fields/custom_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerifyDeleteAccountCode extends StatelessWidget {
  const VerifyDeleteAccountCode({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Declaring Controller
    DeleteAccountController controller =
        FlutterCleanArchitecture.getController<DeleteAccountController>(
            context);
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
            child: Column(children: [
              Container(
                child: Image(image: AssetImage('assets/verification_code.png')),
              ),
              CustomFieldLayout(
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: 200.0,
                    child: CustomText(
                      text: 'Enter Code',
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
                    text:
                        '4 digit code has been sent to ${controller.currentUser?.email}',
                    fontSize: 13.0,
                    color: App.hintColor,
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              CustomFieldLayout(
                child: PinCodeTextField(
                    appContext: context,
                    length: 4,
                    obscureText: false,
                    animationType: AnimationType.fade,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 55,
                      fieldWidth: 55,
                      activeFillColor: Colors.white,
                      activeColor: App.mainColor,
                      inactiveColor: Color.fromRGBO(232, 227, 227, 1.0),
                      inactiveFillColor: Color.fromRGBO(232, 227, 227, 1.0),
                      selectedColor: Color.fromRGBO(232, 227, 227, 1.0),
                      selectedFillColor: Color.fromRGBO(232, 227, 227, 1.0),
                    ),
                    animationDuration: Duration(milliseconds: 300),
                    enableActiveFill: true,
                    errorAnimationController:
                        controller.verificationCodeErrorController,
                    controller: controller.verificationCodeTextController,
                    onChanged: (value) {
                      print(value);
                    }),
              ),
              CustomFieldLayout(
                child: Container(
                  child: Row(
                    children: [
                      CustomText(
                        text: 'Did’t get the code?',
                        fontSize: 11.0,
                      ),
                      CustomFlatButton(
                          text: 'Tap here to send',
                          fontSize: 11.0,
                          color: App.mainColor,
                          padding: EdgeInsets.all(0),
                          onPressed: () {
                            print('Tap here to send');
                            controller.sendDeleteAccountCode(
                                email: controller.currentUser!.email!,
                                resend: true);
                          })
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30.0),
              CustomIconButton(
                onPressed: () {
                  AppConstant.showLoader(context, true);
                  controller.verifyCode();
                },
              )
            ])));
  }
}
