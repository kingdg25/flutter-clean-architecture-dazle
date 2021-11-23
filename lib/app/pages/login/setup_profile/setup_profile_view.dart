import 'package:dazle/app/pages/login/setup_profile/setup_profile_controller.dart';
import 'package:dazle/app/widgets/custom_appbar.dart';
import 'package:dazle/app/widgets/form_fields/custom_button.dart';
import 'package:dazle/app/widgets/form_fields/custom_field_layout.dart';
import 'package:dazle/app/widgets/form_fields/custom_select_field.dart';
import 'package:dazle/app/widgets/form_fields/custom_text_field.dart';
import 'package:dazle/app/widgets/form_fields/title_field.dart';
import 'package:dazle/data/repositories/data_authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';



class SetupProfilePage extends View {
  static const String id = 'setup_profile_page';
  
  SetupProfilePage({ Key key }) : super(key: key);

  @override
  _SetupProfilePageState createState() => _SetupProfilePageState();
}

class _SetupProfilePageState extends ViewState<SetupProfilePage, SetupProfileController> {
  _SetupProfilePageState() : super(SetupProfileController(DataAuthenticationRepository()));

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
              child: Column(
                children: [
                  Container(
                    child: Image(
                      image: AssetImage('assets/profile.png'),
                      width: 200,
                      height: 200,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 43.0, right: 43.0, bottom: 40.0),
                    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 4),
                          blurRadius: 5,
                          color: Color.fromRGBO(0, 0, 0, 0.25)
                        )
                      ]
                    ),
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
                          CustomButton(
                            text: 'Confirm',
                            expanded: true,
                            onPressed: () {
                              FocusScope.of(context).unfocus();

                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();
                                
                                controller.updateProfile();
                              }
                            }
                          )
                        ],
                      ),
                    )
                  )
                ]
              )
            ),
          );
        
        }
      )
    );
  }
}