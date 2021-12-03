import 'package:dazle/domain/usecases/connection/add_connection_usecase.dart';
import 'package:dazle/domain/usecases/connection/read_invites_usercase.dart';
import 'package:dazle/domain/usecases/connection/search_user_usecase.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class InvitesPresenter extends Presenter {
  Function readInvitesOnNext;
  Function readInvitesOnComplete;
  Function readInvitesOnError;

  Function addConnectionOnNext;
  Function addConnectionOnComplete;
  Function addConnectionOnError;

  Function searchUserOnNext;
  Function searchUserOnComplete;
  Function searchUserOnError;

  final ReadInvitesUseCase readInvitesUseCase;
  final AddConnectionUseCase addConnectionUseCase;
  final SearchUserUseCase searchUserUseCase;

  InvitesPresenter(userRepo)
    : readInvitesUseCase = ReadInvitesUseCase(userRepo),
      addConnectionUseCase = AddConnectionUseCase(userRepo),
      searchUserUseCase = SearchUserUseCase(userRepo);

  
  void readInvites({String filterByName}){
    readInvitesUseCase.execute(_ReadInvitesUseCaseObserver(this), ReadInvitesUseCaseParams(filterByName));
  }

  void addConnection({String invitedId}){
    addConnectionUseCase.execute(_AddConnectionUseCaseObserver(this), AddConnectionUseCaseParams(invitedId));
  }

  void searchUser({String pattern}){
    searchUserUseCase.execute(_SearchUserUseCaseObserver(this), SearchUserUseCaseParams(pattern, false));
  }

  
  @override
  void dispose() {
    readInvitesUseCase.dispose();
    addConnectionUseCase.dispose();
    searchUserUseCase.dispose();
  }
}



class _ReadInvitesUseCaseObserver extends Observer<ReadInvitesUseCaseResponse> {
  final InvitesPresenter presenter;
  _ReadInvitesUseCaseObserver(this.presenter);
  @override
  void onComplete() {
    assert(presenter.readInvitesOnComplete != null);
    presenter.readInvitesOnComplete();
  }

  @override
  void onError(e) {
    assert(presenter.readInvitesOnError != null);
    presenter.readInvitesOnError(e);
  }

  @override
  void onNext(response) {
    assert(presenter.readInvitesOnNext != null);
    presenter.readInvitesOnNext(response.invites);
  }
}


class _AddConnectionUseCaseObserver extends Observer<AddConnectionUseCaseResponse> {
  final InvitesPresenter presenter;
  _AddConnectionUseCaseObserver(this.presenter);
  @override
  void onComplete() {
    assert(presenter.addConnectionOnComplete != null);
    presenter.addConnectionOnComplete();
  }

  @override
  void onError(e) {
    assert(presenter.addConnectionOnError != null);
    presenter.addConnectionOnError(e);
  }

  @override
  void onNext(response) {
    assert(presenter.addConnectionOnNext != null);
    presenter.addConnectionOnNext(response);
  }
}



class _SearchUserUseCaseObserver extends Observer<SearchUserUseCaseResponse> {
  final InvitesPresenter presenter;
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