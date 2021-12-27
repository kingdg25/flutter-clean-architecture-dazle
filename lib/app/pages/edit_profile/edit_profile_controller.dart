import 'package:dazle/app/pages/edit_profile/edit_profile_presenter.dart';
import 'package:dazle/app/utils/app.dart';
import 'package:dazle/domain/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';


class EditProfileController extends Controller {
  final EditProfilePresenter editProfilePresenter;

  User _user;
  User get user => _user;

  GlobalKey<FormState> editProfileFormKey;
  final TextEditingController firstNameTextController;
  final TextEditingController lastNameTextController;
  final TextEditingController professionTextController;
  final TextEditingController emailTextController;
  final TextEditingController mobileNumberTextController;
  final TextEditingController brokerLicenseNumberTextController;
  final TextEditingController aboutMeTextController;

  EditProfileController(userRepo)
    : editProfilePresenter = EditProfilePresenter(),
      editProfileFormKey = GlobalKey<FormState>(),
      firstNameTextController = TextEditingController(),
      lastNameTextController = TextEditingController(),
      professionTextController = TextEditingController(),
      emailTextController = TextEditingController(),
      mobileNumberTextController = TextEditingController(),
      brokerLicenseNumberTextController = TextEditingController(),
      aboutMeTextController = TextEditingController(),
      super();


  @override
  void initListeners() {
    getCurrentUser();
  }



  getCurrentUser() async {
    User user = await App.getUser();

    if (user != null){
      _user = user;

      firstNameTextController.text = user.firstName;
      lastNameTextController.text = user.lastName;
      professionTextController.text = user.position;

      emailTextController.text = user.email;
      mobileNumberTextController.text = user.mobileNumber;
      
      brokerLicenseNumberTextController.text = user.brokerLicenseNumber;
      aboutMeTextController.text = user.aboutMe;

      refreshUI();
    }
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

    firstNameTextController.dispose();
    lastNameTextController.dispose();
    professionTextController.dispose();
    emailTextController.dispose();
    mobileNumberTextController.dispose();
    brokerLicenseNumberTextController.dispose();
    aboutMeTextController.dispose();

    super.onDisposed();
  }
  
}