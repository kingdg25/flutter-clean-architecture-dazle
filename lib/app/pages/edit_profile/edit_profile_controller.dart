import 'dart:io';

import 'package:dazle/app/pages/edit_profile/edit_profile_presenter.dart';
import 'package:dazle/app/utils/app.dart';
import 'package:dazle/domain/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../utils/app_constant.dart';
import '../main/main_view.dart';

class EditProfileController extends Controller {
  final EditProfilePresenter editProfilePresenter;

  User? _user;
  User? get user => _user;
  String? userProfilePicture;
  File? profilePicturePath;
  final double maxFileSize = 5.0;
  //---- Display number and mobile number
  String? updatedDisplayMobileNum;
  String? updatedMobileNum;

  GlobalKey<FormState> perfonalInfoFormKey;
  GlobalKey<FormState> businessInfoFormKey;
  GlobalKey<FormState> licenseInfoFormKey;
  final TextEditingController firstNameTextController;
  final TextEditingController lastNameTextController;
  final TextEditingController professionTextController;
  final TextEditingController emailTextController;
  final TextEditingController mobileNumberTextController;
  final TextEditingController brokerLicenseNumberTextController;
  final TextEditingController aboutMeTextController;
  //---- Display number and email text controller
  final TextEditingController displayMobileNumberTextController;
  final TextEditingController displayEmailTextController;

  //---- License Numbers text Controller [Broker]
  final TextEditingController rebPrcLicenseNumTextController;
  final TextEditingController rebPrcIdNumTextController;
  final TextEditingController rebPTRNumTextController;
  final TextEditingController dhsudNumTextController;
  final TextEditingController aipoNumTextController;

  //---- License Dates Text Controller [Broker]
  final TextEditingController rebPrcDateTextController;
  final TextEditingController rebPtrDateTextController;
  final TextEditingController dhsudDateTextController;
  final TextEditingController aipoDateTextController;

  //---- License Numbers text Controller [Sales Person]
  final TextEditingController salesResAccNumTextController;
  final TextEditingController salesResIdNumTextController;
  final TextEditingController salesRebPTRNumTextController;
  final TextEditingController salesAipoNumTextController;

  //---- License Dates Text Controller [Sales Person]
  final TextEditingController salesResDateTextController;
  final TextEditingController salesRebPtrDateTextController;
  final TextEditingController salesAipoDateTextController;

  final TextEditingController brokerFirstNameTextController;
  final TextEditingController brokerLastNameTextController;

  //---- License Dates [Broker]
  DateTime? rebPrcDate;
  DateTime? rebPtrDate;
  DateTime? dhsudDate;
  DateTime? aipoDate;

  //---- License Dates [Sales Person]
  DateTime? salesResDate;
  DateTime? salesRebPtrDate;
  DateTime? salesAipoDate;

  //---- Licence info
  Map<String, dynamic> licenseDetails;

  String formSaving = '';

  EditProfileController(userRepo)
      : editProfilePresenter = EditProfilePresenter(userRepo),
        perfonalInfoFormKey = GlobalKey<FormState>(),
        businessInfoFormKey = GlobalKey<FormState>(),
        licenseInfoFormKey = GlobalKey<FormState>(),
        firstNameTextController = TextEditingController(),
        lastNameTextController = TextEditingController(),
        professionTextController = TextEditingController(),
        emailTextController = TextEditingController(),
        mobileNumberTextController = TextEditingController(),
        brokerLicenseNumberTextController = TextEditingController(),
        aboutMeTextController = TextEditingController(),
        displayMobileNumberTextController = TextEditingController(),
        displayEmailTextController = TextEditingController(),
        rebPrcDateTextController = TextEditingController(),
        rebPtrDateTextController = TextEditingController(),
        dhsudDateTextController = TextEditingController(),
        aipoDateTextController = TextEditingController(),
        rebPrcLicenseNumTextController = TextEditingController(),
        rebPrcIdNumTextController = TextEditingController(),
        rebPTRNumTextController = TextEditingController(),
        dhsudNumTextController = TextEditingController(),
        aipoNumTextController = TextEditingController(),
        salesResAccNumTextController = TextEditingController(),
        salesResIdNumTextController = TextEditingController(),
        salesRebPTRNumTextController = TextEditingController(),
        salesAipoNumTextController = TextEditingController(),
        salesResDateTextController = TextEditingController(),
        salesRebPtrDateTextController = TextEditingController(),
        salesAipoDateTextController = TextEditingController(),
        brokerFirstNameTextController = TextEditingController(),
        brokerLastNameTextController = TextEditingController(),
        licenseDetails = {},
        super();

