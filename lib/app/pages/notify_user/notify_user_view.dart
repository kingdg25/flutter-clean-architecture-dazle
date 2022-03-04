import 'package:dazle/app/pages/notify_user/notify_user_controller.dart';
import 'package:dazle/app/utils/app.dart';
import 'package:dazle/app/widgets/custom_appbar.dart';
import 'package:dazle/app/widgets/custom_form_layout.dart';
import 'package:dazle/app/widgets/custom_text.dart';
import 'package:dazle/app/widgets/form_fields/custom_button.dart';
import 'package:dazle/app/widgets/form_fields/custom_email_field.dart';
import 'package:dazle/app/widgets/form_fields/custom_text_field.dart';
import 'package:dazle/app/widgets/form_fields/title_field.dart';
import 'package:dazle/data/repositories/data_connection_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class NotifyUserPage extends View {
  NotifyUserPage({Key? key}) : super(key: key);

  @override
  _NotifyUserPageState createState() => _NotifyUserPageState();
}

class _NotifyUserPageState
    extends ViewState<NotifyUserPage, NotifyUserController> {
  _NotifyUserPageState()
      : super(NotifyUserController(DataConnectionRepository()));

  @override
  Widget get view {
    return Scaffold(
        key: globalKey,
        appBar: CustomAppBar(
          title: 'Notify Agent',
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: ControlledWidgetBuilder<NotifyUserController>(
            builder: (context, controller) {
          var _formKey = controller.notifyUserFormKey;

          return Center(
            child: SingleChildScrollView(
                child: Column(
              children: [
                Container(
                  height: 110,
                  width: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromRGBO(221, 99, 110, 0.5),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline,
                          size: 26, color: Color.fromRGBO(226, 87, 76, 1.0)),
                      SizedBox(width: 5),
                      Flexible(
                          child: CustomText(
                        text:
                            'Oops! It seems your Broker is not yet with ${App.name}. Invite your Broker to complete your registration!',
                        fontSize: 15,
                        textAlign: TextAlign.justify,
                      ))
                    ],
                  ),
                ),
                SizedBox(height: 30),
                CustomFormLayout(
                    margin:
                        EdgeInsets.only(left: 43.0, right: 43.0, bottom: 40.0),
                    formKey: _formKey,
                    child: Column(
                      children: [
                        TitleField(title: 'Email Address'),
                        CustomEmailField(
                            controller: controller.emailTextController,
                            hintText: 'Email Address'),
                        TitleField(title: 'Enter Mobile Number'),
                        InternationalPhoneNumberInput(
                          initialValue: PhoneNumber(isoCode: 'PH'),
                          inputBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          selectorConfig: SelectorConfig(
                              selectorType: PhoneInputSelectorType.DIALOG),
                          onInputChanged: (PhoneNumber number) {
                            controller.mobileNumberTextController.text =
                                number.phoneNumber.toString();
                            print(controller.mobileNumberTextController.text);
                          },
                        ),
                        SizedBox(height: 20.0),
                        CustomButton(
                            text: 'Notify Agent',
                            expanded: true,
                            onPressed: () {
                              FocusScope.of(context).unfocus();

                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();

                                controller.notifyUser();
                              }
                            })
                      ],
                    )),
              ],
            )),
          );
        }));
  }
}
