import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:dazle/app/pages/register/register_presenter.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:dazle/app/utils/app_constants.dart';


class RegisterController extends Controller {

  PageController registerPageController;

  GlobalKey<FormState> registerFormKeyPage1;
  final TextEditingController firstNameTextController;
  final TextEditingController lastNameTextController;
  final TextEditingController mobileNumberTextController;
  final TextEditingController licenseTextController;
  String position;

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
      licenseTextController = TextEditingController(),
      registerFormKeyPage2 = GlobalKey<FormState>(),
      emailTextController = TextEditingController(),
      passwordTextController = TextEditingController(),
      position = null,
      super();
  

  @override
  void initListeners() {
    // register user
    registerPresenter.registerUserOnNext = () {
      print('register user on next');
      refreshUI();
    };

    registerPresenter.registerUserOnComplete = () {
      print('register user on complete');
      Loader.hide();
      clearTextController();
      registerUserSuccess();
      refreshUI();
    };

    registerPresenter.registerUserOnError = (e) {
      print('register user on error $e');
      Loader.hide();
      _statusDialog(false, '${e.toString()}');
      refreshUI();
    };
  }

  setPosition(value){
    print('setposition $value');
    position = value;
  }

  void clearTextController(){
    firstNameTextController.clear();
    lastNameTextController.clear();
    emailTextController.clear();
    passwordTextController.clear();
  }

  void register() {
    Loader.show(getContext());

    Future.delayed(Duration(seconds: 1), () {
      registerPresenter.registerUser(firstNameTextController.text, lastNameTextController.text, emailTextController.text, passwordTextController.text);
    });
  }

  _statusDialog(bool status, String text){
    statusDialog(getContext(), status, text);
  }

  registerUserSuccess(){
    return showDialog(
      context: getContext(),
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)),
          title: Text('Registration Success!', style: TextStyle(fontSize: 15.0)),
          content: Text('You are successfully registered.', style: TextStyle(fontSize: 15.0)),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.pop(context);
              }
            ),
          ],
        );
      },
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
    emailTextController.dispose();
    passwordTextController.dispose();
    Loader.hide();
    super.onDisposed();
  }

}