  @override
  void initListeners() {
    getCurrentUser();

    // update user
    editProfilePresenter.updateUserOnNext = () {
      print('update user on next');
    };

    editProfilePresenter.updateUserOnComplete = () async {
      print('update user on complete');

      AppConstant.showLoader(getContext(), false);
      await _statusDialog('Done!', 'Your $formSaving has been Updated.',
          success: false);
    };
    editProfilePresenter.updateUserOnError = (e) {
      print('update user on error $e');
      AppConstant.showLoader(getContext(), false);
      if (!e['error']) {
        _statusDialog('Oops!', '${e['status'] ?? ''}', success: false);
      } else {
        _statusDialog('Something went wrong', '${e.toString()}',
            success: false);
      }
    };
  }

  saveLicenseInfo() async {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

    if (user!.position == "Broker") {
      licenseDetails = {
        "REB PRC License No.": rebPrcLicenseNumTextController.text,
        "REB PRC Id No.": rebPrcIdNumTextController.text,
        "REB PRC Date": dateFormat.format(rebPrcDate!),
        "REB PTR No.": rebPTRNumTextController.text,
        "REB PTR Date": dateFormat.format(rebPtrDate!),
        "DHSUD No.": dhsudNumTextController.text,
        "DHSUD Date": dateFormat.format(dhsudDate!),
        "AIPO No.": aipoNumTextController.text,
        "AIPO Date": dateFormat.format(aipoDate!)
      };
    } else {
      licenseDetails = {
        "REB PRC License No.": rebPrcLicenseNumTextController.text,
        "REB PRC Id No.": rebPrcIdNumTextController.text,
        "REB PRC Date": dateFormat.format(rebPrcDate!),
        "REB PTR No.": rebPTRNumTextController.text,
        "REB PTR Date": dateFormat.format(rebPtrDate!),
        "DHSUD No.": dhsudNumTextController.text,
        "DHSUD Date": dateFormat.format(dhsudDate!),
        "AIPO No.": aipoNumTextController.text,
        "AIPO Date": dateFormat.format(aipoDate!),
        // --- For Salesperson
        "Broker First Name": brokerFirstNameTextController.text,
        "Broker Last Name": brokerLastNameTextController.text,
        "Sales RES Accreditation No.": salesResAccNumTextController.text,
        "Sales RES PRC Id No.": salesResIdNumTextController.text,
        "Sales RES PRC Date": dateFormat.format(salesResDate!),
        "Sales REB PTR No.": salesRebPTRNumTextController.text,
        "Sales REB PTR Date": dateFormat.format(salesRebPtrDate!),
        "Sales AIPO No.": salesAipoNumTextController.text,
        "Sales AIPO Date": dateFormat.format(salesAipoDate!)
      };
    }

    print(licenseDetails.toString());
    updateUser();
  }

