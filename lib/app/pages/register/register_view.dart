import 'package:dwellu/app/widgets/form_fields/custom_button.dart';
import 'package:dwellu/app/widgets/form_fields/custom_field_layout.dart';
import 'package:dwellu/app/widgets/form_fields/custom_icon_button.dart';
import 'package:dwellu/app/widgets/form_fields/custom_password_field.dart';
import 'package:dwellu/app/widgets/form_fields/custom_select_field.dart';
import 'package:dwellu/app/widgets/form_fields/custom_text_field.dart';
import 'package:dwellu/app/widgets/form_fields/title_field.dart';
import 'package:dwellu/app/pages/register/components/register_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:dwellu/app/pages/register/register_controller.dart';
import 'package:dwellu/data/repositories/data_authentication_repository.dart';
import 'package:dwellu/app/widgets/custom_appbar.dart';



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
          var _formKey = controller.registerFormKey;
          var _pageController = controller.registerPageController;

          var page1 = SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 50.0),
            child: RegisterLayout(
              svgAsset: 'assets/create_account.svg',
              child: Form(
                key: _formKey,
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
                            ),
                          ),
                          SizedBox(width: 8.0),
                          Flexible(
                            child: CustomTextField(
                              controller: controller.lastNameTextController,
                              hintText: 'Last Name',
                            ),
                          ),
                        ],
                      )
                    ),
                    TitleField(
                      title: 'Enter Mobile Number'
                    ),
                    CustomTextField(
                      hintText: '+63',
                    ),
                    TitleField(
                      title: 'I am a'
                    ),
                    CustomSelectField(
                      hintText: 'I am a',
                      isRequired: true, 
                      value: null,
                      items: ['Real Estate Broker', 'Real Estate Salesperson'],
                      onChanged: (val) {
                        print(val);
                      },
                    ),
                    TitleField(
                      title: 'Enter your License #'
                    ),
                    CustomTextField(
                      hintText: 'Enter your License #',
                    ),
                    SizedBox(height: 20.0),
                    CustomIconButton(
                      onPressed: () {
                        _pageController.nextPage(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.ease
                        );
                      },
                    )
                  ],
                ),
              ),
            )
          );

          var page2 = SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 50.0),
            child: RegisterLayout(
              svgAsset: 'assets/create_account_2.svg', 
              child: Form(
                child: Column(
                  children: [
                    TitleField(
                      title: 'Email Address'
                    ),
                    CustomTextField(
                      // controller: controller.emailTextController,
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
                    TitleField(
                      title: 'Password'
                    ),
                    CustomPasswordField(
                      hintText: 'Password',
                    ),
                    SizedBox(height: 20.0),
                    CustomButton(
                      text: 'Submit',
                      expanded: true,
                      onPressed: () {
                      },
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