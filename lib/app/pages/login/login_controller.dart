import 'package:dazle/app/pages/email_verification/email_verification_view.dart';
import 'package:dazle/app/pages/main/main_view.dart';
import 'package:dazle/app/pages/notify_user/notify_user_view.dart';
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
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

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
    TheAppleSignIn.onCredentialRevoked?.listen((_) {
      print("Credentials revoked");
    });

    loginPresenter.isAuthenticated();
    loginPresenter.isAuthenticatedOnNext = (bool res) async {
      print('current user on next $res ${res.toString()}');
      if (res) {
        User _user = await App.getUser();

        print(_user.toJson());

        if (_user.position != null) {
          if (!(_user.emailVerified ?? false) && _user.id != null) {
            emailVerificationPage();
          } else if (_user.isNewUser != null && _user.isNewUser!) {
            welcomePage();
          } else {
            mainPage();

            //after login here
          }
        } else {
          setupProfilePage();
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
      // if (res != null) {
      if (!(res.emailVerified ?? false) && res.id != null) {
        emailVerificationPage();
      } else if (res.isNewUser!) {
        welcomePage();
      } else {
        mainPage();
      }
      // }
    };

    loginPresenter.loginUserOnComplete = () {
      print('login user on complete');
      AppConstant.showLoader(getContext(), false);
    };

    loginPresenter.loginUserOnError = (e) {
      print('login user on error $e');
      AppConstant.showLoader(getContext(), false);

      if (e is Map) {
        if (e.containsKey('error')) {
          if (!e['error']) {
            _statusDialog('Oops!', '${e['status'] ?? ''}');
          }
        }
      } else {
        _statusDialog('Something went wrong', '${e.toString()}');
      }
    };

    //social login
    loginPresenter.socialLoginOnNext = (User res) {
      print('social login on next $res ${res.toString()}');
      // if (res != null) {
      if (res.position != null) {
        if (!(res.emailVerified ?? false) && res.id != null) {
          emailVerificationPage();
        } else {
          print('HOOOOMMMEEE PPAAGE');
          mainPage();
        }
      } else {
        print('setup profile page');
        setupProfilePage();
      }
      // }
    };

    loginPresenter.socialLoginOnComplete = () {
      print('social login on complete');
      AppConstant.showLoader(getContext(), false);
    };

    loginPresenter.socialLoginOnError = (e) {
      print('social login on error $e');
      AppConstant.showLoader(getContext(), false);

      if (!e['error']) {
        if (e['error_type'] == "no_broker") {
          _statusDialog('Oops!', '${e['status'] ?? ''}', onPressed: () {
            Navigator.pop(getContext()); // pop dialog
            Navigator.pop(getContext()); // pop registration page

            Navigator.push(getContext(),
                MaterialPageRoute(builder: (buildContext) => NotifyUserPage()));
          });
        } else if (e['error_type'] == "no_setup_profile") {
          setupProfilePage();
        } else {
          _statusDialog('Oops!', '${e['status'] ?? ''}');
        }
      } else {
        _statusDialog('Something went wrong', '${e.toString()}');
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
    AppConstant.showLoader(getContext(), true);

    loginPresenter.loginUser(
        email: emailTextController.text, password: passwordTextController.text);
  }

  void mainPage() {
    Navigator.pushReplacementNamed(getContext(), MainPage.id);
  }

  void welcomePage() {
    Navigator.popAndPushNamed(getContext(), WelcomePage.id);
  }

  void setupProfilePage() {
    Navigator.push(getContext(),
        MaterialPageRoute(builder: (buildContext) => SetupProfilePage()));
  }

  void loginPage() {
    Navigator.popAndPushNamed(getContext(), LoginPage.id);
  }

  void emailVerificationPage() {
    Navigator.pushAndRemoveUntil(
        getContext(),
        MaterialPageRoute(
            builder: (BuildContext context) => EmailVerificationPage()),
        (Route<dynamic> route) => false);
  }

  void googleSignIn() {
    AppConstant.showLoader(getContext(), true);

    loginPresenter.socialLogin(loginType: 'gmail');
  }

  void facebookSignIn() {
    AppConstant.showLoader(getContext(), true);

    loginPresenter.socialLogin(loginType: 'facebook');
  }

  void appleSignIn() async {
    AppConstant.showLoader(getContext(), true);

    if (!(await TheAppleSignIn.isAvailable())) {
      AppConstant.showLoader(getContext(), false);
      return;
    }

    loginPresenter.socialLogin(loginType: 'apple');
  }

  _statusDialog(String title, String text,
      {bool? success, Function? onPressed}) {
    AppConstant.statusDialog(
        context: getContext(),
        success: success ?? false,
        title: title,
        text: text,
        onPressed: onPressed);
  }
}