  getCurrentUser() async {
    print('INSIDE GET CURRENT USER');
    User user = await App.getUser();

    _user = user;

    firstNameTextController.text = user.firstName!;
    lastNameTextController.text = user.lastName!;
    professionTextController.text = user.position!;

    emailTextController.text = user.email!;
    mobileNumberTextController.text = user.mobileNumber!;

    aboutMeTextController.text = user.aboutMe ?? '';

    userProfilePicture = user.profilePicture;

    displayMobileNumberTextController.text = user.displayMobileNumber ?? '';
    displayEmailTextController.text = user.displayEmail ?? '';
    userProfilePicture = user.profilePicture;

    //Load License Details
    final customDateFormat1 = new DateFormat('MM/dd/yyyy');
    final customDateFormat2 = new DateFormat('MMM yyyy');
    if (user.licenseDetails != null) {
      rebPrcLicenseNumTextController.text =
          user.licenseDetails["REB PRC License No."];
      rebPrcIdNumTextController.text = user.licenseDetails["REB PRC Id No."];
      rebPrcDate = DateTime.parse(user.licenseDetails["REB PRC Date"]);
      rebPrcDateTextController.text = customDateFormat1.format(rebPrcDate!);

      rebPTRNumTextController.text = user.licenseDetails["REB PTR No."];
      rebPtrDate = DateTime.parse(user.licenseDetails["REB PTR Date"]);
      rebPtrDateTextController.text = customDateFormat2.format(rebPtrDate!);

      dhsudNumTextController.text = user.licenseDetails["DHSUD No."];
      dhsudDate = DateTime.parse(user.licenseDetails["DHSUD Date"]);
      dhsudDateTextController.text = customDateFormat2.format(dhsudDate!);

      aipoNumTextController.text = user.licenseDetails["AIPO No."];
      aipoDate = DateTime.parse(user.licenseDetails["AIPO Date"]);
      aipoDateTextController.text = customDateFormat1.format(aipoDate!);

      if (user.position == "Salesperson") {
        brokerFirstNameTextController.text =
            user.licenseDetails["Broker First Name"];
        brokerLastNameTextController.text =
            user.licenseDetails["Broker Last Name"];

        salesResAccNumTextController.text =
            user.licenseDetails["Sales RES Accreditation No."];
        salesResIdNumTextController.text =
            user.licenseDetails["Sales RES PRC Id No."];

        salesResDate =
            DateTime.parse(user.licenseDetails["Sales RES PRC Date"]);
        salesResDateTextController.text =
            salesResDate == null ? '' : customDateFormat1.format(salesResDate!);

        salesRebPTRNumTextController.text =
            user.licenseDetails["Sales REB PTR No."];

        salesRebPtrDate =
            DateTime.parse(user.licenseDetails["Sales REB PTR Date"]);
        salesRebPtrDateTextController.text = salesRebPtrDate == null
            ? ''
            : customDateFormat2.format(salesRebPtrDate!);

        salesAipoNumTextController.text = user.licenseDetails["Sales AIPO No."];

        salesAipoDate = DateTime.parse(user.licenseDetails["Sales AIPO Date"]);
        salesAipoDateTextController.text = salesAipoDate == null
            ? ''
            : customDateFormat1.format(salesAipoDate!);
      }
    }

    print('BROKER: ${user.brokerLicenseNumber}');
    if (user.brokerLicenseNumber != null) {
      brokerLicenseNumberTextController.text = user.brokerLicenseNumber!;
    }

    refreshUI();
  }

  void setLicenseDetails() {}

