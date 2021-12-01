import 'package:dazle/domain/usecases/connection/read_invites_usercase.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class InvitesPresenter extends Presenter {
  Function readInvitesOnNext;
  Function readInvitesOnComplete;
  Function readInvitesOnError;

  final ReadInvitesUseCase readInvitesUseCase;

  InvitesPresenter(userRepo)
    : readInvitesUseCase = ReadInvitesUseCase(userRepo);

  void readInvites({String email}){
    readInvitesUseCase.execute(_ReadInvitesUseCaseObserver(this), ReadInvitesUseCaseParams(email));
  }
  
  @override
  void dispose() {
    readInvitesUseCase.dispose();
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