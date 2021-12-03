import 'package:dazle/domain/usecases/authentication/get_user_usecase.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class ConnectionPresenter extends Presenter {
  Function getUserOnNext;
  Function getUserOnComplete;
  Function getUserOnError;
  
  final GetUserUseCase getUserUseCase;

  ConnectionPresenter(userRepo)
    : getUserUseCase = GetUserUseCase();
  
  void getUser() {
    getUserUseCase.execute(_GetUserUseCaseObserver(this), GetUserUseCaseParams());
  }

  @override
  void dispose() {
    getUserUseCase.dispose();
  }
}



class _GetUserUseCaseObserver extends Observer<GetUserUseCaseResponse> {
  final ConnectionPresenter presenter;
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