  void updateUser() async {
    AppConstant.showLoader(getContext(), true);
    User updatedUser;
    if (formSaving == "License Information") {
      updatedUser = User(
          //retain value
          id: _user!.id,
          firstName: _user!.firstName,
          lastName: _user!.lastName,
          mobileNumber: _user!.mobileNumber,
          aboutMe: _user!.aboutMe,
          profilePicture: user?.profilePicture,
          brokerLicenseNumber: _user!.brokerLicenseNumber,
          displayEmail: _user!.displayEmail,

          //update/changes
          licenseDetails: licenseDetails,

          // retain value
          email: _user!.email,
          position: _user!.position,
          isNewUser: false);
    } else if (formSaving == "Personal Information") {
      updatedUser = User(
          //retain value
          id: _user!.id,
          mobileNumber: _user!.mobileNumber,
          profilePicture: user?.profilePicture,
          brokerLicenseNumber: _user!.brokerLicenseNumber,
          displayEmail: _user!.displayEmail,
          licenseDetails: _user!.licenseDetails,

          //update/changes
          firstName: firstNameTextController.text,
          lastName: lastNameTextController.text,
          aboutMe: aboutMeTextController.text,

          // retain value
          email: _user!.email,
          position: _user!.position,
          isNewUser: false);
    } else {
      //
      updatedUser = User(
          // formSaving == "Business Information"
          //retain value
          id: _user!.id,
          firstName: _user!.firstName,
          lastName: _user!.lastName,
          aboutMe: _user!.aboutMe,
          profilePicture: _user?.profilePicture,
          brokerLicenseNumber: _user!.brokerLicenseNumber,
          licenseDetails: _user!.licenseDetails,

          //update/changes
          mobileNumber: updatedMobileNum,
          displayEmail: displayEmailTextController.text,
          // retain value
          email: _user!.email,
          position: _user!.position,
          isNewUser: false);
    }
    // else {
    //   if (brokerLicenseNumberTextController.text != '') {
    //     updatedUser = User(
    //         id: _user!.id,
    //         firstName: firstNameTextController.text,
    //         lastName: lastNameTextController.text,
    //         mobileNumber: updatedMobileNum,
    //         // mobileNumber: updatedMobileNum,
    //         aboutMe: aboutMeTextController.text,
    //         profilePicture: user?.profilePicture,
    //         brokerLicenseNumber: brokerLicenseNumberTextController.text,
    //         // displayMobileNumber: updatedDisplayMobileNum,
    //         displayEmail: displayEmailTextController.text,
    //         licenseDetails: licenseDetails,

    //         // retain value
    //         email: _user!.email,
    //         position: _user!.position,
    //         isNewUser: false);
    //   } else {
    //     updatedUser = User(
    //         id: _user!.id,
    //         firstName: firstNameTextController.text,
    //         lastName: lastNameTextController.text,
    //         mobileNumber: updatedMobileNum,
    //         aboutMe: aboutMeTextController.text,
    //         profilePicture: user?.profilePicture,
    //         // displayMobileNumber: displayMobileNumberTextController.text,
    //         displayEmail: displayEmailTextController.text,
    //         licenseDetails: licenseDetails,

    //         // retain value
    //         email: _user!.email,
    //         position: _user!.position,
    //         isNewUser: false);
    //   }
    // }

    editProfilePresenter.updateUser(
        user: updatedUser, profilePicture: profilePicturePath);
    getCurrentUser();
  }

  _statusDialog(String title, String text,
      {bool? success, Function? onPressed}) {
    AppConstant.statusDialog(
        context: getContext(),
        success: success ?? false,
        title: title,
        text: text,
        onPressed: onPressed);
  }

  @override
  void onResumed() => print('On resumed');

  @override
  void onReassembled() => print('View is about to be reassembled');

  @override
  void onDeactivated() => print('View is about to be deactivated');

  @override
  void onDisposed() {
    editProfilePresenter.dispose(); // don't forget to dispose of the presenter
    EasyLoading.dismiss();
    EasyLoading.removeAllCallbacks();

    firstNameTextController.dispose();
    lastNameTextController.dispose();
    professionTextController.dispose();
    emailTextController.dispose();
    mobileNumberTextController.dispose();
    brokerLicenseNumberTextController.dispose();
    aboutMeTextController.dispose();
    rebPrcLicenseNumTextController.dispose();
    rebPrcIdNumTextController.dispose();
    rebPTRNumTextController.dispose();
    dhsudNumTextController.dispose();
    aipoNumTextController.dispose();
    salesResAccNumTextController.dispose();
    salesResIdNumTextController.dispose();
    salesRebPTRNumTextController.dispose();
    salesAipoNumTextController.dispose();
    salesResDateTextController.dispose();
    salesRebPtrDateTextController.dispose();
    salesAipoDateTextController.dispose();
    brokerFirstNameTextController.dispose();
    brokerLastNameTextController.dispose();

    Loader.hide();
    super.onDisposed();
  }
}
