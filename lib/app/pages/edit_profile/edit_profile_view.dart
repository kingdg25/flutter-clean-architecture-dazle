import 'dart:io';

import 'package:dazle/app/widgets/form_fields/custom_date_picker.dart';
import 'package:dazle/app/widgets/form_fields/custom_email_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:month_year_picker/month_year_picker.dart';

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
  // var _loadImage = AssetImage('assets/user_profile.png');
  var _space = SizedBox(height: 20.0);
  var _customDivider = CustomFieldLayout(
    child: Divider(
      color: Color(0xFFF1F1F1),
      // color: App.hintColor,
      thickness: 2,
    ),
  );

  var _textColor = Color(0xFF888888);
  var _textFieldBg = Color.fromARGB(255, 245, 244, 244);

  File? _profilePicture;
  final picker = ImagePicker();

  /// Take a photo
  Future takePicture() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

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
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

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
        title: 'Personal and Account Information',
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 20, right: 20, bottom: 40, top: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //*=============================================================== Profile pic, email and profession [START]
              ControlledWidgetBuilder<EditProfileController>(
                builder: (context, controller) {
                  return Column(
                    children: [
                      CustomFieldLayout(
                        margin: EdgeInsets.only(bottom: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 5,
                              child: TitleField(
                                title: 'PERSONAL INFO',
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: _textColor,
                              ),
                            ),
                            Flexible(
                              flex: 5,
                              child: TextButton(
                                child: controller.formEditing == 'Personal'
                                    ? Container()
                                    : CustomText(
                                        text: 'Edit',
                                        color: App.mainColor,
                                        fontSize: 19),
                                onPressed: () {
                                  controller.setFormEditing('Personal');
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Stack(
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
                            child: controller.formEditing != 'Personal'
                                ? Container()
                                : CircleAvatar(
                                    backgroundColor: App.mainColor,
                                    // backgroundColor: Colors.grey[200],?
                                    radius: 25,
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.photo_camera_rounded,
                                        color: Colors.white,
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
                      SizedBox(
                        height: 10,
                      ),
                      CustomText(
                        text: controller.emailTextController.text,
                        fontSize: 16,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      CustomText(
                        text: controller.professionTextController.text,
                        fontSize: 16,
                      ),
                    ],
                  );
                },
              ),
              //*=============================================================== Profile pic, email and profession [END]
              // _customDivider,
              ControlledWidgetBuilder<EditProfileController>(
                builder: (context, controller) {
                  var _personalInfoFormKey = controller.perfonalInfoFormKey;

                  return Column(
                    children: [
                      //* ============================= PERSONAL INFO FORM
                      Form(
                        key: _personalInfoFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            CustomFieldLayout(
                              margin: EdgeInsets.all(0),
                              child: TitleField(
                                title: 'Full Name',
                                color: _textColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            CustomFieldLayout(
                              margin: EdgeInsets.only(bottom: 6),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    child: CustomTextField(
                                      filled:
                                          controller.formEditing != 'Personal',
                                      fillColor: _textFieldBg,
                                      readOnly:
                                          controller.formEditing != 'Personal',
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
                                      filled:
                                          controller.formEditing != 'Personal',
                                      fillColor: _textFieldBg,
                                      readOnly:
                                          controller.formEditing != 'Personal',
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
                            //* ------------------- Full Name [start]
                            //***********************
                            //  --- About Me [start]
                            CustomFieldLayout(
                              margin: EdgeInsets.all(0),
                              child: TitleField(
                                title: 'About Me',
                                color: _textColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            CustomTextField(
                              controller: controller.aboutMeTextController,
                              filled: controller.formEditing != 'Personal',
                              fillColor: _textFieldBg,
                              readOnly: controller.formEditing != 'Personal',
                              hintText: 'About Me',
                              isRequired: true,
                              maxLength: 150,
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
                            //  --- About Me [end]
                            //  *********************
                            _space,
                            //*  ---- Save Button - Personal Info  [START]
                            controller.formEditing != 'Personal'
                                ? Container()
                                : Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          CustomButton(
                                            text: 'Cancel',
                                            expanded: false,
                                            onPressed: () async {
                                              _personalInfoFormKey.currentState!
                                                  .reset();
                                              _profilePicture = null;
                                              controller.setFormEditing(null);
                                              await controller.getCurrentUser();
                                            },
                                          ),
                                          SizedBox(width: 10),
                                          CustomButton(
                                            text: 'Save',
                                            expanded: false,
                                            onPressed: () {
                                              controller.profilePicturePath =
                                                  _profilePicture;
                                              FocusScope.of(context).unfocus();
                                              controller.formSaving =
                                                  'Personal Information';

                                              if (_personalInfoFormKey
                                                  .currentState!
                                                  .validate()) {
                                                _personalInfoFormKey
                                                    .currentState!
                                                    .save();

                                                controller.updateUser();
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                      // for spacing
                                      _space,
                                    ],
                                  ),
                            //*  ---- Save Button - Personal Info  [START]
                            //  ****************
                            _customDivider,
                          ],
                        ),
                      ),
                      //* =================================== BUSINESS INFO FORM
                      Form(
                        key: controller.businessInfoFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  flex: 5,
                                  child: TitleField(
                                    title: 'BUSINESS INFO',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: _textColor,
                                  ),
                                ),
                                Flexible(
                                  flex: 5,
                                  child: TextButton(
                                    child: controller.formEditing == 'Business'
                                        ? Container()
                                        : CustomText(
                                            text: 'Edit',
                                            color: App.mainColor,
                                            fontSize: 19),
                                    onPressed: () {
                                      controller.setFormEditing('Business');
                                    },
                                  ),
                                ),
                              ],
                            ),
                            //*  --- Mobile Number [start]
                            CustomFieldLayout(
                              margin: EdgeInsets.all(0),
                              child: TitleField(
                                title: 'Mobile Number',
                                color: _textColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            CustomFieldLayout(
                              margin: EdgeInsets.only(bottom: 15),
                              child: InternationalPhoneNumberInput(
                                isEnabled: controller.formEditing == 'Business',
                                countries: ['PH'],
                                textFieldController:
                                    controller.mobileNumberTextController,
                                initialValue: PhoneNumber(
                                  isoCode: 'PH',
                                  phoneNumber: controller
                                      .mobileNumberTextController.text,
                                ),
                                selectorConfig: SelectorConfig(
                                  selectorType: PhoneInputSelectorType.DIALOG,
                                ),
                                inputDecoration: InputDecoration(
                                  filled: controller.formEditing != 'Business',
                                  fillColor: _textFieldBg,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide: BorderSide.none),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    // borderSide: BorderSide.none
                                  ),
                                ),
                                onInputChanged: (number) {
                                  print(number.phoneNumber);
                                },
                                onSaved: (number) {
                                  print('On Saved: $number');
                                  controller.updatedMobileNum =
                                      number.phoneNumber;
                                },
                                keyboardType: TextInputType.numberWithOptions(
                                  signed: true,
                                  decimal: true,
                                ),
                              ),
                            ),
                            //*  --- Mobile Number [end]
                            //  *********************
                            //*  --- Display email [start]
                            CustomFieldLayout(
                              margin: EdgeInsets.all(0),
                              child: TitleField(
                                title: 'Display Email Address',
                                color: _textColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            CustomFieldLayout(
                              margin: EdgeInsets.all(0),
                              child: CustomEmailField(
                                  filled: controller.formEditing != 'Business',
                                  fillColor: _textFieldBg,
                                  readOnly:
                                      controller.formEditing != 'Business',
                                  controller:
                                      controller.displayEmailTextController,
                                  hintText: 'Email Address'),
                            ),
                            _space,
                            //*  --- Display email [end]
                            //*  ---- Save Button - Business Info  [START]
                            controller.formEditing != 'Business'
                                ? Container()
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      CustomButton(
                                        text: 'Cancel',
                                        expanded: false,
                                        onPressed: () async {
                                          controller
                                              .businessInfoFormKey.currentState!
                                              .reset();
                                          controller.setFormEditing(null);
                                          await controller.getCurrentUser();
                                        },
                                      ),
                                      SizedBox(width: 10),
                                      CustomButton(
                                        text: 'Save',
                                        expanded: false,
                                        onPressed: () {
                                          FocusScope.of(context).unfocus();
                                          controller.formSaving =
                                              'Business Information';
                                          if (controller
                                              .businessInfoFormKey.currentState!
                                              .validate()) {
                                            controller.businessInfoFormKey
                                                .currentState!
                                                .save();

                                            controller.updateUser();
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                            //*  ---- Save Button - Business Info  [END]
                          ],
                        ),
                      ),
                      _space,
                      _customDivider,
                      // ================================== LICENSE INFO FORM
                      Form(
                          key: controller.licenseInfoFormKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    flex: 5,
                                    child: TitleField(
                                      title: 'LICENSE INFO',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: _textColor,
                                    ),
                                  ),
                                  Flexible(
                                    flex: 5,
                                    child: TextButton(
                                      child: controller.formEditing == 'License'
                                          ? Container()
                                          : CustomText(
                                              text: 'Edit',
                                              color: App.mainColor,
                                              fontSize: 19),
                                      onPressed: () {
                                        controller.setFormEditing('License');
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              // ========================== SALESPERSON LICENSE DETAILS
                              controller.professionTextController.text !=
                                      'Salesperson'
                                  ? Container()
                                  : Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Flexible(
                                              child: Column(
                                                children: [
                                                  //  --- Sales RES Accreditaion No. [start]
                                                  CustomFieldLayout(
                                                    margin: EdgeInsets.all(0),
                                                    child: TitleField(
                                                      title:
                                                          'RES Accreditation No.',
                                                      color: _textColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                  CustomFieldLayout(
                                                    margin: EdgeInsets.only(
                                                        bottom: 10),
                                                    child: CustomTextField(
                                                      controller: controller
                                                          .salesResAccNumTextController,
                                                      isRequired: true,
                                                      filled: controller
                                                              .formEditing !=
                                                          'License',
                                                      fillColor: _textFieldBg,
                                                      readOnly: controller
                                                              .formEditing !=
                                                          'License',
                                                      hintText:
                                                          'RES Accreditation #',
                                                      keyboardType:
                                                          TextInputType.number,
                                                    ),
                                                  ),
                                                  //  ------ Sales RES Accreditaion No. [end]
                                                  //  *********************
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Flexible(
                                              child: Column(
                                                children: [
                                                  //  ------ Sales RES PRC ID No. [start]
                                                  CustomFieldLayout(
                                                    margin: EdgeInsets.all(0),
                                                    child: TitleField(
                                                      title: 'RES PRC ID No.',
                                                      color: _textColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                  CustomFieldLayout(
                                                    margin: EdgeInsets.only(
                                                        bottom: 10),
                                                    child: CustomTextField(
                                                      controller: controller
                                                          .salesResIdNumTextController,
                                                      isRequired: true,
                                                      filled: controller
                                                              .formEditing !=
                                                          'License',
                                                      fillColor: _textFieldBg,
                                                      readOnly: controller
                                                              .formEditing !=
                                                          'License',
                                                      hintText: 'RES PRC ID #',
                                                      keyboardType:
                                                          TextInputType.number,
                                                    ),
                                                  ),

                                                  //  ------ Sales RES PRC ID No. [end]
                                                  //  *********************
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        //  --- Sales RES PRC Date [start]
                                        CustomFieldLayout(
                                          margin: EdgeInsets.all(0),
                                          child: TitleField(
                                            title: 'Valid Until (RES PRC)',
                                            color: _textColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                        CustomFieldLayout(
                                          margin: EdgeInsets.only(bottom: 10),
                                          child: CustomDatePicker(
                                            controller: controller
                                                .salesResDateTextController,
                                            filled: controller.formEditing !=
                                                'License',
                                            fillColor: _textFieldBg,
                                            readOnly: controller.formEditing !=
                                                'License',
                                            isRequired: true,
                                            hintText: '',
                                            keyboardType: TextInputType.number,
                                            onTap: () async {
                                              final f =
                                                  new DateFormat('MM/dd/yyyy');
                                              DateTime? selectedDate =
                                                  await showDatePicker(
                                                      context: context,
                                                      initialDate:
                                                          DateTime.now(),
                                                      firstDate: DateTime(1900),
                                                      lastDate: DateTime(3000));

                                              if (selectedDate != null) {
                                                controller.salesResDate =
                                                    selectedDate;
                                                controller
                                                    .salesResDateTextController
                                                    .text = controller
                                                            .salesResDate ==
                                                        null
                                                    ? ''
                                                    : f.format(controller
                                                        .salesResDate!);
                                              }
                                            },
                                            suffixIconOnTap: () async {
                                              final f =
                                                  new DateFormat('MM/dd/yyyy');
                                              DateTime? selectedDate =
                                                  await showDatePicker(
                                                      context: context,
                                                      initialDate:
                                                          DateTime.now(),
                                                      firstDate: DateTime(1900),
                                                      lastDate: DateTime(3000));

                                              if (selectedDate != null) {
                                                controller.salesResDate =
                                                    selectedDate;
                                                controller
                                                    .salesResDateTextController
                                                    .text = controller
                                                            .salesResDate ==
                                                        null
                                                    ? ''
                                                    : f.format(controller
                                                        .salesResDate!);
                                              }
                                            },
                                          ),
                                        ),
                                        //  --- Sales RES PRC Date [end]
                                        //  *********************
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Flexible(
                                              child: Column(
                                                children: [
                                                  //  --- Sales REB PTR No [start]
                                                  CustomFieldLayout(
                                                    margin: EdgeInsets.all(0),
                                                    child: TitleField(
                                                      title: 'REB PTR No.',
                                                      color: _textColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                  CustomFieldLayout(
                                                    margin: EdgeInsets.only(
                                                        bottom: 10),
                                                    child: CustomTextField(
                                                      controller: controller
                                                          .salesRebPTRNumTextController,
                                                      isRequired: true,
                                                      filled: controller
                                                              .formEditing !=
                                                          'License',
                                                      fillColor: _textFieldBg,
                                                      readOnly: controller
                                                              .formEditing !=
                                                          'License',
                                                      hintText: 'REB PTR No.',
                                                      keyboardType:
                                                          TextInputType.number,
                                                    ),
                                                  ),
                                                  //  --- Sales REB PTR No [end]
                                                  //  *********************
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Flexible(
                                              child: Column(
                                                children: [
                                                  //  --- Sales REB PTR No DATE [start]
                                                  CustomFieldLayout(
                                                    margin: EdgeInsets.all(0),
                                                    child: TitleField(
                                                      title: 'Valid Until',
                                                      color: _textColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                  CustomFieldLayout(
                                                    margin: EdgeInsets.only(
                                                        bottom: 10),
                                                    child: CustomDatePicker(
                                                      controller: controller
                                                          .salesRebPtrDateTextController,
                                                      isRequired: true,
                                                      filled: controller
                                                              .formEditing !=
                                                          'License',
                                                      fillColor: _textFieldBg,
                                                      readOnly: controller
                                                              .formEditing !=
                                                          'License',
                                                      hintText: '',
                                                      keyboardType:
                                                          TextInputType.number,
                                                      onTap: () async {
                                                        final f =
                                                            new DateFormat(
                                                                'MMM yyyy');
                                                        DateTime? selectedDate =
                                                            await showMonthYearPicker(
                                                                context:
                                                                    context,
                                                                initialDate:
                                                                    DateTime
                                                                        .now(),
                                                                firstDate:
                                                                    DateTime(
                                                                        1900),
                                                                lastDate:
                                                                    DateTime(
                                                                        2025));

                                                        if (selectedDate !=
                                                            null) {
                                                          controller
                                                                  .salesRebPtrDate =
                                                              selectedDate;

                                                          controller
                                                              .salesRebPtrDateTextController
                                                              .text = controller
                                                                      .salesRebPtrDate ==
                                                                  null
                                                              ? ''
                                                              : f.format(controller
                                                                  .salesRebPtrDate!);
                                                        }
                                                      },
                                                      suffixIconOnTap:
                                                          () async {
                                                        final f =
                                                            new DateFormat(
                                                                'MMM yyyy');
                                                        DateTime? selectedDate =
                                                            await showMonthYearPicker(
                                                                context:
                                                                    context,
                                                                initialDate:
                                                                    DateTime
                                                                        .now(),
                                                                firstDate:
                                                                    DateTime(
                                                                        1900),
                                                                lastDate:
                                                                    DateTime(
                                                                        2025));

                                                        if (selectedDate !=
                                                            null) {
                                                          controller
                                                                  .salesRebPtrDate =
                                                              selectedDate;

                                                          controller
                                                              .salesRebPtrDateTextController
                                                              .text = controller
                                                                      .salesRebPtrDate ==
                                                                  null
                                                              ? ''
                                                              : f.format(controller
                                                                  .salesRebPtrDate!);
                                                        }
                                                      },
                                                    ),
                                                  ),

                                                  //  --- Sales REB PTR No date [end]
                                                  //  *********************
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Flexible(
                                              child: Column(
                                                children: [
                                                  //  --- Sales AIPO No. [start]
                                                  CustomFieldLayout(
                                                    margin: EdgeInsets.all(0),
                                                    child: TitleField(
                                                      title: 'AIPO No.',
                                                      color: _textColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                  CustomFieldLayout(
                                                    margin: EdgeInsets.only(
                                                        bottom: 10),
                                                    child: CustomTextField(
                                                      controller: controller
                                                          .salesAipoNumTextController,
                                                      isRequired: true,
                                                      filled: controller
                                                              .formEditing !=
                                                          'License',
                                                      fillColor: _textFieldBg,
                                                      readOnly: controller
                                                              .formEditing !=
                                                          'License',
                                                      hintText: 'AIPO No.',
                                                      keyboardType:
                                                          TextInputType.number,
                                                    ),
                                                  ),
                                                  //  --- Sales AIPO No. [end]
                                                  //  *********************
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Flexible(
                                              child: Column(
                                                children: [
                                                  //  --- Sales AIPO No DATE [start]
                                                  CustomFieldLayout(
                                                    margin: EdgeInsets.all(0),
                                                    child: TitleField(
                                                      title: 'Valid Until',
                                                      color: _textColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                  CustomFieldLayout(
                                                    margin: EdgeInsets.only(
                                                        bottom: 10),
                                                    child: CustomDatePicker(
                                                      controller: controller
                                                          .salesAipoDateTextController,
                                                      isRequired: true,
                                                      filled: controller
                                                              .formEditing !=
                                                          'License',
                                                      fillColor: _textFieldBg,
                                                      readOnly: controller
                                                              .formEditing !=
                                                          'License',
                                                      hintText: '',
                                                      keyboardType:
                                                          TextInputType.number,
                                                      onTap: () async {
                                                        final f =
                                                            new DateFormat(
                                                                'MM/dd/yyyy');

                                                        DateTime? selectedDate =
                                                            await showDatePicker(
                                                                context:
                                                                    context,
                                                                initialDate:
                                                                    DateTime
                                                                        .now(),
                                                                firstDate:
                                                                    DateTime(
                                                                        1900),
                                                                lastDate:
                                                                    DateTime(
                                                                        2025));

                                                        if (selectedDate !=
                                                            null) {
                                                          controller
                                                                  .salesAipoDate =
                                                              selectedDate;

                                                          controller
                                                              .salesAipoDateTextController
                                                              .text = controller
                                                                      .salesAipoDate ==
                                                                  null
                                                              ? ''
                                                              : f.format(controller
                                                                  .salesAipoDate!);
                                                        }
                                                      },
                                                      suffixIconOnTap:
                                                          () async {
                                                        final f =
                                                            new DateFormat(
                                                                'MM/dd/yyyy');

                                                        DateTime? selectedDate =
                                                            await showDatePicker(
                                                                context:
                                                                    context,
                                                                initialDate:
                                                                    DateTime
                                                                        .now(),
                                                                firstDate:
                                                                    DateTime(
                                                                        1900),
                                                                lastDate:
                                                                    DateTime(
                                                                        2025));

                                                        if (selectedDate !=
                                                            null) {
                                                          controller
                                                                  .salesAipoDate =
                                                              selectedDate;

                                                          controller
                                                              .salesAipoDateTextController
                                                              .text = controller
                                                                      .salesAipoDate ==
                                                                  null
                                                              ? ''
                                                              : f.format(controller
                                                                  .salesAipoDate!);
                                                        }
                                                      },
                                                    ),
                                                  ),

                                                  //  --- Sales AIPO No date [end]
                                                  //  *********************
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        _space,
                                      ],
                                    ),
                              controller.professionTextController.text !=
                                      'Salesperson'
                                  ? Container()
                                  : CustomFieldLayout(
                                      margin: EdgeInsets.only(bottom: 6),
                                      child: TitleField(
                                        title: 'BROKER\'S LICENSE INFO',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                        color: _textColor,
                                      ),
                                    ),
                              //--- Full Name [Broker's]
                              controller.professionTextController.text !=
                                      'Salesperson'
                                  ? Container()
                                  : CustomFieldLayout(
                                      margin: EdgeInsets.all(0),
                                      child: TitleField(
                                        title: 'Broker\'s Full Name',
                                        color: _textColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                              controller.professionTextController.text !=
                                      'Salesperson'
                                  ? Container()
                                  : CustomFieldLayout(
                                      margin: EdgeInsets.only(bottom: 6),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Flexible(
                                            child: CustomTextField(
                                              isRequired: true,
                                              filled: controller.formEditing !=
                                                  'License',
                                              fillColor: _textFieldBg,
                                              readOnly:
                                                  controller.formEditing !=
                                                      'License',
                                              controller: controller
                                                  .brokerFirstNameTextController,
                                              hintText: 'First Name',
                                              validator: (val) {
                                                final namePattern =
                                                    r'^[a-zA-Z_ ]*$';
                                                final regExp =
                                                    RegExp(namePattern);

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
                                              textCapitalization:
                                                  TextCapitalization.sentences,
                                            ),
                                          ),
                                          SizedBox(width: 8.0),
                                          Flexible(
                                            child: CustomTextField(
                                              controller: controller
                                                  .brokerLastNameTextController,
                                              isRequired: true,
                                              filled: controller.formEditing !=
                                                  'License',
                                              fillColor: _textFieldBg,
                                              readOnly:
                                                  controller.formEditing !=
                                                      'License',
                                              validator: (val) {
                                                final namePattern =
                                                    r'^[a-zA-Z_ ]*$';
                                                final regExp =
                                                    RegExp(namePattern);

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
                                              textCapitalization:
                                                  TextCapitalization.sentences,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                              //--- Full Name [Broker's]
                              // ========================== BROKER LICENSE DETAILS
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    child: Column(
                                      children: [
                                        //  --- REB PRC License Number [start]
                                        CustomFieldLayout(
                                          margin: EdgeInsets.all(0),
                                          child: TitleField(
                                            title: 'REB PRC License No.',
                                            color: _textColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                        CustomFieldLayout(
                                          margin: EdgeInsets.only(bottom: 10),
                                          child: CustomTextField(
                                            controller: controller
                                                .rebPrcLicenseNumTextController,
                                            isRequired: true,
                                            filled: controller.formEditing !=
                                                'License',
                                            fillColor: _textFieldBg,
                                            readOnly: controller.formEditing !=
                                                'License',
                                            hintText: 'REB PRC License #',
                                            keyboardType: TextInputType.number,
                                          ),
                                        ),
                                        //  --- REB PRC License Number [end]
                                        //  *********************
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Flexible(
                                    child: Column(
                                      children: [
                                        //  --- REB PRC ID Number [start]
                                        CustomFieldLayout(
                                          margin: EdgeInsets.all(0),
                                          child: TitleField(
                                            title: 'REB PRC ID No.',
                                            color: _textColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                        CustomFieldLayout(
                                          margin: EdgeInsets.only(bottom: 10),
                                          child: CustomTextField(
                                            controller: controller
                                                .rebPrcIdNumTextController,
                                            isRequired: true,
                                            filled: controller.formEditing !=
                                                'License',
                                            fillColor: _textFieldBg,
                                            readOnly: controller.formEditing !=
                                                'License',
                                            hintText: 'REB PRC ID #',
                                            keyboardType: TextInputType.number,
                                          ),
                                        ),

                                        //  --- REB PRC License ID [end]
                                        //  *********************
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              //  --- REB PRC date valid [start]
                              CustomFieldLayout(
                                margin: EdgeInsets.all(0),
                                child: TitleField(
                                  title: 'Valid Until (REB PRC)',
                                  color: _textColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              CustomFieldLayout(
                                margin: EdgeInsets.only(bottom: 10),
                                child: CustomDatePicker(
                                  controller:
                                      controller.rebPrcDateTextController,
                                  isRequired: true,
                                  filled: controller.formEditing != 'License',
                                  fillColor: _textFieldBg,
                                  readOnly: controller.formEditing != 'License',
                                  hintText: '',
                                  keyboardType: TextInputType.number,
                                  onTap: () async {
                                    final f = new DateFormat('MM/dd/yyyy');
                                    DateTime? selectedDate =
                                        await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(1900),
                                            lastDate: DateTime(3000));

                                    if (selectedDate != null) {
                                      controller.rebPrcDate = selectedDate;
                                      controller.rebPrcDateTextController.text =
                                          controller.rebPrcDate == null
                                              ? ''
                                              : f.format(
                                                  controller.rebPrcDate!);
                                    }
                                  },
                                  suffixIconOnTap: () async {
                                    final f = new DateFormat('MM/dd/yyyy');
                                    DateTime? selectedDate =
                                        await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(1900),
                                            lastDate: DateTime(3000));

                                    if (selectedDate != null) {
                                      controller.rebPrcDate = selectedDate;
                                      controller.rebPrcDateTextController.text =
                                          controller.rebPrcDate == null
                                              ? ''
                                              : f.format(
                                                  controller.rebPrcDate!);
                                    }
                                  },
                                ),
                              ),
                              //  --- REB PRC date valid [end]
                              //  *********************
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    child: Column(
                                      children: [
                                        //  --- REB PTR No [start]
                                        CustomFieldLayout(
                                          margin: EdgeInsets.all(0),
                                          child: TitleField(
                                            title: 'REB PTR No.',
                                            color: _textColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                        CustomFieldLayout(
                                          margin: EdgeInsets.only(bottom: 10),
                                          child: CustomTextField(
                                            controller: controller
                                                .rebPTRNumTextController,
                                            isRequired: true,
                                            filled: controller.formEditing !=
                                                'License',
                                            fillColor: _textFieldBg,
                                            readOnly: controller.formEditing !=
                                                'License',
                                            hintText: 'REB PTR No.',
                                            keyboardType: TextInputType.number,
                                          ),
                                        ),
                                        //  --- REB PTR No [end]
                                        //  *********************
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Flexible(
                                    child: Column(
                                      children: [
                                        //  ---REB PTR No DATE [start]
                                        CustomFieldLayout(
                                          margin: EdgeInsets.all(0),
                                          child: TitleField(
                                            title: 'Valid Until',
                                            color: _textColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                        CustomFieldLayout(
                                          margin: EdgeInsets.only(bottom: 10),
                                          child: CustomDatePicker(
                                            controller: controller
                                                .rebPtrDateTextController,
                                            isRequired: true,
                                            filled: controller.formEditing !=
                                                'License',
                                            fillColor: _textFieldBg,
                                            readOnly: controller.formEditing !=
                                                'License',
                                            hintText: '',
                                            keyboardType: TextInputType.number,
                                            onTap: () async {
                                              final f =
                                                  new DateFormat('MMM yyyy');
                                              DateTime? selectedDate =
                                                  await showMonthYearPicker(
                                                      context: context,
                                                      initialDate:
                                                          DateTime.now(),
                                                      firstDate: DateTime(1900),
                                                      lastDate: DateTime(3000));

                                              if (selectedDate != null) {
                                                controller.rebPtrDate =
                                                    selectedDate;

                                                controller
                                                    .rebPtrDateTextController
                                                    .text = controller
                                                            .rebPtrDate ==
                                                        null
                                                    ? ''
                                                    : f.format(
                                                        controller.rebPtrDate!);
                                              }
                                            },
                                            suffixIconOnTap: () async {
                                              final f =
                                                  new DateFormat('MMM yyyy');
                                              DateTime? selectedDate =
                                                  await showMonthYearPicker(
                                                      context: context,
                                                      initialDate:
                                                          DateTime.now(),
                                                      firstDate: DateTime(1900),
                                                      lastDate: DateTime(3000));

                                              if (selectedDate != null) {
                                                controller.rebPtrDate =
                                                    selectedDate;

                                                controller
                                                    .rebPtrDateTextController
                                                    .text = controller
                                                            .rebPtrDate ==
                                                        null
                                                    ? ''
                                                    : f.format(
                                                        controller.rebPtrDate!);
                                              }
                                            },
                                          ),
                                        ),

                                        //  --- REB PTR No date [end]
                                        //  *********************
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    child: Column(
                                      children: [
                                        //  --- DHSUD No [start]
                                        CustomFieldLayout(
                                          margin: EdgeInsets.all(0),
                                          child: TitleField(
                                            title: 'DHSUD No.',
                                            color: _textColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                        CustomFieldLayout(
                                          margin: EdgeInsets.only(bottom: 10),
                                          child: CustomTextField(
                                            controller: controller
                                                .dhsudNumTextController,
                                            isRequired: true,
                                            filled: controller.formEditing !=
                                                'License',
                                            fillColor: _textFieldBg,
                                            readOnly: controller.formEditing !=
                                                'License',
                                            hintText: 'DHSUD No.',
                                            keyboardType: TextInputType.number,
                                          ),
                                        ),
                                        //  --- DHSUD No [end]
                                        //  *********************
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Flexible(
                                    child: Column(
                                      children: [
                                        //  ---DHSUD No DATE [start]
                                        CustomFieldLayout(
                                          margin: EdgeInsets.all(0),
                                          child: TitleField(
                                            title: 'Valid Until',
                                            color: _textColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                        CustomFieldLayout(
                                          margin: EdgeInsets.only(bottom: 10),
                                          child: CustomDatePicker(
                                            controller: controller
                                                .dhsudDateTextController,
                                            isRequired: true,
                                            filled: controller.formEditing !=
                                                'License',
                                            fillColor: _textFieldBg,
                                            readOnly: controller.formEditing !=
                                                'License',
                                            hintText: '',
                                            keyboardType: TextInputType.number,
                                            onTap: () async {
                                              final f =
                                                  new DateFormat('MMM yyyy');

                                              DateTime? selectedDate =
                                                  await showMonthYearPicker(
                                                      context: context,
                                                      initialDate:
                                                          DateTime.now(),
                                                      firstDate: DateTime(1900),
                                                      lastDate: DateTime(3000));

                                              if (selectedDate != null) {
                                                controller.dhsudDate =
                                                    selectedDate;

                                                controller
                                                    .dhsudDateTextController
                                                    .text = controller
                                                            .dhsudDate ==
                                                        null
                                                    ? ''
                                                    : f.format(
                                                        controller.dhsudDate!);
                                              }
                                            },
                                            suffixIconOnTap: () async {
                                              final f =
                                                  new DateFormat('MMM yyyy');

                                              DateTime? selectedDate =
                                                  await showMonthYearPicker(
                                                      context: context,
                                                      initialDate:
                                                          DateTime.now(),
                                                      firstDate: DateTime(1900),
                                                      lastDate: DateTime(3000));

                                              if (selectedDate != null) {
                                                controller.dhsudDate =
                                                    selectedDate;

                                                controller
                                                    .dhsudDateTextController
                                                    .text = controller
                                                            .dhsudDate ==
                                                        null
                                                    ? ''
                                                    : f.format(
                                                        controller.dhsudDate!);
                                              }
                                            },
                                          ),
                                        ),

                                        //  --- DHSUD No date [end]
                                        //  *********************
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    child: Column(
                                      children: [
                                        //  --- AIPO No [start]
                                        CustomFieldLayout(
                                          margin: EdgeInsets.all(0),
                                          child: TitleField(
                                            title: 'AIPO No.',
                                            color: _textColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                        CustomFieldLayout(
                                          margin: EdgeInsets.only(bottom: 10),
                                          child: CustomTextField(
                                            controller: controller
                                                .aipoNumTextController,
                                            isRequired: true,
                                            filled: controller.formEditing !=
                                                'License',
                                            fillColor: _textFieldBg,
                                            readOnly: controller.formEditing !=
                                                'License',
                                            hintText: 'AIPO No.',
                                            keyboardType: TextInputType.number,
                                          ),
                                        ),
                                        //  --- AIPO No [end]
                                        //  *********************
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Flexible(
                                    child: Column(
                                      children: [
                                        //  --- AIPO No DATE [start]
                                        CustomFieldLayout(
                                          margin: EdgeInsets.all(0),
                                          child: TitleField(
                                            title: 'Valid Until',
                                            color: _textColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                        CustomFieldLayout(
                                          margin: EdgeInsets.only(bottom: 10),
                                          child: CustomDatePicker(
                                            controller: controller
                                                .aipoDateTextController,
                                            isRequired: true,
                                            filled: controller.formEditing !=
                                                'License',
                                            fillColor: _textFieldBg,
                                            readOnly: controller.formEditing !=
                                                'License',
                                            hintText: '',
                                            keyboardType: TextInputType.number,
                                            onTap: () async {
                                              final f =
                                                  new DateFormat('MM/dd/yyyy');

                                              DateTime? selectedDate =
                                                  await showDatePicker(
                                                      context: context,
                                                      initialDate:
                                                          DateTime.now(),
                                                      firstDate: DateTime(1900),
                                                      lastDate: DateTime(3000));

                                              if (selectedDate != null) {
                                                controller.aipoDate =
                                                    selectedDate;

                                                controller
                                                    .aipoDateTextController
                                                    .text = controller
                                                            .aipoDate ==
                                                        null
                                                    ? ''
                                                    : f.format(
                                                        controller.aipoDate!);
                                              }
                                            },
                                            suffixIconOnTap: () async {
                                              final f =
                                                  new DateFormat('MM/dd/yyyy');
                                              controller.aipoDate =
                                                  await showDatePicker(
                                                      context: context,
                                                      initialDate:
                                                          DateTime.now(),
                                                      firstDate: DateTime(1900),
                                                      lastDate: DateTime(3000));

                                              controller.aipoDateTextController
                                                      .text =
                                                  controller.aipoDate == null
                                                      ? ''
                                                      : f.format(
                                                          controller.aipoDate!);
                                            },
                                          ),
                                        ),

                                        //  --- AIPO No date [end]
                                        //  *********************
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              _space,
                              //* ----- Save Button - License Info [Start]
                              controller.formEditing != 'License'
                                  ? Container()
                                  : Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        CustomButton(
                                          text: 'Cancel',
                                          expanded: false,
                                          onPressed: () async {
                                            controller.licenseInfoFormKey
                                                .currentState!
                                                .reset();
                                            controller.setFormEditing(null);
                                            await controller.getCurrentUser();
                                          },
                                        ),
                                        SizedBox(width: 10),
                                        CustomButton(
                                          text: 'Save',
                                          expanded: false,
                                          onPressed: () {
                                            FocusScope.of(context).unfocus();
                                            controller.formSaving =
                                                'License Information';

                                            if (controller.licenseInfoFormKey
                                                .currentState!
                                                .validate()) {
                                              controller.licenseInfoFormKey
                                                  .currentState!
                                                  .save();

                                              // controller.updateUser();

                                              controller.saveLicenseInfo();
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                            ],
                          )),
                    ],
                  );
                },
              ),
            ],
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
