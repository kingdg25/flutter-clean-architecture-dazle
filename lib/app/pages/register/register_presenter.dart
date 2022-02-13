import 'package:dazle/domain/usecases/authentication/check_license_number_usecase.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:dazle/domain/usecases/authentication/register_user_usecase.dart';

class RegisterPresenter extends Presenter {
  Function? registerUserOnNext;
  Function? registerUserOnComplete;
  Function? registerUserOnError;

  Function? checkLicenseNumberOnNext;
  Function? checkLicenseNumberOnComplete;
  Function? checkLicenseNumberOnError;

  final RegisterUserUseCase registerUserUseCase;
  final CheckLicenseNumberUseCase checkLicenseNumberUseCase;

  RegisterPresenter(userRepo)
    : registerUserUseCase = RegisterUserUseCase(userRepo),
      checkLicenseNumberUseCase = CheckLicenseNumberUseCase(userRepo);
  
  void registerUser({
    String? firstName,
    String? lastName,
    String? mobileNumber,
    String? position,
    String? brokerLicenseNumber,
    String? email,
    String? password
  }) {
    registerUserUseCase.execute(_RegisterUserUseCaseObserver(this), RegisterUserUseCaseParams(
      firstName,
      lastName,
      mobileNumber,
      position,
      brokerLicenseNumber,
      email,
      password
    ));
  }

  void checkLicenseNumber({String? licenseNumber}){
    checkLicenseNumberUseCase.execute(_CheckLicenseNumberUseCaseObserver(this), CheckLicenseNumberUseCaseParams(licenseNumber));
  }

  @override
  void dispose() {
    registerUserUseCase.dispose();
    checkLicenseNumberUseCase.dispose();
  }
  
}


class _RegisterUserUseCaseObserver extends Observer<void> {
  final RegisterPresenter presenter;
  _RegisterUserUseCaseObserver(this.presenter);
  @override
  void onComplete() {
    assert(presenter.registerUserOnComplete != null);
    presenter.registerUserOnComplete!();
  }

  @override
  void onError(e) {
    assert(presenter.registerUserOnError != null);
    presenter.registerUserOnError!(e);
  }

  @override
  void onNext(response) {
  }
}


class _CheckLicenseNumberUseCaseObserver extends Observer<CheckLicenseNumberUseCaseResponse> {
  final RegisterPresenter presenter;
  _CheckLicenseNumberUseCaseObserver(this.presenter);
  @override
  void onComplete() {
    assert(presenter.checkLicenseNumberOnComplete != null);
    presenter.checkLicenseNumberOnComplete!();
  }

  @override
  void onError(e) {
    assert(presenter.checkLicenseNumberOnError != null);
    presenter.checkLicenseNumberOnError!(e);
  }

  @override
  void onNext(response) {
    assert(presenter.checkLicenseNumberOnNext != null);
    presenter.checkLicenseNumberOnNext!(response?.check);
  }
}