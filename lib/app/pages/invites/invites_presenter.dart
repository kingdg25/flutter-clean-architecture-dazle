import 'package:dazle/domain/usecases/connection/add_connection_usecase.dart';
import 'package:dazle/domain/usecases/connection/read_invites_usercase.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class InvitesPresenter extends Presenter {
  Function readInvitesOnNext;
  Function readInvitesOnComplete;
  Function readInvitesOnError;

  Function addConnectionOnNext;
  Function addConnectionOnComplete;
  Function addConnectionOnError;

  final ReadInvitesUseCase readInvitesUseCase;
  final AddConnectionUseCase addConnectionUseCase;

  InvitesPresenter(userRepo)
    : readInvitesUseCase = ReadInvitesUseCase(userRepo),
      addConnectionUseCase = AddConnectionUseCase(userRepo);

  
  void readInvites(){
    readInvitesUseCase.execute(_ReadInvitesUseCaseObserver(this), ReadInvitesUseCaseParams());
  }

  void addConnection({String invitedId}){
    addConnectionUseCase.execute(_AddConnectionUseCaseObserver(this), AddConnectionUseCaseParams(invitedId));
  }

  
  @override
  void dispose() {
    readInvitesUseCase.dispose();
    addConnectionUseCase.dispose();
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