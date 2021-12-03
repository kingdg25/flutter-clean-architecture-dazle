import 'package:dazle/domain/usecases/connection/read_my_connection_usecase.dart';
import 'package:dazle/domain/usecases/connection/remove_connection_usecase.dart';
import 'package:dazle/domain/usecases/connection/search_user_usecase.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class MyConnectionPresenter extends Presenter {
  Function readMyConnectionOnNext;
  Function readMyConnectionOnComplete;
  Function readMyConnectionOnError;

  Function removeConnectionOnNext;
  Function removeConnectionOnComplete;
  Function removeConnectionOnError;

  Function searchUserOnNext;
  Function searchUserOnComplete;
  Function searchUserOnError;

  final ReadMyConnectionUseCase readMyConnectionUseCase;
  final RemoveConnectionUseCase removeConnectionUseCase;
  final SearchUserUseCase searchUserUseCase;

  MyConnectionPresenter(userRepo)
    : readMyConnectionUseCase = ReadMyConnectionUseCase(userRepo),
      removeConnectionUseCase = RemoveConnectionUseCase(userRepo),
      searchUserUseCase = SearchUserUseCase(userRepo);

  void readMyConnection({String filterByName}){
    readMyConnectionUseCase.execute(_ReadMyConnectionUseCaseObserver(this), ReadMyConnectionUseCaseParams(filterByName));
  }

  void removeConnection({String invitedId}){
    removeConnectionUseCase.execute(_RemoveConnectionUseCaseObserver(this), RemoveConnectionUseCaseParams(invitedId));
  }

  void searchUser({String pattern}){
    searchUserUseCase.execute(_SearchUserUseCaseObserver(this), SearchUserUseCaseParams(pattern, true));
  }
  
  @override
  void dispose() {
    readMyConnectionUseCase.dispose();
    removeConnectionUseCase.dispose();
    searchUserUseCase.dispose();
  }
}



class _ReadMyConnectionUseCaseObserver extends Observer<ReadMyConnectionUseCaseResponse> {
  final MyConnectionPresenter presenter;
  _ReadMyConnectionUseCaseObserver(this.presenter);
  @override
  void onComplete() {
    assert(presenter.readMyConnectionOnComplete != null);
    presenter.readMyConnectionOnComplete();
  }

  @override
  void onError(e) {
    assert(presenter.readMyConnectionOnError != null);
    presenter.readMyConnectionOnError(e);
  }

  @override
  void onNext(response) {
    assert(presenter.readMyConnectionOnNext != null);
    presenter.readMyConnectionOnNext(response.myConnection);
  }
}


class _RemoveConnectionUseCaseObserver extends Observer<RemoveConnectionUseCaseResponse> {
  final MyConnectionPresenter presenter;
  _RemoveConnectionUseCaseObserver(this.presenter);
  @override
  void onComplete() {
    assert(presenter.removeConnectionOnComplete != null);
    presenter.removeConnectionOnComplete();
  }

  @override
  void onError(e) {
    assert(presenter.removeConnectionOnError != null);
    presenter.removeConnectionOnError(e);
  }

  @override
  void onNext(response) {
    assert(presenter.removeConnectionOnNext != null);
    presenter.removeConnectionOnNext(response);
  }
}



class _SearchUserUseCaseObserver extends Observer<SearchUserUseCaseResponse> {
  final MyConnectionPresenter presenter;
  _SearchUserUseCaseObserver(this.presenter);
  @override
  void onComplete() {
    assert(presenter.searchUserOnComplete != null);
    presenter.searchUserOnComplete();
  }

  @override
  void onError(e) {
    assert(presenter.searchUserOnError != null);
    presenter.searchUserOnError(e);
  }

  @override
  void onNext(response) {
    assert(presenter.searchUserOnNext != null);
    presenter.searchUserOnNext(response.data);
  }
}