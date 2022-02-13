import 'package:dazle/domain/entities/user.dart';
import 'package:dazle/domain/usecases/profile/update_user_usecase.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class EditProfilePresenter extends Presenter {
  Function? updateUserOnNext;
  Function? updateUserOnComplete;
  Function? updateUserOnError;

  final UpdateUserUseCase updateUserUseCase;

  EditProfilePresenter(userRepo)
    : updateUserUseCase = UpdateUserUseCase(userRepo);
  

  void updateUser({User? user}){
    updateUserUseCase.execute(_UpdateUserUseCaseObserver(this), UpdateUserUseCaseParams(user));
  }


  @override
  void dispose() {
    updateUserUseCase.dispose();
  }
}



class _UpdateUserUseCaseObserver extends Observer<void> {
  final EditProfilePresenter presenter;
  _UpdateUserUseCaseObserver(this.presenter);
  @override
  void onComplete() {
    assert(presenter.updateUserOnComplete != null);
    presenter.updateUserOnComplete!();
  }

  @override
  void onError(e) {
    assert(presenter.updateUserOnError != null);
    presenter.updateUserOnError!(e);
  }

  @override
  void onNext(response) {
  }
}