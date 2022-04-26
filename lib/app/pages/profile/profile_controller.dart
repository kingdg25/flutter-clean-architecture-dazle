import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../../../data/repositories/data_profile_repository.dart';
import '../../../domain/entities/property.dart';
import '../../../domain/entities/user.dart';
import '../../utils/app.dart';
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

  ProfileController({DataProfileRepository? dataProfileRepo, this.uidToDisplay})
      : profilePresenter = ProfilePresenter(),
        super();

  @override
  void initListeners() async {
    await getCurrentUser();
    await getUserToDisplay();
    await getListings();

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
  }

  getCurrentUser() async {
    User user = await App.getUser();

    if (user != null) {
      _currentUser = user;

      refreshUI();
    }
  }

  getUserToDisplay() async {
    if (this.uidToDisplay == null) {
      _userToDisplay = _currentUser;
    }
  }

  getListings() async {
    profilePresenter.getUserListing(this._userToDisplay!.id);
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
    super.onDisposed();
  }
}
