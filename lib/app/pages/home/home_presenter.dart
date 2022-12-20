import 'package:dazle/data/repositories/data_listing_repository.dart';

import 'package:dazle/domain/usecases/home/get_matched_properties_usecase.dart';
import 'package:dazle/domain/usecases/home/get_new_homes_usecase.dart';
import 'package:dazle/domain/usecases/home/get_spot_light_usecase.dart';
import 'package:dazle/domain/usecases/home/get_why_brooky_usecase.dart';
import 'package:dazle/domain/usecases/home/is_new_user_usecase.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:dazle/domain/usecases/get_user_usecase.dart';
import 'package:dazle/domain/usecases/listing/get_my_listing_usecase.dart';
import 'package:dazle/domain/usecases/settings/logout_user_usecase.dart';

class HomePresenter extends Presenter {
  Function? getUserOnNext;
  Function? getUserOnComplete;
  Function? getUserOnError;

  Function? isNewUserOnNext;
  Function? isNewUserOnComplete;
  Function? isNewUserOnError;

  Function? getSpotLightOnNext;
  Function? getSpotLightOnComplete;
  Function? getSpotLightOnError;

  Function? getMatchedPropertiesOnNext;
  Function? getMatchedPropertiesOnComplete;
  Function? getMatchedPropertiesOnError;

  Function? getWhyBrookyOnNext;
  Function? getWhyBrookyOnComplete;
  Function? getWhyBrookyOnError;

  Function? getNewHomesOnNext;
  Function? getNewHomesOnComplete;
  Function? getNewHomesOnError;

  Function? getMyListingOnNext;
  Function? getMyListingOnComplete;
  Function? getMyListingOnError;

  Function? logoutUserOnNext;
  Function? logoutUserOnComplete;
  Function? logoutUserOnError;

  final GetUserUseCase getUserUseCase;
  final IsNewUserUseCase isNewUserUseCase;

  final GetSpotLightUseCase getSpotLightUseCase;
  final GetMatchedPropertiesUseCase getMatchedPropertiesUseCase;
  final GetWhyBrookyUseCase getWhyBrookyUseCase;
  final GetNewHomesUseCase getNewHomesUseCase;
  final GetMyListingUseCase getMyListingUseCase;
  final LogoutUserUseCase logoutUserUseCase;

  HomePresenter(userRepo)
      : getUserUseCase = GetUserUseCase(),
        isNewUserUseCase = IsNewUserUseCase(userRepo),
        getSpotLightUseCase = GetSpotLightUseCase(userRepo),
        getMatchedPropertiesUseCase = GetMatchedPropertiesUseCase(userRepo),
        getWhyBrookyUseCase = GetWhyBrookyUseCase(userRepo),
        getNewHomesUseCase = GetNewHomesUseCase(userRepo),
        getMyListingUseCase = GetMyListingUseCase(DataListingRepository()),
        logoutUserUseCase = LogoutUserUseCase(); // TODO: Change data repo

  void getUser() {
    getUserUseCase.execute(
        _GetUserUseCaseObserver(this), GetUserUseCaseParams());
  }

  void isNewUser({String? email, bool? isNewUser}) {
    isNewUserUseCase.execute(_IsNewUserUseCaseObserver(this),
        IsNewUserUseCaseParams(email, isNewUser));
  }

  void getSpotLight() {
    getSpotLightUseCase.execute(
        _GetSpotLightUseCaseObserver(this), GetSpotLightUseCaseParams());
  }

  void getMatchedProperties() {
    getMatchedPropertiesUseCase.execute(
        _GetMatchedPropertiesUseCaseObserver(this),
        GetMatchedPropertiesUseCaseParams());
  }

  void getWhyBrooky() {
    getWhyBrookyUseCase.execute(
        _GetWhyBrookyUseCaseObserver(this), GetWhyBrookyUseCaseParams());
  }

  void getNewHomes() {
    getNewHomesUseCase.execute(
        _GetNewHomesUseCaseObserver(this), GetNewHomesUseCaseParams());
  }

  void getMyListing() {
    getMyListingUseCase.execute(
        _GetMyListingUseCaseObserver(this), GetMyListingUseCaseParams());
  }

  void logoutUser() {
    logoutUserUseCase.execute(
        _LogoutUserUseCaseObserver(this), LogoutUserUseCaseParams());
  }

  @override
  void dispose() {
    getUserUseCase.dispose();
    isNewUserUseCase.dispose();

    getSpotLightUseCase.dispose();
    getMatchedPropertiesUseCase.dispose();
    getWhyBrookyUseCase.dispose();
    getNewHomesUseCase.dispose();
  }
}

