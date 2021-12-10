import 'package:dazle/app/pages/main/main_view.dart';
import 'package:dazle/app/utils/app_constant.dart';
import 'package:dazle/domain/entities/photo_tile.dart';
import 'package:dazle/domain/entities/property.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:dazle/app/pages/home/home_presenter.dart';
import 'package:dazle/app/pages/login/login_view.dart';
import 'package:dazle/domain/entities/user.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';


class HomeController extends Controller {
  final HomePresenter homePresenter;

  User _user;
  User get user => _user;

  String _displayName;
  String get displayName => _displayName;

  List<PhotoTile> _spotLight;
  List<PhotoTile> get spotLight => _spotLight;

  List<Property> _matchedProperties;
  List<Property> get matchedProperties => _matchedProperties;

  List<PhotoTile> _whyBrooky;
  List<PhotoTile> get whyBrooky => _whyBrooky;

  List<Property> _newHomes;
  List<Property> get newHomes => _newHomes;


  HomeController(userRepo)
    : _displayName = '',
      _spotLight = <PhotoTile>[],
      _matchedProperties = <Property>[],
      _whyBrooky = <PhotoTile>[],
      _newHomes = <Property>[],
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
      AppConstant.showLoader(getContext(), false);
      loginPage();
    };

    homePresenter.logoutUserOnError = (e) {
      print('logout on error $e');
      AppConstant.showLoader(getContext(), false);
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

      mainPage();
    };

    homePresenter.isNewUserOnError = (e) {
      print('new user on error $e');
    };

    
    getData();

    // get spot light
    homePresenter.getSpotLightOnNext = (List<PhotoTile> res) {
      print('get spot light on next $res');
      if (res != null){
        _spotLight = res;
      }
    };

    homePresenter.getSpotLightOnComplete = () {
      print('get spot light on complete');
      refreshUI();
    };

    homePresenter.getSpotLightOnError = (e) {
      print('get spot light on error $e');
    };

    // get matched properties
    homePresenter.getMatchedPropertiesOnNext = (List<Property> res) {
      print('get matched properties on next $res');
      if (res != null){
        _matchedProperties = res;
      }
    };

    homePresenter.getMatchedPropertiesOnComplete = () {
      print('get matched properties on complete');
      refreshUI();
    };

    homePresenter.getMatchedPropertiesOnError = (e) {
      print('get matched properties on error $e');
    };

    // get why brooky
    homePresenter.getWhyBrookyOnNext = (List<PhotoTile> res) {
      print('get why brooky on next $res');
      if (res != null){
        _whyBrooky = res;
      }
    };

    homePresenter.getWhyBrookyOnComplete = () {
      print('get why brooky on complete');
      refreshUI();
    };

    homePresenter.getWhyBrookyOnError = (e) {
      print('get why brooky on error $e');
    };

    // get new homes
    homePresenter.getNewHomesOnNext = (List<Property> res) {
      print('get new homes on next $res');
      if (res != null){
        _newHomes = res;
      }
    };

    homePresenter.getNewHomesOnComplete = () {
      print('get new homes on complete');
      refreshUI();
    };

    homePresenter.getNewHomesOnError = (e) {
      print('get new homes on error $e');
    };

  }

  void getData() {
    homePresenter.getSpotLight();
    homePresenter.getMatchedProperties();

    homePresenter.getWhyBrooky();
    homePresenter.getNewHomes();
  }

  void isNewUser() {
    print('_user _user _user $_user ${_user.displayName} ${_user.isNewUser}');

    if ( _user != null ) {
      homePresenter.isNewUser(email: _user.email, isNewUser: false);
    }
  }

  void userLogout(){
    print('user logout home controller');
    AppConstant.showLoader(getContext(), true);

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
    Loader.hide();
    super.onDisposed();
  }
  
}