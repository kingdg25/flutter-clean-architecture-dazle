import 'package:dazle/app/pages/edit_profile/edit_profile_controller.dart';
import 'package:dazle/app/utils/app.dart';
import 'package:dazle/app/widgets/custom_appbar.dart';
import 'package:dazle/app/widgets/form_fields/custom_button.dart';
import 'package:dazle/app/widgets/form_fields/custom_field_layout.dart';
import 'package:dazle/app/widgets/form_fields/custom_text_field.dart';
import 'package:dazle/app/widgets/form_fields/title_field.dart';
import 'package:dazle/data/repositories/data_profile_repository.dart';
import 'package:dazle/domain/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';



class EditProfilePage extends View {
  final User user;

  EditProfilePage({
    Key key,
    this.user
  }) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}


class _EditProfilePageState extends ViewState<EditProfilePage, EditProfileController> {
  _EditProfilePageState() : super(EditProfileController(DataProfileRepository()));

  @override
  Widget get view {
    return Scaffold(
      key: globalKey,
      appBar: CustomAppBar(
        title: 'Edit Profile',
      ),
      backgroundColor: Colors.white,
      body: ControlledWidgetBuilder<EditProfileController>(
        builder: (context, controller) {
          var _formKey = controller.editProfileFormKey;

          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 40),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Center(
                      child: Image(
                        image: AssetImage('assets/user_profile.png'),
                        width: 200,
                        height: 200,
                      ),
                    ),
                    TitleField(
                      title: 'Full Name'
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
                      title: 'Mobile Number'
                    ),
                    CustomTextField(
                      controller: controller.mobileNumberTextController,
                      hintText: '+63',
                      isRequired: true,
                      keyboardType: TextInputType.phone,
                    ),
                    TitleField(
                      title: 'About Me'
                    ),
                    CustomTextField(
                      controller: controller.aboutMeTextController,
                      hintText: 'About Me',
                      isRequired: true,
                      keyboardType: TextInputType.multiline,
                      minLines: 4,
                      maxLines: null,
                    ),
                    SizedBox(height: 30.0),
                    CustomButton(
                      text: 'Save Profile',
                      expanded: true,
                      onPressed: () {
                        FocusScope.of(context).unfocus();

                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          
                          controller.updateUser();
                        }
                      }
                    ),
                    SizedBox(height: 30.0),
                    CustomFieldLayout(
                      child: Divider(
                        color: App.hintColor,
                      ),
                    ),
                    SizedBox(height: 30.0),
                    TitleField(
                      title: 'Email Address'
                    ),
                    CustomTextField(
                      controller: controller.emailTextController,
                      hintText: '+63',
                      readOnly: true,
                    ),
                    TitleField(
                      title: 'Profession'
                    ),
                    CustomTextField(
                      controller: controller.professionTextController,
                      hintText: 'Profession',
                      readOnly: true,
                    ),
                    TitleField(
                      title: 'Broker License #'
                    ),
                    CustomTextField(
                      controller: controller.brokerLicenseNumberTextController,
                      hintText: 'Broker License #',
                      readOnly: true,
                      keyboardType: TextInputType.number,
                    )
                  ]
                ),
              )
            )
          );
        
        }
      )
    );
  }
}