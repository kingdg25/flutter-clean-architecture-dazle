import 'package:dazle/domain/usecases/settings/logout_user_usecase.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class SettingsPresenter extends Presenter {
  Function? logoutUserOnNext;
  Function? logoutUserOnComplete;
  Function? logoutUserOnError;

  final LogoutUserUseCase logoutUserUseCase;

  SettingsPresenter(userRepo)
    : logoutUserUseCase = LogoutUserUseCase();

  void logoutUser(){
    logoutUserUseCase.execute(_LogoutUserUseCaseObserver(this), LogoutUserUseCaseParams());
  }

  @override
  void dispose() {
    logoutUserUseCase.dispose();
  }
}


class _LogoutUserUseCaseObserver extends Observer<LogoutUserUseCaseResponse> {
  final SettingsPresenter presenter;
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