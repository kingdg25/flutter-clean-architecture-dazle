import 'dart:async';

import 'package:dazle/app/pages/home/welcome/welcome_page.dart';
import 'package:dazle/app/utils/app.dart';
import 'package:dazle/domain/entities/todo_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:dazle/app/pages/home/home_view.dart';
import 'package:dazle/app/pages/login/login_presenter.dart';
import 'package:dazle/app/pages/login/login_view.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:dazle/app/utils/app_constant.dart';
import 'package:pin_code_fields/pin_code_fields.dart';



class LoginController extends Controller {
  final LoginPresenter loginPresenter;

  /// for login
  GlobalKey<FormState> loginFormKey;
  final TextEditingController emailTextController;
  final TextEditingController passwordTextController;


  /// forgot password
  PageController forgotPasswordPageController;

  GlobalKey<FormState> forgotPasswordFormKey;
  final TextEditingController forgotPasswordEmailTextController;
  
  /// verify code
  String verificationCode;
  bool resendVerificationCode;
  TextEditingController verificationCodeTextController;
  StreamController<ErrorAnimationType> verificationCodeErrorController;

  /// reset password
  GlobalKey<FormState> resetPasswordFormKey;
  final TextEditingController resetPasswordTextController;


  LoginController(userRepo)
    : loginPresenter = LoginPresenter(userRepo),
    loginFormKey = GlobalKey<FormState>(),
    emailTextController = TextEditingController(),
    passwordTextController = TextEditingController(),
    forgotPasswordPageController = PageController(),
    forgotPasswordFormKey = GlobalKey<FormState>(),
    forgotPasswordEmailTextController = TextEditingController(),
    verificationCode = '',
    resendVerificationCode = false,
    verificationCodeTextController = TextEditingController(),
    verificationCodeErrorController = StreamController<ErrorAnimationType>(),
    resetPasswordFormKey = GlobalKey<FormState>(),
    resetPasswordTextController = TextEditingController(),
    super();
  

  @override
  void initListeners() {
    // Initialize presenter listeners here
    // These will be called upon success, failure, or data retrieval after usecase execution
    loginPresenter.isAuthenticated();
    loginPresenter.isAuthenticatedOnNext = (bool res) async {
      print('current user on next $res ${res.toString()}');
      if (res){

        TodoUser _user = await App.getUser();
      
        if ( _user.isNewUser != null && _user.isNewUser ) {
          welcomePage();
        }
        else {
          homePage();
        }
      
      }
    };

    loginPresenter.isAuthenticatedOnComplete = () {
      print('current user on complete');
    };

    loginPresenter.isAuthenticatedOnError = (e) {
      print('current user on error $e');
    };


    //login
    loginPresenter.loginUserOnNext = (TodoUser res) {
      print('login user on next $res ${res.toString()}');
      if (res != null){
        if ( res.isNewUser ) {
          welcomePage();
        }
        else {
          homePage();
        }
      }
    };

    loginPresenter.loginUserOnComplete = () {
      print('login user on complete');
      Loader.hide();
    };

    loginPresenter.loginUserOnError = (e) {
      print('login user on error $e');
      Loader.hide();

      if ( !e['error'] ) {
        _statusDialog(false, 'Oops!', '${e['status'] ?? ''}');
      }
      else{
        _statusDialog(false, 'Something went wrong', '${e.toString()}');
      } 
    };


    //forgot password
    loginPresenter.forgotPasswordOnNext = (res) {
      print('forgot pass on next $res ${res.toString()}');
      verificationCode = res;
      
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
      
      if ( !e['error'] ) {
        _statusDialog(false, 'Oops!', '${e['status'] ?? ''}');
      }
      else{
        _statusDialog(false, 'Something went wrong', '${e.toString()}');
      } 
    };


    //reset password
    loginPresenter.resetPasswordOnNext = (res) {
      print('reset pass on next $res ${res.toString()}');
    };

    loginPresenter.resetPasswordOnComplete = () {
      print('reset pass on complete');
      Loader.hide();
      Navigator.pop(getContext());

      _statusDialog(true, 'Success!', 'You successfully Change the Password.');
    };

    loginPresenter.resetPasswordOnError = (e) {
      print('reset pass on error $e');
      Loader.hide();
      
      if ( !e['error'] ) {
        _statusDialog(false, 'Oops!', '${e['status'] ?? ''}');
      }
      else{
        _statusDialog(false, 'Something went wrong', '${e.toString()}');
      } 
    };



    //social login
    loginPresenter.socialLoginOnNext = (res) {
      print('social login on next $res ${res.toString()}');
      if (res != null){
        homePage();
        print('HOOOOMMMEEE PPAAGE');
      }
    };

    loginPresenter.socialLoginOnComplete = () {
      print('social login on complete');
      Loader.hide();
    };

    loginPresenter.socialLoginOnError = (e) {
      print('social login on error $e');
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
    loginPresenter.dispose(); // don't forget to dispose of the presenter
    verificationCodeErrorController.close();
    emailTextController.dispose();
    passwordTextController.dispose();
    forgotPasswordPageController.dispose();
    Loader.hide();
    super.onDisposed();
  }

  void login() async {
    print('login ${emailTextController.text} ${passwordTextController.text}');
    Loader.show(getContext());

    loginPresenter.loginUser(emailTextController.text, passwordTextController.text);
  }

  void homePage() {
    Navigator.popAndPushNamed(getContext(), HomePage.id);
  }

  void welcomePage() {
    Navigator.popAndPushNamed(getContext(), WelcomePage.id);
  }

  void loginPage() {
    Navigator.popAndPushNamed(getContext(), LoginPage.id);
  }

  void forgotPassword({bool resend = false}) {
    print('forgot password ${forgotPasswordEmailTextController.text}');
    Loader.show(getContext());

    resendVerificationCode = resend;

    loginPresenter.forgotPassword(forgotPasswordEmailTextController.text);
  }

  void verifyCode() {
    var userInputCode = verificationCodeTextController.text;
    print('verify code: $verificationCode, user code input: $userInputCode');
    
    if (userInputCode.length != 4 || userInputCode != verificationCode) {
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
    print('reset password ${forgotPasswordEmailTextController.text} ${verificationCodeTextController.text} ${resetPasswordTextController.text}');
    Loader.show(getContext());

    loginPresenter.resetPassword(forgotPasswordEmailTextController.text, verificationCodeTextController.text, resetPasswordTextController.text);
  }


  void googleSignIn() {
    Loader.show(getContext());

    loginPresenter.socialLogin('gmail');
  }

  void facebookSignIn() {
    Loader.show(getContext());

    loginPresenter.socialLogin('facebook');
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