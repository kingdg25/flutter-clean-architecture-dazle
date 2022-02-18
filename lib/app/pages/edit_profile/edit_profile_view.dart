import 'dart:io';

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
import 'package:image_picker/image_picker.dart';

import '../../widgets/custom_text.dart';

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
        body: ControlledWidgetBuilder<EditProfileController>(
            builder: (context, controller) {
          var _formKey = controller.editProfileFormKey;

          return SingleChildScrollView(
              child: Container(
                  padding:
                      EdgeInsets.only(left: 20, right: 20, bottom: 40, top: 20),
                  child: Form(
                    key: _formKey,
                    child: Column(children: [
                      Center(
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 95,
                              backgroundImage:
                                  controller.userProfilePicture != null &&
                                          _profilePicture == null
                                      ? NetworkImage(
                                          controller.userProfilePicture!)
                                      : (_profilePicture == null
                                              ? AssetImage(
                                                  'assets/user_profile.png')
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
                        ),
                      ),
                      TitleField(title: 'Full Name'),
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
                      TitleField(title: 'Mobile Number'),
                      CustomTextField(
                        controller: controller.mobileNumberTextController,
                        hintText: '+63',
                        isRequired: true,
                        keyboardType: TextInputType.phone,
                      ),
                      TitleField(title: 'About Me'),
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
                            controller.profilePicturePath = _profilePicture;
                            FocusScope.of(context).unfocus();

                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();

                              controller.updateUser();
                            }
                          }),
                      SizedBox(height: 30.0),
                      CustomFieldLayout(
                        child: Divider(
                          color: App.hintColor,
                        ),
                      ),
                      SizedBox(height: 30.0),
                      TitleField(title: 'Email Address'),
                      CustomTextField(
                        controller: controller.emailTextController,
                        hintText: '+63',
                        readOnly: true,
                      ),
                      TitleField(title: 'Profession'),
                      CustomTextField(
                        controller: controller.professionTextController,
                        hintText: 'Profession',
                        readOnly: true,
                      ),
                      TitleField(title: 'Broker License #'),
                      CustomTextField(
                        controller:
                            controller.brokerLicenseNumberTextController,
                        hintText: 'Broker License #',
                        readOnly: true,
                        keyboardType: TextInputType.number,
                      )
                    ]),
                  )));
        }));
  }

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
                  onPressed: () {
                    takePicture();
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
                  onPressed: () {
                    uploadFromGallery();
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
