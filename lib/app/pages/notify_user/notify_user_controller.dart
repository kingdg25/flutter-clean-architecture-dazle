import 'package:dazle/app/pages/notify_user/notify_user_presenter.dart';
import 'package:dazle/app/pages/register/components/send_request_screen.dart';
import 'package:dazle/app/utils/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';


class NotifyUserController extends Controller {
  final NotifyUserPresenter notifyUserPresenter;

  GlobalKey<FormState> notifyUserFormKey;
  final TextEditingController emailTextController;
  final TextEditingController mobileNumberTextController;

  NotifyUserController(userRepo)
    : notifyUserPresenter = NotifyUserPresenter(userRepo),
      notifyUserFormKey = GlobalKey<FormState>(),
      emailTextController = TextEditingController(),
      mobileNumberTextController = TextEditingController(),
      super();


  @override
  void initListeners() {
    // notify user
    notifyUserPresenter.notifyUserOnNext = () {
      print('notify user on next');
    };

    notifyUserPresenter.notifyUserOnComplete = () {
      print('notify user on complete');
      AppConstant.showLoader(getContext(), false);
      Navigator.pop(getContext(), true);

      Navigator.push(
        getContext(),
        MaterialPageRoute(
          builder: (buildContext) => SendRequestScreen()
        )
      );
    };

    notifyUserPresenter.notifyUserOnError = (e) {
      print('notify user on error $e');
      AppConstant.showLoader(getContext(), false);
      
      if ( !e['error'] ) {
        _statusDialog('Oops!', '${e['status'] ?? ''}');
      }
      else{
        _statusDialog('Something went wrong', '${e.toString()}');
      } 
    };
  }

  void notifyUser(){
    AppConstant.showLoader(getContext(), true);

    notifyUserPresenter.notifyUser(
      email: emailTextController.text,
      mobileNumber: mobileNumberTextController.text
    );
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
    notifyUserPresenter.dispose(); // don't forget to dispose of the presenter
    
    emailTextController.dispose();
    mobileNumberTextController.dispose();

    Loader.hide();
    super.onDisposed();
  }
  
}