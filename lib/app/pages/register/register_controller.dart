import 'package:dazle/app/pages/register/components/send_request_screen.dart';
import 'package:dazle/app/pages/register/components/waiting_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:dazle/app/pages/register/register_presenter.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:dazle/app/utils/app_constant.dart';


class RegisterController extends Controller {

  PageController registerPageController;

  GlobalKey<FormState> registerFormKeyPage1;
  final TextEditingController firstNameTextController;
  final TextEditingController lastNameTextController;
  final TextEditingController mobileNumberTextController;
  String position;
  final TextEditingController licenseNumberTextController;

  String licenseNumberTextField;

  GlobalKey<FormState> registerFormKeyPage2;
  final TextEditingController emailTextController;
  final TextEditingController passwordTextController;


  final RegisterPresenter registerPresenter;

  RegisterController(userRepo)
    : registerPresenter = RegisterPresenter(userRepo),
      registerPageController = PageController(),
      registerFormKeyPage1 = GlobalKey<FormState>(),
      firstNameTextController = TextEditingController(),
      lastNameTextController = TextEditingController(),
      mobileNumberTextController = TextEditingController(),
      position = null,
      licenseNumberTextController = TextEditingController(),
      licenseNumberTextField = 'Enter your License #',
      registerFormKeyPage2 = GlobalKey<FormState>(),
      emailTextController = TextEditingController(),
      passwordTextController = TextEditingController(),
      super();
  

  @override
  void initListeners() {
    // register user
    registerPresenter.registerUserOnNext = () {
      print('register user on next');
    };

    registerPresenter.registerUserOnComplete = () {
      print('register user on complete');
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
    };

    registerPresenter.registerUserOnError = (e) {
      print('register user on error $e');
      Loader.hide();
      
      if ( !e['error'] ) {
        _statusDialog(false, 'Oops!', '${e['status'] ?? ''}');
      }
      else{
        _statusDialog(false, 'Something went wrong', '${e.toString()}');
      } 
    };
  }

  setPosition(value){
    print('setposition $value');
    position = value;

    if(value == 'Salesperson'){
      licenseNumberTextField = 'Enter your Broker’s License #';
    }
    else {
      licenseNumberTextField = 'Enter your License #';
    }

    refreshUI();
  }

  void register() {
    Loader.show(getContext());

    registerPresenter.registerUser(
      firstNameTextController.text, 
      lastNameTextController.text, 
      mobileNumberTextController.text,
      position,
      licenseNumberTextController.text,

      emailTextController.text, 
      passwordTextController.text
    );
  }

  _statusDialog(bool success, String title, String text){
    AppConstant.statusDialog(
      context: getContext(),
      success: success ?? false,
      title: title,
      text: text,
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
    registerPresenter.dispose(); // don't forget to dispose of the presenter
    
    firstNameTextController.dispose();
    lastNameTextController.dispose();
    mobileNumberTextController.dispose();
    licenseNumberTextController.dispose();

    emailTextController.dispose();
    passwordTextController.dispose();
    Loader.hide();
    super.onDisposed();
  }

}