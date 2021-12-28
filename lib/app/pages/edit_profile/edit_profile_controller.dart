import 'package:dazle/app/pages/edit_profile/edit_profile_presenter.dart';
import 'package:dazle/app/utils/app.dart';
import 'package:dazle/app/utils/app_constant.dart';
import 'package:dazle/domain/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';


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
    : editProfilePresenter = EditProfilePresenter(userRepo),
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

    // update user
    editProfilePresenter.updateUserOnNext = () {
      print('update user on next');
    };

    editProfilePresenter.updateUserOnComplete = () {
      print('update user on complete');
      AppConstant.showLoader(getContext(), false);

      _statusDialog('Success!', 'Updated Sucessfully');
    };

    editProfilePresenter.updateUserOnError = (e) {
      print('update user on error $e');
      AppConstant.showLoader(getContext(), false);
      
      if ( !e['error'] ) {
        _statusDialog('Oops!', '${e['status'] ?? ''}');
      }
      else{
        _statusDialog('Something went wrong', '${e.toString()}');
      } 
    };
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


  void updateUser(){
    AppConstant.showLoader(getContext(), true);
    User updatedUser = User(
      id: _user.id,

      firstName: firstNameTextController.text,
      lastName: lastNameTextController.text,
      mobileNumber: mobileNumberTextController.text,
      aboutMe: aboutMeTextController.text,

      // retain value
      email: _user.email,
      position: _user.position,
      brokerLicenseNumber: _user.brokerLicenseNumber,
      isNewUser: false
    );

    editProfilePresenter.updateUser(user: updatedUser);
  }


  _statusDialog(String title, String text, {bool success, Function onPressed}){
    AppConstant.statusDialog(
      context: getContext(),
      success: success ?? false,
      title: title,
      text: text,
      onPressed: onPressed
    );
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

    Loader.hide();
    super.onDisposed();
  }
  
}