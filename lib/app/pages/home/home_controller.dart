import 'package:dazle/app/pages/main/main_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:dazle/app/pages/home/home_presenter.dart';
import 'package:dazle/app/pages/login/login_view.dart';
import 'package:dazle/domain/entities/user.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';


class HomeController extends Controller {
  User _user;
  User get user => _user;

  String _displayName;
  String get displayName => _displayName;

  final HomePresenter homePresenter;

  HomeController(userRepo)
    : _displayName = '',
      homePresenter = HomePresenter(userRepo),
      super();


  @override
  void initListeners() {
    // logout
    homePresenter.logoutUserOnNext = () {
      print('logout on next');
    };

    homePresenter.logoutUserOnComplete = () {
      print('logout on complete');
      Loader.hide();
      loginPage();
    };

    homePresenter.logoutUserOnError = (e) {
      print('logout on error $e');
      Loader.hide();
    };

    homePresenter.getUser();
    // get user
    homePresenter.getUserOnNext = (User res) {
      print('get user on next $res ${res.displayName}');
      if(res != null) {
        _user = res;

        _displayName = res.displayName ?? res.email;
      }
      refreshUI();
    };

    homePresenter.getUserOnComplete = () {
      print('get user on complete');
    };

    homePresenter.getUserOnError = (e) {
      print('get user on error $e');
    };


    //new user or not
    homePresenter.isNewUserOnNext = (res) {
      print('new user on next $res');
    };

    homePresenter.isNewUserOnComplete = () {
      print('new user on complete');
      Loader.hide();

      mainPage();
    };

    homePresenter.isNewUserOnError = (e) {
      print('new user on error $e');
      Loader.hide();
    };

  }

  void isNewUser() {
    print('_user _user _user $_user ${_user.displayName} ${_user.isNewUser}');

    if ( _user != null ) {
      homePresenter.isNewUser(_user.email, false);
    }
  }

  void userLogout(){
    print('user logout home controller');
    homePresenter.logoutUser();
  }

  void mainPage() {
    Navigator.popAndPushNamed(getContext(), MainPage.id);
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
    homePresenter.dispose(); // don't forget to dispose of the presenter
    super.onDisposed();
  }
  
}