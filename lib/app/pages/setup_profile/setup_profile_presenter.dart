import 'package:dazle/domain/usecases/authentication/setup_profile_usecase.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';


class SetupProfilePresenter extends Presenter {
  Function? setupProfileOnNext;
  Function? setupProfileOnComplete;
  Function? setupProfileOnError;

  final SetupProfileUseCase setupProfileUseCase;
  
  SetupProfilePresenter(userRepo) 
    : setupProfileUseCase = SetupProfileUseCase(userRepo);
  

  void setupProfile({
    String? firstName,
    String? lastName,
    String? mobileNumber,
    String? position,
    String? brokerLicenseNumber,
    String? email
  }) {
    setupProfileUseCase.execute(_SetupProfileUseCaseObserver(this), SetupProfileUseCaseParams(
      firstName,
      lastName,
      mobileNumber,
      position,
      brokerLicenseNumber,
      email
    ));
  }

  @override
  void dispose() {
    setupProfileUseCase.dispose();
  }
}


class _SetupProfileUseCaseObserver extends Observer<SetupProfileUseCaseResponse> {
  final SetupProfilePresenter presenter;
  _SetupProfileUseCaseObserver(this.presenter);
  
  @override
  void onComplete() {
    assert(presenter.setupProfileOnComplete != null);
    presenter.setupProfileOnComplete!();
  }

  @override
  void onError(e) {
    assert(presenter.setupProfileOnError != null);
    presenter.setupProfileOnError!(e);
  }

  @override
  void onNext(response) {
    assert(presenter.setupProfileOnNext != null);
    presenter.setupProfileOnNext!(response!.user);
  }
}