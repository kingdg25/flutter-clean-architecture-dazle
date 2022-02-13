import 'dart:io';

import 'package:dazle/app/pages/verify_profile/verify_profile_presenter.dart';
import 'package:dazle/app/utils/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:dazle/app/pages/profile/profile_view.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class VerifyProfileController extends Controller {
  final VerifyProfilePresenter verifyProfilePresenter;

  File? attachement; // image

  VerifyProfileController(userRepo)
      : verifyProfilePresenter = VerifyProfilePresenter(userRepo),
        super();

  @override
  void initListeners() {
    // request verification
    verifyProfilePresenter.requestVerificationOnNext = (verification) async {
      print('Request Verificaiton on nexxt $verification');
      AppConstant.showLoader(getContext(), false);
      await await _statusDialog(
          'Done!', 'Your Request for verificaiton has been submitted.');
      Navigator.pop(getContext());

      if (verification != null) {
        Navigator.push(getContext(),
            MaterialPageRoute(builder: (buildContext) => ProfilePage()));
      }
    };

    verifyProfilePresenter.requestVerificationOnComplete = () async {
      print('Reqeust Verification on complete');
      AppConstant.showLoader(getContext(), false);
    };

    verifyProfilePresenter.requestVerificationOnError = (e) {
      print('Request Verification on error $e');
      AppConstant.showLoader(getContext(), false);

      if (!e['error']) {
        if (e['error_type'] == "filesize_error") {
          _statusDialog('File size error.', '${e['status'] ?? ''}');
        } else {
          _statusDialog('Oops!', '${e['status'] ?? ''}');
        }
      } else {
        _statusDialog('Something went wrong', '${e.toString()}');
      }
    };
  }

  void createRequestVerificaiton() async {
    if (attachement != null) {
      AppConstant.showLoader(getContext(), true);

      verifyProfilePresenter.requestVerification(attachment: attachement);
    } else {
      _statusDialog('No files Selected!',
          'Please take a picture or upload a photo from your device.');
    }
  }

  Future _statusDialog(String title, String text,
      {bool? success, Function? onPressed}) async {
    return await AppConstant.statusDialog(
        context: getContext(),
        success: success ?? false,
        title: title,
        text: text,
        onPressed: onPressed);
  }

  @override
  void onResumed() => print('On resumed');

  @override
  void onReassembled() => print('View is about to be reassembled');

  @override
  void onDeactivated() => print('View is about to be deactivated');

  @override
  void onDisposed() {
    verifyProfilePresenter
        .dispose(); // don't forget to dispose of the presenter
    super.onDisposed();
  }
}
