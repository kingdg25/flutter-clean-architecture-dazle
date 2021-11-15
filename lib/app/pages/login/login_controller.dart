import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:dwellu/app/pages/home/home_view.dart';
import 'package:dwellu/app/pages/login/login_presenter.dart';
import 'package:dwellu/app/pages/login/login_view.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:dwellu/app/utils/app_constants.dart';
import 'package:pin_code_fields/pin_code_fields.dart';



class LoginController extends Controller {
  final LoginPresenter loginPresenter;

  GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> get loginFormKey => _loginFormKey;

  final TextEditingController _emailTextController;
  TextEditingController get emailTextController => _emailTextController;

  final TextEditingController _passwordTextController;
  TextEditingController get passwordTextController => _passwordTextController;

  PageController _resetPageController = PageController();
  PageController get resetPageController => _resetPageController;

  GlobalKey<FormState> _forgotPassFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> get forgotPassFormKey => _forgotPassFormKey;

  GlobalKey<FormState> _changePassFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> get changePassFormKey => _changePassFormKey;

  final TextEditingController _forgotEmailTextController;
  TextEditingController get forgotEmailTextController => _forgotEmailTextController;

  final TextEditingController _resetPasswordTextController;
  TextEditingController get resetPasswordTextController => _resetPasswordTextController;

  String _resetPassVerficationCode;
  String get resetPassVerificationCode => _resetPassVerficationCode;

  String _userVerficationCode;
  String get userVerificationCode => _userVerficationCode;
  set setUserVerificationCode (String value) => _userVerficationCode = value;

  PageController forgotPasswordPageController;

  GlobalKey<FormState> forgotPasswordFormKey;
  final TextEditingController forgotPasswordEmailTextController;
  
  bool resendVerificationCode;
  TextEditingController verificationCodeTextController;
  StreamController<ErrorAnimationType> verificationCodeErrorController;

  GlobalKey<FormState> resetPasswordFormKey;


  LoginController(userRepo)
    : loginPresenter = LoginPresenter(userRepo),
    _loginFormKey = GlobalKey<FormState>(),
    _emailTextController = TextEditingController(),
    _passwordTextController = TextEditingController(),
    _forgotPassFormKey = GlobalKey<FormState>(),
    _forgotEmailTextController = TextEditingController(),
    _resetPageController = PageController(),
    _resetPassVerficationCode = '',
    _userVerficationCode = '',
    _resetPasswordTextController = TextEditingController(),
    forgotPasswordPageController = PageController(),
    forgotPasswordFormKey = GlobalKey<FormState>(),
    forgotPasswordEmailTextController = TextEditingController(),
    resendVerificationCode = false,
    verificationCodeTextController = TextEditingController(),
    verificationCodeErrorController = StreamController<ErrorAnimationType>(),
    resetPasswordFormKey = GlobalKey<FormState>(),
    super();
  