class _GetUserUseCaseObserver extends Observer<GetUserUseCaseResponse> {
  final HomePresenter presenter;
  _GetUserUseCaseObserver(this.presenter);
  @override
  void onComplete() {
    assert(presenter.getUserOnComplete != null);
    presenter.getUserOnComplete!();
  }

  @override
  void onError(e) {
    assert(presenter.getUserOnError != null);
    presenter.getUserOnError!(e);
  }

  @override
  void onNext(response) {
    assert(presenter.getUserOnNext != null);
    presenter.getUserOnNext!(response?.user);
  }
}

class _IsNewUserUseCaseObserver extends Observer<void> {
  final HomePresenter presenter;
  _IsNewUserUseCaseObserver(this.presenter);

  @override
  void onComplete() {
    assert(presenter.isNewUserOnComplete != null);
    presenter.isNewUserOnComplete!();
  }

  @override
  void onError(e) {
    assert(presenter.isNewUserOnError != null);
    presenter.isNewUserOnError!(e);
  }

  @override
  void onNext(response) {}
}

class _GetSpotLightUseCaseObserver
    extends Observer<GetSpotLightUseCaseResponse> {
  final HomePresenter presenter;
  _GetSpotLightUseCaseObserver(this.presenter);
  @override
  void onComplete() {
    assert(presenter.getSpotLightOnComplete != null);
    presenter.getSpotLightOnComplete!();
  }

  @override
  void onError(e) {
    assert(presenter.getSpotLightOnError != null);
    presenter.getSpotLightOnError!(e);
  }

  @override
  void onNext(response) {
    assert(presenter.getSpotLightOnNext != null);
    presenter.getSpotLightOnNext!(response?.spotLight);
  }
}

class _GetMatchedPropertiesUseCaseObserver
    extends Observer<GetMatchedPropertiesUseCaseResponse> {
  final HomePresenter presenter;
  _GetMatchedPropertiesUseCaseObserver(this.presenter);
  @override
  void onComplete() {
    assert(presenter.getMatchedPropertiesOnComplete != null);
    presenter.getMatchedPropertiesOnComplete!();
  }

  @override
  void onError(e) {
    assert(presenter.getMatchedPropertiesOnError != null);
    presenter.getMatchedPropertiesOnError!(e);
  }

  @override
  void onNext(response) {
    assert(presenter.getMatchedPropertiesOnNext != null);
    presenter.getMatchedPropertiesOnNext!(response?.matchedProperties);
  }
}

class _GetWhyBrookyUseCaseObserver
    extends Observer<GetWhyBrookyUseCaseResponse> {
  final HomePresenter presenter;
  _GetWhyBrookyUseCaseObserver(this.presenter);
  @override
  void onComplete() {
    assert(presenter.getWhyBrookyOnComplete != null);
    presenter.getWhyBrookyOnComplete!();
  }

  @override
  void onError(e) {
    assert(presenter.getWhyBrookyOnError != null);
    presenter.getWhyBrookyOnError!(e);
  }

  @override
  void onNext(response) {
    assert(presenter.getWhyBrookyOnNext != null);
    presenter.getWhyBrookyOnNext!(response?.whyBrooky);
  }
}

class _GetNewHomesUseCaseObserver extends Observer<GetNewHomesUseCaseResponse> {
  final HomePresenter presenter;
  _GetNewHomesUseCaseObserver(this.presenter);
  @override
  void onComplete() {
    assert(presenter.getNewHomesOnComplete != null);
    presenter.getNewHomesOnComplete!();
  }

  @override
  void onError(e) {
    assert(presenter.getNewHomesOnError != null);
    presenter.getNewHomesOnError!(e);
  }

  @override
  void onNext(response) {
    assert(presenter.getNewHomesOnNext != null);
    presenter.getNewHomesOnNext!(response?.newHomes);
  }
}

class _GetMyListingUseCaseObserver
    extends Observer<GetMyListingUseCaseResponse> {
  final HomePresenter presenter;
  _GetMyListingUseCaseObserver(this.presenter);
  @override
  void onComplete() {
    assert(presenter.getMyListingOnComplete != null);
    presenter.getMyListingOnComplete!();
  }

  @override
  void onError(e) {
    assert(presenter.getMyListingOnError != null);
    presenter.getMyListingOnError!(e);
  }

  @override
  void onNext(response) {
    assert(presenter.getMyListingOnNext != null);
    presenter.getMyListingOnNext!(response!.myListing);
  }
}

class _LogoutUserUseCaseObserver extends Observer<LogoutUserUseCaseResponse> {
  final HomePresenter presenter;
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
