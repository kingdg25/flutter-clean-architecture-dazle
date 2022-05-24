import 'dart:async';

import 'package:dazle/app/pages/profile/components/profile_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';

import '../../../data/repositories/data_profile_repository.dart';
import '../../../domain/entities/property.dart';
import '../../../domain/entities/user.dart';
import '../../utils/app.dart';
import '../../utils/app_constant.dart';
import '../edit_profile/edit_profile_view.dart';
import '../login/login_view.dart';
import 'profile_presenter.dart';

class ProfileController extends Controller {
  final ProfilePresenter profilePresenter;

  final uidToDisplay;
  User? _currentUser;
  User? _userToDisplay;
  List<Property>? _listings;

  User? get currentUser => _currentUser;
  User? get userToDisplay => _userToDisplay;
  List<Property>? get listings => _listings;
  Timer? _timer;

  /*


   */

  MediaQueryData? _mediaQueryData;
  double? screenWidth;
  double? screenHeight;
  double? defaultSize;
  static Orientation? orientation;

  ProfileController({DataProfileRepository? dataProfileRepo, this.uidToDisplay})
      : profilePresenter = ProfilePresenter(),
        super();

  @override
  void initListeners() async {
    await getCurrentUser();
    await getUserToDisplay();
    await getListings();
    App.configLoading();
    _mediaQueryData = MediaQuery.of(getContext());
    screenWidth = _mediaQueryData!.size.width;
    screenHeight = _mediaQueryData!.size.height;
    orientation = _mediaQueryData!.orientation;
    const oneSec = Duration(seconds: 10);
    _timer = Timer.periodic(oneSec, (Timer t) async {
      await getListings();
    });

    profilePresenter.getUserListingOnNext = (listings) {
      // print("On nextttt profile presenter LISTINGSSSSS");
      // print(listings);
      _listings = listings;
      refreshUI();
    };
    profilePresenter.getUserListingOnComplete = () {
      print("On comlete profile presenter");
    };
    profilePresenter.getUserListingOnError = () {
      print("On error profile presenter");
      // AppConstant.statusDialog(
      //     context: getContext(),
      //     text: "Can't fetch listings for this time.",
      //     title: "Can't fetch listings");
    };

    // logout
    profilePresenter.logoutUserOnNext = () {
      print('logout on next');
    };

    profilePresenter.logoutUserOnComplete = () {
      print('logout on complete');
      AppConstant.showLoader(getContext(), false);
      loginPage();
    };

    profilePresenter.logoutUserOnError = (e) {
      print('logout on error $e');
      AppConstant.showLoader(getContext(), false);
    };
  }

  void loginPage() {
    Navigator.popAndPushNamed(getContext(), LoginPage.id);
  }

  void profilePage() {
    Navigator.push(
        getContext(),
        MaterialPageRoute(
            builder: (context) => ProfileWidget(
                  user: _userToDisplay,
                  listings: _listings,
                )));
  }

  void editProfile() {
    Navigator.push(
      getContext(),
      MaterialPageRoute(
        builder: (buildContext) => EditProfilePage(
          user: _currentUser,
        ),
      ),
    );
  }

  double getProportionateScreenWidth(double inputWidth) {
    double? screenW = screenWidth;
    // As if 375
    return (inputWidth / 275.0) * screenW!;
  }

  double getProportionateScreenHeight(double inputHeight) {
    double? screenH = screenHeight;
    // as if 812
    return (inputHeight / 812.0) * screenH!;
  }

  getCurrentUser() async {
    User user = await App.getUser();

    _currentUser = user;

    refreshUI();
  }

  getUserToDisplay() async {
    if (this.uidToDisplay == null) {
      _userToDisplay = _currentUser;
    }
  }

  getListings() async {
    profilePresenter.getUserListing(this._userToDisplay!.id);
  }

  void comingSoon() {
    EasyLoading.showInfo('Coming Soon.');
  }

  void signOut() {
    print('user logout home controller');
    AppConstant.showLoader(getContext(), true);

    profilePresenter.logoutUser();
  }

  @override
  void onResumed() => print('On resumed');

  @override
  void onReassembled() => print('View is about to be reassembled');

  @override
  void onDeactivated() => print('View is about to be deactivated');

  @override
  void onDisposed() {
    _timer?.cancel();
    profilePresenter.dispose(); // don't forget to dispose of the presenter
    Loader.hide();
    super.onDisposed();
  }
}
