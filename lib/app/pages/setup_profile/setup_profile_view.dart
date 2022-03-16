import 'package:dazle/app/pages/setup_profile/setup_profile_controller.dart';
import 'package:dazle/app/widgets/custom_appbar.dart';
import 'package:dazle/app/widgets/custom_form_layout.dart';
import 'package:dazle/app/widgets/form_fields/custom_button.dart';
import 'package:dazle/app/widgets/form_fields/custom_field_layout.dart';
import 'package:dazle/app/widgets/form_fields/custom_select_field.dart';
import 'package:dazle/app/widgets/form_fields/custom_text_field.dart';
import 'package:dazle/app/widgets/form_fields/title_field.dart';
import 'package:dazle/data/repositories/data_authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class SetupProfilePage extends View {
  static const String id = 'setup_profile_page';

  SetupProfilePage({Key? key}) : super(key: key);

  @override
  _SetupProfilePageState createState() => _SetupProfilePageState();
}

class _SetupProfilePageState
    extends ViewState<SetupProfilePage, SetupProfileController> {
  _SetupProfilePageState()
      : super(SetupProfileController(DataAuthenticationRepository()));

  @override
  Widget get view {
    return Scaffold(
        key: globalKey,
        appBar: CustomAppBar(
          title: 'Setup Profile',
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        backgroundColor: Colors.white,
        body: ControlledWidgetBuilder<SetupProfileController>(
            builder: (context, controller) {
          var _formKey = controller.setupProfileFormKey;

          return Center(
            child: SingleChildScrollView(
                child: Column(children: [
              Container(
                child: Image(
                  image: AssetImage('assets/user_profile.png'),
                  width: 200,
                  height: 200,
                ),
              ),
              CustomFormLayout(
                  margin:
                      EdgeInsets.only(left: 43.0, right: 43.0, bottom: 40.0),
                  formKey: _formKey,
                  child: Column(
                    children: [
                      TitleField(title: 'Enter Full Name'),
                      CustomFieldLayout(
                          child: Row(
                        children: [
                          Flexible(
                            child: CustomTextField(
                              controller: controller.firstNameTextController,
                              hintText: 'First Name',
                              isRequired: true,
                              textCapitalization: TextCapitalization.sentences,
                            ),
                          ),
                          SizedBox(width: 8.0),
                          Flexible(
                            child: CustomTextField(
                              controller: controller.lastNameTextController,
                              hintText: 'Last Name',
                              isRequired: true,
                              textCapitalization: TextCapitalization.sentences,
                            ),
                          ),
                        ],
                      )),
                      CustomFieldLayout(
                        child: TitleField(title: 'Mobile Number'),
                      ),
                      CustomFieldLayout(
                        child: InternationalPhoneNumberInput(
                          textFieldController:
                              controller.mobileNumberTextController,
                          initialValue: PhoneNumber(
                            isoCode: 'PH',
                            phoneNumber:
                                controller.mobileNumberTextController.text,
                          ),
                          selectorConfig: SelectorConfig(
                            selectorType: PhoneInputSelectorType.DIALOG,
                          ),
                          inputBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          onInputChanged: (number) {
                            print(number.phoneNumber);
                          },
                          onSaved: (number) {
                            print('On Saved: $number');
                          },
                          keyboardType: TextInputType.numberWithOptions(
                            signed: true,
                            decimal: true,
                          ),
                        ),
                      ),
                      TitleField(title: 'I am a Real Estate ..'),
                      CustomSelectField(
                        hintText: 'I am a Real Estate ..',
                        isRequired: true,
                        value: controller.position,
                        items: ['Broker', 'Salesperson'],
                        onChanged: controller.setPosition,
                      ),
                      TitleField(
                          title: controller.brokerLicenseNumberTextField),
                      CustomTextField(
                        controller:
                            controller.brokerLicenseNumberTextController,
                        hintText: controller.brokerLicenseNumberTextField,
                        isRequired: true,
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 20.0),
                      CustomButton(
                          text: 'Confirm',
                          expanded: true,
                          onPressed: () {
                            FocusScope.of(context).unfocus();

                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();

                              controller.setupProfile();
                            }
                          })
                    ],
                  ))
            ])),
          );
        }));
  }
}
