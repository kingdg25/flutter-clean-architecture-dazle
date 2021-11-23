import 'package:dazle/domain/usecases/authentication/update_user_usecase.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';


class SetupProfilePresenter extends Presenter {
  Function setupProfileOnNext;
  Function setupProfileOnComplete;
  Function setupProfileOnError;

  final UpdateUserUseCase updateUserUseCase;
  
  SetupProfilePresenter(userRepo) 
    : updateUserUseCase = UpdateUserUseCase(userRepo);
  

  void updateUser(
    String firstName,
    String lastName,
    String mobileNumber,
    String position,
    String licenseNumber,
    String email
  ) {
    updateUserUseCase.execute(_UpdateUserUseCaseObserver(this), UpdateUserUseCaseParams(
      firstName,
      lastName,
      mobileNumber,
      position,
      licenseNumber,
      email
    ));
  }

  @override
  void dispose() {
    updateUserUseCase.dispose();
  }
}


class _UpdateUserUseCaseObserver extends Observer<UpdateUserUseCaseResponse> {
  final SetupProfilePresenter presenter;
  _UpdateUserUseCaseObserver(this.presenter);
  @override

  void onComplete() {
    assert(presenter.setupProfileOnComplete != null);
    presenter.setupProfileOnComplete();
  }

  @override
  void onError(e) {
    assert(presenter.setupProfileOnError != null);
    presenter.setupProfileOnError(e);
  }

  @override
  void onNext(response) {
    assert(presenter.setupProfileOnNext != null);
    presenter.setupProfileOnNext(response.user);
  }
}