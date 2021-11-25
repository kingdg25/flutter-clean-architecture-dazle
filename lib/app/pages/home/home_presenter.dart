import 'package:dazle/domain/usecases/home/is_new_user_usecase.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:dazle/domain/usecases/authentication/get_user_usecase.dart';
import 'package:dazle/domain/usecases/home/logout_user_usecase.dart';


class HomePresenter extends Presenter {
  Function logoutUserOnNext;
  Function logoutUserOnComplete;
  Function logoutUserOnError;

  Function getUserOnNext;
  Function getUserOnComplete;
  Function getUserOnError;

  Function isNewUserOnNext;
  Function isNewUserOnComplete;
  Function isNewUserOnError;

  final LogoutUserUseCase logoutUserUseCase;
  final GetUserUseCase getUserUseCase;
  final IsNewUserUseCase newUserUseCase;

  HomePresenter(userRepo)
    : getUserUseCase = GetUserUseCase(),
      logoutUserUseCase = LogoutUserUseCase(userRepo),
      newUserUseCase = IsNewUserUseCase(userRepo);
  

  void logoutUser(){
    logoutUserUseCase.execute(_LogoutUserUseCaseObserver(this), LogoutUserUseCaseParams());
  }

  void getUser() {
    getUserUseCase.execute(_GetUserUseCaseObserver(this), GetUserUseCaseParams());
  }

  void isNewUser(String email, bool isNewUser) {
    newUserUseCase.execute(_IsNewUserUseCaseObserver(this), IsNewUserUseCaseParams(email, isNewUser));
  }


  @override
  void dispose() {
    logoutUserUseCase.dispose();
  }
}


class _LogoutUserUseCaseObserver extends Observer<LogoutUserUseCaseResponse> {
  final HomePresenter presenter;
  _LogoutUserUseCaseObserver(this.presenter);
  @override
  void onComplete() {
    assert(presenter.logoutUserOnComplete != null);
    presenter.logoutUserOnComplete();
  }

  @override
  void onError(e) {
    assert(presenter.logoutUserOnError != null);
    presenter.logoutUserOnError(e);
  }

  @override
  void onNext(response) {
    // assert(presenter.logoutUserOnNext != null);
    // presenter.logoutUserOnNext(response);
  }
}


class _GetUserUseCaseObserver extends Observer<GetUserUseCaseResponse> {
  final HomePresenter presenter;
  _GetUserUseCaseObserver(this.presenter);
  @override
  void onComplete() {
    assert(presenter.getUserOnComplete != null);
    presenter.getUserOnComplete();
  }

  @override
  void onError(e) {
    assert(presenter.getUserOnError != null);
    presenter.getUserOnError(e);
  }

  @override
  void onNext(response) {
    assert(presenter.getUserOnNext != null);
    presenter.getUserOnNext(response.user);
  }
}



class _IsNewUserUseCaseObserver extends Observer<void> {
  final HomePresenter presenter;
  _IsNewUserUseCaseObserver(this.presenter);

  @override
  void onComplete() {
    assert(presenter.isNewUserOnComplete != null);
    presenter.isNewUserOnComplete();
  }

  @override
  void onError(e) {
    assert(presenter.isNewUserOnError != null);
    presenter.isNewUserOnError(e);
  }

  @override
  void onNext(response) {
  }
}