import 'package:dazle/app/pages/login/login_view.dart';
import 'package:dazle/app/pages/profile/profile_presenter.dart';
import 'package:dazle/app/utils/app.dart';
import 'package:dazle/app/utils/app_constant.dart';
import 'package:dazle/data/repositories/data_profile_repository.dart';
import 'package:dazle/domain/entities/property.dart';
import 'package:dazle/domain/entities/user.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';


class ProfileController extends Controller {
  final ProfilePresenter profilePresenter;


  final uidToDisplay;
  User _currentUser;
  User _userToDisplay;
  List<Property> _listings;

  User get currentUser => _currentUser;
  User get userToDisplay => _userToDisplay;
  List<Property> get listings => _listings;

  ProfileController({DataProfileRepository dataProfileRepo, this.uidToDisplay})
    : profilePresenter = ProfilePresenter(),
      super();


  @override
  void initListeners() async {
    await getCurrentUser();
    await getUserToDisplay();
    await getListings();

    profilePresenter.getUserListingOnNext = (listings) {
      print("On nextttt profile presenter LISTINGSSSSS");
      print(listings);
      _listings = listings;
      refreshUI();
    };
    profilePresenter.getUserListingOnComplete = () {
      print("On comlete profile presenter");
      
    };
    profilePresenter.getUserListingOnError = () {
      print("On error profile presenter");
      AppConstant.statusDialog(context: getContext(), text: "Can't fetch listings for this time.", title: "Can't fetch listings");
    };

  }

  getCurrentUser() async {
    User user = await App.getUser();

    if (user != null){
      _currentUser = user;

      refreshUI();
    }
  }

  getUserToDisplay() async {
    if (this.uidToDisplay==null){
      _userToDisplay = _currentUser;
    }
  }

  getListings() async {
    profilePresenter.getUserListing(this._userToDisplay.id);
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