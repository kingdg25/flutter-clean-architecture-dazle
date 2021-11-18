import 'package:dazle/app/widgets/form_fields/custom_email_field.dart';
import 'package:dazle/app/widgets/form_fields/custom_field_layout.dart';
import 'package:dazle/app/widgets/form_fields/custom_icon_button.dart';
import 'package:dazle/app/widgets/form_fields/custom_password_field.dart';
import 'package:dazle/app/widgets/form_fields/custom_select_field.dart';
import 'package:dazle/app/widgets/form_fields/custom_text_field.dart';
import 'package:dazle/app/widgets/form_fields/title_field.dart';
import 'package:dazle/app/pages/register/components/register_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:dazle/app/pages/register/register_controller.dart';
import 'package:dazle/data/repositories/data_authentication_repository.dart';
import 'package:dazle/app/widgets/custom_appbar.dart';



class RegisterPage extends View {
  static const String id = 'register_page';

  RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}


class _RegisterPageState extends ViewState<RegisterPage, RegisterController> {
  _RegisterPageState() : super(RegisterController(DataAuthenticationRepository()));

  @override
  Widget get view {
    return Scaffold(
      key: globalKey,
      appBar: CustomAppBar(
        title: 'Create an Account',
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: ControlledWidgetBuilder<RegisterController>(
        builder: (context, controller) {
          var _pageController = controller.registerPageController;
          var _formKey1 = controller.registerFormKeyPage1;
          var _formKey2 = controller.registerFormKeyPage2;

          Size size = MediaQuery.of(context).size;
          double page1Height = 0.0;

          if (size.height <= 569){
            page1Height = size.height + 250;
          }
          else if (size.height <= 740){
            page1Height = size.height + 200;
          }
          else {
            page1Height = size.height + 120;
          }

          var page1 = SingleChildScrollView(
            child: RegisterLayout(
              height: page1Height,
              svgAsset: 'assets/create_account.svg',
              child: Form(
                key: _formKey1,
                child: Column(
                  children: [
                    TitleField(
                      title: 'Enter Full Name'
                    ),
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
                      )
                    ),
                    TitleField(
                      title: 'Enter Mobile Number'
                    ),
                    CustomTextField(
                      controller: controller.mobileNumberTextController,
                      hintText: '+63',
                      isRequired: true,
                      keyboardType: TextInputType.phone,
                    ),
                    TitleField(
                      title: 'I am a Real Estate ..'
                    ),
                    CustomSelectField(
                      hintText: 'I am a Real Estate ..',
                      isRequired: true, 
                      value: controller.position,
                      items: ['Broker', 'Salesperson'],
                      onChanged: controller.setPosition,
                    ),
                    TitleField(
                      title: controller.licenseNumberTextField
                    ),
                    CustomTextField(
                      controller: controller.licenseNumberTextController,
                      hintText: controller.licenseNumberTextField,
                      isRequired: true,
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 20.0),
                    CustomIconButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();

                        if (_formKey1.currentState.validate()) {
                          _formKey1.currentState.save();

                          _pageController.nextPage(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.ease
                          );
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
          );

          var page2 = SingleChildScrollView(
            child: RegisterLayout(
              height: size.height,
              svgAsset: 'assets/create_account_2.svg', 
              child: Form(
                key: _formKey2,
                child: Column(
                  children: [
                    TitleField(
                      title: 'Email Address'
                    ),
                    CustomEmailField(
                      controller: controller.emailTextController,
                      hintText: 'Email Address'
                    ),
                    TitleField(
                      title: 'Password'
                    ),
                    CustomPasswordField(
                      controller: controller.passwordTextController,
                      hintText: 'Password',
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomIconButton(
                          alignment: null,
                          main: false,
                          onPressed: () {
                            FocusScope.of(context).unfocus();

                            _pageController.previousPage(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.ease
                            );
                          },
                        ),
                        CustomIconButton(
                          alignment: null,
                          onPressed: () {
                            FocusScope.of(context).unfocus();

                            if (_formKey2.currentState.validate()) {
                              _formKey2.currentState.save();

                              controller.register();
                            }
                          },
                        )
                      ],
                    )
                  ],
                ),
              )
            )
          );

          return PageView(
            physics: NeverScrollableScrollPhysics(),
            controller: _pageController,
            children: [
              page1,
              page2
            ],
          );
        }
      )
    );
  }
  
}