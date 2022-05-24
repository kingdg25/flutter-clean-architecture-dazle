import 'package:dazle/data/repositories/data_listing_repository.dart';
import 'package:dazle/domain/usecases/profile/get_user_listings_usercase.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../../domain/usecases/settings/logout_user_usecase.dart';

class ProfilePresenter extends Presenter {
  Function? getUserListingOnNext;
  Function? getUserListingOnComplete;
  Function? getUserListingOnError;

  Function? logoutUserOnNext;
  Function? logoutUserOnComplete;
  Function? logoutUserOnError;

  final GetUserListingsUseCase getUserListingUseCase;

  final LogoutUserUseCase logoutUserUseCase;

  ProfilePresenter()
      : getUserListingUseCase = GetUserListingsUseCase(DataListingRepository()),
        logoutUserUseCase = LogoutUserUseCase();

  void getUserListing(uid) {
    getUserListingUseCase.execute(_GetUserListingUseCaseObserver(this),
        GetUserListingsUseCaseParams(uid: uid));
  }

  void logoutUser() {
    logoutUserUseCase.execute(
        _LogoutUserUseCaseObserver(this), LogoutUserUseCaseParams());
  }

  @override
  void dispose() {
    EasyLoading.dismiss();
    EasyLoading.removeAllCallbacks();
    logoutUserUseCase.dispose();
    getUserListingUseCase.dispose();
  }
}

class _GetUserListingUseCaseObserver
    extends Observer<GetUserListingsUseCaseResponse> {
  final ProfilePresenter presenter;

  _GetUserListingUseCaseObserver(this.presenter);

  @override
  void onComplete() {
    assert(presenter.getUserListingOnComplete != null);
    presenter.getUserListingOnComplete!();
  }

  @override
  void onError(e) {
    assert(presenter.getUserListingOnError != null);
    presenter.getUserListingOnError!();
  }

  @override
  void onNext(GetUserListingsUseCaseResponse? response) {
    assert(presenter.getUserListingOnNext != null);
    presenter.getUserListingOnNext!(response!.listings);
  }
}

class _LogoutUserUseCaseObserver extends Observer<LogoutUserUseCaseResponse> {
  final ProfilePresenter presenter;
  _LogoutUserUseCaseObserver(this.presenter);
  @override
  void onComplete() {
    assert(presenter.logoutUserOnComplete != null);
    presenter.logoutUserOnComplete!();
  }

  @override
  void onError(e) {
    assert(presenter.logoutUserOnError != null);
    presenter.logoutUserOnError!(e);
  }

  @override
  void onNext(response) {
    // assert(presenter.logoutUserOnNext != null);
    // presenter.logoutUserOnNext(response);
  }
}
