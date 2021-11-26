import 'package:dazle/app/pages/main/main_view.dart';
import 'package:dazle/app/pages/welcome/welcome_page.dart';
import 'package:dazle/app/pages/setup_profile/setup_profile_view.dart';
import 'package:dazle/app/utils/app.dart';
import 'package:dazle/domain/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:dazle/app/pages/login/login_presenter.dart';
import 'package:dazle/app/pages/login/login_view.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:dazle/app/utils/app_constant.dart';



class LoginController extends Controller {
  final LoginPresenter loginPresenter;

  /// for login
  GlobalKey<FormState> loginFormKey;
  final TextEditingController emailTextController;
  final TextEditingController passwordTextController;


  LoginController(userRepo)
    : loginPresenter = LoginPresenter(userRepo),
    loginFormKey = GlobalKey<FormState>(),
    emailTextController = TextEditingController(),
    passwordTextController = TextEditingController(),
    super();
  

  @override
  void initListeners() {
    // Initialize presenter listeners here
    // These will be called upon success, failure, or data retrieval after usecase execution
    loginPresenter.isAuthenticated();
    loginPresenter.isAuthenticatedOnNext = (bool res) async {
      print('current user on next $res ${res.toString()}');
      if (res){

        User _user = await App.getUser();
      
        if ( _user.isNewUser != null && _user.isNewUser ) {
          welcomePage();
        }
        else {
          mainPage();
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
    loginPresenter.loginUserOnNext = (User res) {
      print('login user on next $res ${res.toString()}');
      if (res != null){
        if ( res.isNewUser ) {
          welcomePage();
        }
        else {
          mainPage();
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


    //social login
    loginPresenter.socialLoginOnNext = (User res) {
      print('social login on next $res ${res.toString()}');
      if (res != null){
        if ( res.position != null && res.brokerLicenseNumber != null ) {
          print('HOOOOMMMEEE PPAAGE');
          mainPage();
        }
        else {
          print('setup profile page');
          setupProfilePage();
        }
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
    emailTextController.dispose();
    passwordTextController.dispose();
    Loader.hide();
    super.onDisposed();
  }

  void login() async {
    print('login ${emailTextController.text} ${passwordTextController.text}');
    Loader.show(getContext());

    loginPresenter.loginUser(email: emailTextController.text, password: passwordTextController.text);
  }

  void mainPage() {
    Navigator.popAndPushNamed(getContext(), MainPage.id);
  }

  void welcomePage() {
    Navigator.popAndPushNamed(getContext(), WelcomePage.id);
  }

  void setupProfilePage() {
    Navigator.push(
      getContext(),
      MaterialPageRoute(
        builder: (buildContext) => SetupProfilePage()
      )
    );
  }

  void loginPage() {
    Navigator.popAndPushNamed(getContext(), LoginPage.id);
  }

  void googleSignIn() {
    Loader.show(getContext());

    loginPresenter.socialLogin(type: 'gmail');
  }

  void facebookSignIn() {
    Loader.show(getContext());

    loginPresenter.socialLogin(type: 'facebook');
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