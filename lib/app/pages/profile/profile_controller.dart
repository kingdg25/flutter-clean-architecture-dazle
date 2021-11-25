import 'package:dazle/app/pages/profile/profile_presenter.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';


class ProfileController extends Controller {
  final ProfilePresenter profilePresenter;

  ProfileController(userRepo)
    : profilePresenter = ProfilePresenter(),
      super();


  @override
  void initListeners() {

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