  @override
  void initListeners() {
    // Initialize presenter listeners here
    // These will be called upon success, failure, or data retrieval after usecase execution
    loginPresenter.isAuthenticated();
    loginPresenter.isAuthenticatedOnNext = (bool res) {
      // var data = convert.jsonEncode(res);
      print('current user on next $res ${res.toString()}');
      if (res){
        print('HOOOOMMMEEE PPAAGE');
        homePage();
      }
      refreshUI();
    };

    loginPresenter.isAuthenticatedOnComplete = () {
      print('current user on complete');
    };

    loginPresenter.isAuthenticatedOnError = (e) {
      print('current user on error $e');
    };


    //login
    loginPresenter.loginUserOnNext = (res) {
      print('login user on next $res ${res.toString()}');
      if (res != null){
        homePage();
        print('HOOOOMMMEEE PPAAGE');
      }
      refreshUI();
    };

    loginPresenter.loginUserOnComplete = () {
      print('login user on complete');
      Loader.hide();
    };

    loginPresenter.loginUserOnError = (e) {
      print('login user on error $e');
      Loader.hide();
      _statusDialog(false, '${e.toString()}');
    };


    //forgot password
    loginPresenter.forgotPasswordOnNext = (res) {
      print('forgot pass on next $res ${res.toString()}');
      _resetPassVerficationCode = res;
      
      if (res != null && !resendVerificationCode) {
        forgotPasswordPageController.nextPage(
          duration: Duration(milliseconds: 500),
          curve: Curves.ease
        );
      }
    };

    loginPresenter.forgotPasswordOnComplete = () {
      print('forgot pass on complete');
      Loader.hide();
    };

    loginPresenter.forgotPasswordOnError = (e) {
      print('forgot pass on error $e');
      Loader.hide();
      _statusDialog(false, '${e.toString()}');
    };


    //reset password
    loginPresenter.resetPasswordOnNext = (res) {
      print('reset pass on next $res ${res.toString()}');
    };

    loginPresenter.resetPasswordOnComplete = () {
      print('reset pass on complete');
      Loader.hide();
      Navigator.pop(getContext());

      _statusDialog(true, 'Successfully Change Password.');
    };

    loginPresenter.resetPasswordOnError = (e) {
      print('reset pass on error $e');
      Loader.hide();
      _statusDialog(false, '${e.toString()}');
    };



    //social login
    loginPresenter.socialLoginOnNext = (res) {
      print('social login on next $res ${res.toString()}');
      if (res != null){
        homePage();
        print('HOOOOMMMEEE PPAAGE');
      }
      refreshUI();
    };

    loginPresenter.socialLoginOnComplete = () {
      print('social login on complete');
      Loader.hide();
    };

    loginPresenter.socialLoginOnError = (e) {
      print('social login on error $e');
      Loader.hide();
      _statusDialog(false, '${e.toString()}');
    };
  }

  @override
  void onDisposed() {
    loginPresenter.dispose(); // don't forget to dispose of the presenter
    verificationCodeErrorController.close();
    _emailTextController.dispose();
    _passwordTextController.dispose();
    _forgotEmailTextController.dispose();
    _resetPasswordTextController.dispose();
    forgotPasswordPageController.dispose();
    Loader.hide();
    super.onDisposed();
  }

  void clearTextController(){
    _emailTextController.clear();
    _passwordTextController.clear();
  }

  void login() async {
    print('login ${_emailTextController.text} ${_passwordTextController.text}');
    Loader.show(getContext());

    loginPresenter.loginUser(_emailTextController.text, _passwordTextController.text);
  }

  void homePage() {
    Navigator.popAndPushNamed(getContext(), HomePage.id);
  }

  void loginPage() {
    Navigator.popAndPushNamed(getContext(), LoginPage.id);
  }

  void forgotPassword({bool resend = false}) {
    print('forgot password ${_forgotEmailTextController.text}');
    Loader.show(getContext());

    resendVerificationCode = resend;

    loginPresenter.forgotPassword(_forgotEmailTextController.text);
  }

  void verifyCode() {
    print('verify code: $_resetPassVerficationCode user code input: $_userVerficationCode');
    print(verificationCodeTextController.text);
    var userInputCode = verificationCodeTextController.text;
    
    if (userInputCode.length != 4 || userInputCode != _resetPassVerficationCode) {
      verificationCodeErrorController.add(ErrorAnimationType.shake); // Triggering error shake animation
    }
    else{
      forgotPasswordPageController.nextPage(
        duration: Duration(milliseconds: 500),
        curve: Curves.ease
      );
    }
  }

  void resetPassword() {
    print('reset password ${_forgotEmailTextController.text} $_userVerficationCode ${_resetPasswordTextController.text}');
    Loader.show(getContext());

    loginPresenter.resetPassword(_forgotEmailTextController.text, verificationCodeTextController.text, _resetPasswordTextController.text);
  }


  void googleSignIn() {
    Loader.show(getContext());

    loginPresenter.socialLogin('gmail');
  }

  void facebookSignIn() {
    Loader.show(getContext());

    loginPresenter.socialLogin('facebook');
  }

  _statusDialog(bool status, String text){
    statusDialog(getContext(), status, text);
  }

}