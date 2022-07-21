import 'dart:async';

import 'package:dazle/app/pages/forgot_password/forgot_password_presenter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:dazle/app/utils/app_constant.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ForgotPasswordController extends Controller {
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

  final ForgotPasswordPresenter forgotPasswordPresenter;

  ForgotPasswordController(userRepo)
      : forgotPasswordPresenter = ForgotPasswordPresenter(userRepo),
        forgotPasswordPageController = PageController(),
        forgotPasswordFormKey = GlobalKey<FormState>(),
        forgotPasswordEmailTextController = TextEditingController(),
        verificationCode = '',
        resendVerificationCode = false,
        verificationCodeTextController = TextEditingController(),
        verificationCodeErrorController =
            StreamController<ErrorAnimationType>(),
        resetPasswordFormKey = GlobalKey<FormState>(),
        resetPasswordTextController = TextEditingController(),
        super();

  @override
  void initListeners() {
    //forgot password
    forgotPasswordPresenter.forgotPasswordOnNext = (res) {
      print('forgot pass on next $res ${res.toString()}');
      verificationCode = res;

      if (res != null && !resendVerificationCode) {
        forgotPasswordPageController.nextPage(
            duration: Duration(milliseconds: 500), curve: Curves.ease);
      }
    };

    forgotPasswordPresenter.forgotPasswordOnComplete = () {
      print('forgot pass on complete');
      AppConstant.showLoader(getContext(), false);
    };

    forgotPasswordPresenter.forgotPasswordOnError = (e) {
      print('forgot pass on error $e');
      AppConstant.showLoader(getContext(), false);

      if (!e['error']) {
        _statusDialog(false, 'Oops!', '${e['status'] ?? ''}');
      } else {
        _statusDialog(false, 'Something went wrong', '${e.toString()}');
      }
    };

    //reset password
    forgotPasswordPresenter.resetPasswordOnNext = (res) {
      print('reset pass on next $res ${res.toString()}');
    };

    forgotPasswordPresenter.resetPasswordOnComplete = () {
      print('reset pass on complete');
      AppConstant.showLoader(getContext(), false);
      Navigator.pop(getContext());

      _statusDialog(true, 'Success!', 'You successfully Change the Password.');
    };

    forgotPasswordPresenter.resetPasswordOnError = (e) {
      print('reset pass on error $e');
      AppConstant.showLoader(getContext(), false);

      if (!e['error']) {
        _statusDialog(false, 'Oops!', '${e['status'] ?? ''}');
      } else {
        _statusDialog(false, 'Something went wrong', '${e.toString()}');
      }
    };
  }

  void forgotPassword({bool resend = false}) {
    print('forgot password ${forgotPasswordEmailTextController.text}');
    AppConstant.showLoader(getContext(), true);

    resendVerificationCode = resend;

    forgotPasswordPresenter.forgotPassword(
        email: forgotPasswordEmailTextController.text);
  }

  void verifyCode() {
    var userInputCode = verificationCodeTextController.text;
    print('verify code: $verificationCode, user code input: $userInputCode');

    if (userInputCode.length != 4 || userInputCode != verificationCode) {
      verificationCodeErrorController
          .add(ErrorAnimationType.shake); // Triggering error shake animation
    } else {
      forgotPasswordPageController.nextPage(
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    }
  }

  void resetPassword() {
    print(
        'reset password ${forgotPasswordEmailTextController.text} ${verificationCodeTextController.text} ${resetPasswordTextController.text}');
    AppConstant.showLoader(getContext(), true);

    forgotPasswordPresenter.resetPassword(
        email: forgotPasswordEmailTextController.text,
        code: verificationCodeTextController.text,
        password: resetPasswordTextController.text);
  }

  _statusDialog(bool success, String title, String text) {
    AppConstant.statusDialog(
      context: getContext(),
      success: success,
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
    forgotPasswordPresenter
        .dispose(); // don't forget to dispose of the presenter

    verificationCodeErrorController.close();
    forgotPasswordPageController.dispose();

    Loader.hide();
    super.onDisposed();
  }
}
