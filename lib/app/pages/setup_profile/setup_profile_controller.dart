import 'package:dazle/app/pages/setup_profile/setup_profile_presenter.dart';
import 'package:dazle/app/pages/register/components/send_request_screen.dart';
import 'package:dazle/app/pages/register/components/waiting_screen.dart';
import 'package:dazle/app/utils/app.dart';
import 'package:dazle/domain/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:dazle/app/utils/app_constant.dart';



class SetupProfileController extends Controller {
  final SetupProfilePresenter setupProfilePresenter;

  User _user;
  User get user => _user;

  // for setup profile
  GlobalKey<FormState> setupProfileFormKey;
  final TextEditingController firstNameTextController;
  final TextEditingController lastNameTextController;
  final TextEditingController mobileNumberTextController;
  String position;
  final TextEditingController brokerLicenseNumberTextController;
  String brokerLicenseNumberTextField;


  SetupProfileController(userRepo)
    : setupProfilePresenter = SetupProfilePresenter(userRepo),
    setupProfileFormKey = GlobalKey<FormState>(),
    firstNameTextController = TextEditingController(),
    lastNameTextController = TextEditingController(),
    mobileNumberTextController = TextEditingController(),
    position = null,
    brokerLicenseNumberTextController = TextEditingController(),
    brokerLicenseNumberTextField = 'Enter your License #',
    super();
  

  @override
  void initListeners() {
    // Initialize presenter listeners here
    // These will be called upon success, failure, or data retrieval after usecase execution
    getCurrentUser();

    //setup profile
    setupProfilePresenter.setupProfileOnNext = (User res) {
      print('setup profile on next $res ${res.toString()}');
    };

    setupProfilePresenter.setupProfileOnComplete = () {
      print('setup profile on complete');
      Loader.hide();
      Navigator.pop(getContext());

      if ( position == 'Broker' ){
        Navigator.push(
          getContext(),
          MaterialPageRoute(
            builder: (buildContext) => WaitingScreen(
              firstName: firstNameTextController.text,
            )
          )
        );
      }
      else {
        Navigator.push(
          getContext(),
          MaterialPageRoute(
            builder: (buildContext) => SendRequestScreen()
          )
        );
      }

      App.logOutUser();
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
    brokerLicenseNumberTextController.dispose();
    
    Loader.hide();
    super.onDisposed();
  }

  void setupProfile() {
    Loader.show(getContext());
    print('setupProfile ${_user.email}');

    if ( _user.email != null ) {
      setupProfilePresenter.setupProfile(
        firstName: firstNameTextController.text, 
        lastName: lastNameTextController.text, 
        mobileNumber: mobileNumberTextController.text,
        position: position,
        brokerLicenseNumber: brokerLicenseNumberTextController.text,
        email: _user.email
      );
    }

  }

  getCurrentUser() async {
    User user = await App.getUser();

    if (user != null){
      _user = user;

      firstNameTextController.text = user.firstName;
      lastNameTextController.text = user.lastName;
      mobileNumberTextController.text = user.mobileNumber;
      position = user.position;
      brokerLicenseNumberTextController.text = user.brokerLicenseNumber;

      refreshUI();
    }
  }

  setPosition(value){
    print('Position $value');
    position = value;

    if(value == 'Salesperson'){
      brokerLicenseNumberTextField = 'Enter your Broker’s License #';
    }
    else {
      brokerLicenseNumberTextField = 'Enter your License #';
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