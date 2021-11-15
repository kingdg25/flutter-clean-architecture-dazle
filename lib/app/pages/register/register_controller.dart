import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:dwellu/app/pages/register/register_presenter.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:dwellu/app/utils/app_constants.dart';


class RegisterController extends Controller {
  GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> get registerFormKey => _registerFormKey;

  PageController registerPageController;

  final TextEditingController _firstNameTextController;
  TextEditingController get firstNameTextController => _firstNameTextController;

  final TextEditingController _lastNameTextController;
  TextEditingController get lastNameTextController => _lastNameTextController;

  final TextEditingController _emailTextController;
  TextEditingController get emailTextController => _emailTextController;

  final TextEditingController _passwordTextController;
  TextEditingController get passwordTextController => _passwordTextController;

  final RegisterPresenter registerPresenter;

  RegisterController(userRepo)
    : registerPresenter = RegisterPresenter(userRepo),
      _registerFormKey = GlobalKey<FormState>(),
      _firstNameTextController = TextEditingController(),
      _lastNameTextController = TextEditingController(),
      _emailTextController = TextEditingController(),
      _passwordTextController = TextEditingController(),
      registerPageController = PageController(),
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

  void clearTextController(){
    _firstNameTextController.clear();
    _lastNameTextController.clear();
    _emailTextController.clear();
    _passwordTextController.clear();
  }

  void register() {
    Loader.show(getContext());

    Future.delayed(Duration(seconds: 1), () {
      registerPresenter.registerUser(_firstNameTextController.text, _lastNameTextController.text, _emailTextController.text, _passwordTextController.text);
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
    _firstNameTextController.dispose();
    _lastNameTextController.dispose();
    _emailTextController.dispose();
    _passwordTextController.dispose();
    Loader.hide();
    super.onDisposed();
  }

}