import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:dazle/domain/usecases/authentication/register_user_usecase.dart';

class RegisterPresenter extends Presenter {
  Function registerUserOnNext;
  Function registerUserOnComplete;
  Function registerUserOnError;

  final RegisterUserUseCase registerUserUseCase;

  RegisterPresenter(userRepo)
    : registerUserUseCase = RegisterUserUseCase(userRepo);
  
  void registerUser({
    String firstName,
    String lastName,
    String mobileNumber,
    String position,
    String brokerLicenseNumber,
    String email,
    String password
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

  @override
  void dispose() {
    registerUserUseCase.dispose();
  }
  
}




class _RegisterUserUseCaseObserver extends Observer<void> {
  final RegisterPresenter presenter;
  _RegisterUserUseCaseObserver(this.presenter);
  @override
  void onComplete() {
    assert(presenter.registerUserOnComplete != null);
    presenter.registerUserOnComplete();
  }

  @override
  void onError(e) {
    assert(presenter.registerUserOnError != null);
    presenter.registerUserOnError(e);
  }

  @override
  void onNext(response) {
  }
}