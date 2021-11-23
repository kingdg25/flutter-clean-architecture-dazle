import 'package:dazle/app/pages/login/setup_profile/setup_profile_presenter.dart';
import 'package:dazle/app/utils/app.dart';
import 'package:dazle/domain/entities/todo_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:dazle/app/utils/app_constant.dart';



class SetupProfileController extends Controller {
  final SetupProfilePresenter setupProfilePresenter;

  TodoUser _user;
  TodoUser get user => _user;

  // for setup profile
  GlobalKey<FormState> setupProfileFormKey;
  final TextEditingController firstNameTextController;
  final TextEditingController lastNameTextController;
  final TextEditingController mobileNumberTextController;
  String position;
  final TextEditingController licenseNumberTextController;
  String licenseNumberTextField;


  SetupProfileController(userRepo)
    : setupProfilePresenter = SetupProfilePresenter(userRepo),
    setupProfileFormKey = GlobalKey<FormState>(),
    firstNameTextController = TextEditingController(),
    lastNameTextController = TextEditingController(),
    mobileNumberTextController = TextEditingController(),
    position = null,
    licenseNumberTextController = TextEditingController(),
    licenseNumberTextField = 'Enter your License #',
    super();
  

  @override
  void initListeners() {
    // Initialize presenter listeners here
    // These will be called upon success, failure, or data retrieval after usecase execution
    getCurrentUser();

    //setup profile
    setupProfilePresenter.setupProfileOnNext = (TodoUser res) {
      print('setup profile on next $res ${res.toString()}');
    };

    setupProfilePresenter.setupProfileOnComplete = () {
      print('setup profile on complete');
      Loader.hide();
    };

    setupProfilePresenter.setupProfileOnError = (e) {
      print('setup profile on error $e');
      Loader.hide();

      if ( !e['error'] ) {
        _statusDialog(false, 'Oops!', '${e['status'] ?? ''}');
      }
      else{
        _statusDialog(false, 'Something went wrong', '${e.toString()}');
      } 
    };
  }

  @override
  void onDisposed() {
    setupProfilePresenter.dispose(); // don't forget to dispose of the presenter
    
    // setup profile
    firstNameTextController.dispose();
    lastNameTextController.dispose();
    mobileNumberTextController.dispose();
    licenseNumberTextController.dispose();
    
    Loader.hide();
    super.onDisposed();
  }

  void updateProfile() {
    Loader.show(getContext());
    print('updateProfile ${_user.email}');

    if ( _user.email != null ) {
      setupProfilePresenter.updateUser(
        firstNameTextController.text, 
        lastNameTextController.text, 
        mobileNumberTextController.text,
        position,
        licenseNumberTextController.text,
        _user.email
      );
    }

  }

  getCurrentUser() async {
    TodoUser user = await App.getUser();

    if (user != null){
      _user = user;

      firstNameTextController.text = user.firstName;
      lastNameTextController.text = user.lastName;
      mobileNumberTextController.text = user.mobileNumber;
      position = user.position;
      licenseNumberTextController.text = user.licenseNumber;

      refreshUI();
    }
  }

  setPosition(value){
    print('Position $value');
    position = value;

    if(value == 'Salesperson'){
      licenseNumberTextField = 'Enter your Broker’s License #';
    }
    else {
      licenseNumberTextField = 'Enter your License #';
    }

    refreshUI();
  }

  _statusDialog(bool success, String title, String text){
    AppConstant.statusDialog(
      context: getContext(),
      success: success ?? false,
      title: title,
      text: text,
    );
  }

}