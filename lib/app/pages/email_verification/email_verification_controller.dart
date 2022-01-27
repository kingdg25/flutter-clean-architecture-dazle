
import 'package:dazle/app/pages/email_verification/email_verification_presenter.dart';
import 'package:dazle/app/utils/app_constant.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class EmailVerificationPageController extends Controller {
  final EmailVerificationPresenter emailVerificationPresenter;
  
  EmailVerificationPageController():
    emailVerificationPresenter = EmailVerificationPresenter(),
    super();

  @override
  void initListeners() {}


  resendEmailVerification(){
    _statusDialog("Send Verification", "Resend"); // TODO: resend verification link
  }


  _statusDialog(String title, String text, {bool success, Function onPressed}){
    AppConstant.statusDialog(
      context: getContext(),
      success: success ?? false,
      title: title,
      text: text,
      onPressed: onPressed
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
    super.onDisposed();
  }
}