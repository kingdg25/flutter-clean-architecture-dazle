import 'package:dazle/app/pages/login/login_view.dart';
import 'package:dazle/app/pages/settings/settings_presenter.dart';
import 'package:dazle/app/utils/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';


class SettingsController extends Controller {
  final SettingsPresenter settingsPresenter;

  SettingsController(userRepo)
    : settingsPresenter = SettingsPresenter(userRepo),
      super();


  @override
  void initListeners() {
    // logout
    settingsPresenter.logoutUserOnNext = () {
      print('logout on next');
    };

    settingsPresenter.logoutUserOnComplete = () {
      print('logout on complete');
      AppConstant.showLoader(getContext(), false);
      loginPage();
    };

    settingsPresenter.logoutUserOnError = (e) {
      print('logout on error $e');
      AppConstant.showLoader(getContext(), false);
    };
  }


  void userLogout(){
    print('user logout home controller');
    AppConstant.showLoader(getContext(), true);

    settingsPresenter.logoutUser();
  }

  void loginPage() {
    Navigator.popAndPushNamed(getContext(), LoginPage.id);
  }



  @override
  void onResumed() => print('On resumed');

  @override
  void onReassembled() => print('View is about to be reassembled');

  @override
  void onDeactivated() => print('View is about to be deactivated');

  @override
  void onDisposed() {
    settingsPresenter.dispose(); // don't forget to dispose of the presenter
    Loader.hide();
    super.onDisposed();
  }
  
}