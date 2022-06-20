import 'dart:io';

import 'package:dazle/app/widgets/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../../data/repositories/data_profile_repository.dart';
import '../../../domain/entities/user.dart';
import '../../utils/app.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/form_fields/custom_button.dart';
import '../../widgets/form_fields/custom_field_layout.dart';
import '../../widgets/form_fields/custom_text_field.dart';
import '../../widgets/form_fields/title_field.dart';
import 'edit_profile_controller.dart';

class EditProfilePage extends View {
  final User? user;

  EditProfilePage({Key? key, this.user}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState
    extends ViewState<EditProfilePage, EditProfileController> {
  _EditProfilePageState()
      : super(EditProfileController(DataProfileRepository()));

  // ===== declarations temp
  var _loadImage = AssetImage('assets/user_profile.png');
  var _space = SizedBox(height: 30.0);
  var _custom = CustomFieldLayout(
    child: Divider(
      color: App.hintColor,
    ),
  );

  File? _profilePicture;
  final picker = ImagePicker();

  /// Take a photo
  Future takePicture() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _profilePicture = File(pickedFile.path);
        print(_profilePicture!.path);
      } else {
        print('No image selected.');
      }
    });
  }

  /// Upload from device
  Future uploadFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _profilePicture = File(pickedFile.path);
        print(_profilePicture!.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget get view {
    return Scaffold(
      key: globalKey,
      appBar: CustomAppBar(
        title: 'Edit Profile',
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 20, right: 20, bottom: 40, top: 20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //================================================== Profile pic
                ControlledWidgetBuilder<EditProfileController>(
                  builder: (context, controller) {
                    return Stack(
                      children: [
                        CircleAvatar(
                          radius: 95,
                          backgroundImage: controller.userProfilePicture !=
                                      null &&
                                  _profilePicture == null
                              ? NetworkImage(controller.userProfilePicture!)
                              : (_profilePicture == null
                                      ? AssetImage('assets/user_profile.png')
                                      : FileImage(_profilePicture!))
                                  as ImageProvider<Object>,
                          backgroundColor: App.mainColor,
                        ),
                        Positioned(
                          right: 0,
                          bottom: 1,
                          child: CircleAvatar(
                              backgroundColor: Colors.grey[200],
                              radius: 25,
                              child: IconButton(
                                icon: Icon(
                                  Icons.camera_alt_rounded,
                                  color: App.mainColor,
                                  size: 30,
                                ),
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: ((builder) => bottomSheet()),
                                  );
                                },
                              )),
                        )
                      ],
                    );
                  },
                ),

                // //=================================================== Upload img
                // ControlledWidgetBuilder<EditProfileController>(
                //   builder: (context, controller) {
                //     return CircleAvatar(
                //       backgroundColor: Colors.grey[200],
                //       radius: 25,
                //       child: IconButton(
                //         icon: Icon(
                //           Icons.camera_alt_rounded,
                //           color: App.mainColor,
                //           size: 30,
                //         ),
                //         onPressed: () {
                //           showModalBottomSheet(
                //             context: context,
                //             builder: ((builder) => bottomSheet()),
                //           );
                //         },
                //       ),
                //     );
                //   },
                // ),
                //====================================================== details
                ControlledWidgetBuilder<EditProfileController>(
                  builder: (context, controller) {
                    var _formKey = controller.editProfileFormKey;
                    return Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          //---full name [start]
                          CustomFieldLayout(
                            child: TitleField(title: 'Full Name'),
                          ),
                          CustomFieldLayout(
                            child: Row(
                              children: [
                                Flexible(
                                  child: CustomTextField(
                                    controller:
                                        controller.firstNameTextController,
                                    hintText: 'First Name',
                                    validator: (val) {
                                      final namePattern = r'^[a-zA-Z_ ]*$';
                                      final regExp = RegExp(namePattern);

                                      if (val.length == 0) {
                                        return "Required field.";
                                      }
                                      if (!regExp.hasMatch(val)) {
                                        return "Letters only";
                                      }
                                      if (val.length < 2) {
                                        return "Min 2 Letters";
                                      }
                                      if (val.length >= 50) {
                                        return "Max 50 Letters";
                                      }
                                      return null;
                                    },
                                    isRequired: true,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                  ),
                                ),
                                SizedBox(width: 8.0),
                                Flexible(
                                  child: CustomTextField(
                                    controller:
                                        controller.lastNameTextController,
                                    validator: (val) {
                                      final namePattern = r'^[a-zA-Z_ ]*$';
                                      final regExp = RegExp(namePattern);

                                      if (val.length == 0) {
                                        return "Required field.";
                                      }
                                      if (!regExp.hasMatch(val)) {
                                        return "Letters only";
                                      }
                                      if (val.length < 2) {
                                        return "Min 2 Letters";
                                      }
                                      if (val.length >= 50) {
                                        return "Max 50 Letters";
                                      }
                                      return null;
                                    },
                                    hintText: 'Last Name',
                                    isRequired: true,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //---full name [end]
                          //***********************
                          //  --- number [start]
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
                          //  --- number [end]
                          //  *********************
                          //  --- Broker License [Start]
                          CustomFieldLayout(
                            child: TitleField(title: 'Broker License #'),
                          ),
                          CustomTextField(
                            controller:
                                controller.brokerLicenseNumberTextController,
                            hintText: 'Broker License #',
                            keyboardType: TextInputType.number,
                          ),
                          //  --- Broker License [end]
                          //  *********************
                          //  --- about me [start]
                          CustomFieldLayout(
                            child: TitleField(title: 'About Me'),
                          ),
                          CustomTextField(
                            controller: controller.aboutMeTextController,
                            hintText: 'About Me',
                            isRequired: true,
                            keyboardType: TextInputType.multiline,
                            minLines: 4,
                            maxLines: null,
                            validator: (val) {
                              if (val.length == 0) {
                                return null;
                              }
                              if (val.length < 2) {
                                return "Min 2 Letters";
                              }
                              if (val.length >= 120) {
                                return "Max 120 Letters";
                              }
                            },
                          ),
                          //  --- about me [end]
                          //  ****
                          //  --- save changes [start]
                          _space,
                          CustomButton(
                            text: 'Save Profile',
                            expanded: true,
                            onPressed: () {
                              controller.profilePicturePath = _profilePicture;
                              FocusScope.of(context).unfocus();

                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();

                                controller.updateUser();
                              }
                            },
                          ),
                          //  --- save changes [end]
                          //  ****************
                          // for spacing
                          _space,
                          _custom,
                          _space,
                          //  *****
                          //  --- more details
                          CustomFieldLayout(
                            child: TitleField(title: 'Email Address'),
                          ),
                          CustomTextField(
                            controller: controller.emailTextController,
                            hintText: '+63',
                            readOnly: true,
                          ),
                          CustomFieldLayout(
                            child: TitleField(title: 'Profession'),
                          ),
                          CustomTextField(
                            controller: controller.professionTextController,
                            hintText: 'Profession',
                            readOnly: true,
                          ),
                          // CustomFieldLayout(
                          //   child: TitleField(title: 'Broker License #'),
                          // ),
                          // CustomTextField(
                          //   controller:
                          //       controller.brokerLicenseNumberTextController,
                          //   hintText: 'Broker License #',
                          //   readOnly: true,
                          //   keyboardType: TextInputType.number,
                          // ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================== bottom popup
  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          CustomText(
            text: 'Choose your profile photo',
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                child: TextButton.icon(
                  icon: Icon(
                    Icons.camera,
                    color: App.mainColor,
                  ),
                  label: CustomText(
                    text: 'Camera',
                    fontWeight: FontWeight.w500,
                  ),
                  onPressed: () async {
                    await takePicture();
                    Navigator.pop(context);
                  },
                ),
              ),
              Expanded(
                child: TextButton.icon(
                  icon: Icon(
                    Icons.image,
                    color: App.mainColor,
                  ),
                  label: CustomText(
                    text: 'Gallery',
                    fontWeight: FontWeight.w500,
                  ),
                  onPressed: () async {
                    await uploadFromGallery();
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
