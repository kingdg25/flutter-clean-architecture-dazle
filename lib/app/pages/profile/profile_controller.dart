import 'package:dazle/app/pages/login/login_view.dart';
import 'package:dazle/app/pages/profile/profile_presenter.dart';
import 'package:dazle/app/utils/app.dart';
import 'package:dazle/app/utils/app_constant.dart';
import 'package:dazle/domain/entities/user.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';


class ProfileController extends Controller {
  final ProfilePresenter profilePresenter;

  User _user;
  User get user => _user;

  ProfileController(userRepo)
    : profilePresenter = ProfilePresenter(userRepo),
      super();


  @override
  void initListeners() {
    getCurrentUser();

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


  void userLogout(){
    print('user logout home controller');
    AppConstant.showLoader(getContext(), true);

    profilePresenter.logoutUser();
  }

  void loginPage() {
    Navigator.popAndPushNamed(getContext(), LoginPage.id);
  }

  getCurrentUser() async {
    User user = await App.getUser();

    if (user != null){
      _user = user;

      refreshUI();
    }
  }



  @override
  void onResumed() => print('On resumed');

  @override
  void onReassembled() => print('View is about to be reassembled');

  @override
  void onDeactivated() => print('View is about to be deactivated');

  @override
  void onDisposed() {
    profilePresenter.dispose(); // don't forget to dispose of the presenter
    super.onDisposed();
  }
  
}