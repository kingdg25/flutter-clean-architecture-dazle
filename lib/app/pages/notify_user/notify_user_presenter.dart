import 'package:dazle/domain/usecases/connection/notify_user_usecase.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class NotifyUserPresenter extends Presenter {
  Function notifyUserOnNext;
  Function notifyUserOnComplete;
  Function notifyUserOnError;

  final NotifyUserUseCase notifyUserUseCase;

  NotifyUserPresenter(userRepo)
    : notifyUserUseCase = NotifyUserUseCase(userRepo);

  void notifyUser({String email, String mobileNumber}){
    notifyUserUseCase.execute(_NotifyUserUseCaseObserver(this), NotifyUserUseCaseParams(email, mobileNumber));
  }
  
  @override
  void dispose() {
    notifyUserUseCase.dispose();
  }
}



class _NotifyUserUseCaseObserver extends Observer<void> {
  final NotifyUserPresenter presenter;
  _NotifyUserUseCaseObserver(this.presenter);
  @override
  void onComplete() {
    assert(presenter.notifyUserOnComplete != null);
    presenter.notifyUserOnComplete();
  }

  @override
  void onError(e) {
    assert(presenter.notifyUserOnError != null);
    presenter.notifyUserOnError(e);
  }

  @override
  void onNext(response) {
  }
}