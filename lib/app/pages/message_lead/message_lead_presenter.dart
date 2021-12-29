import 'package:dazle/domain/usecases/message/get_message_leads_usecase.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class MessageLeadPresenter extends Presenter {
  Function getMessageLeadsOnNext;
  Function getMessageLeadsOnComplete;
  Function getMessageLeadsOnError;

  final GetMessageLeadsUseCase getMessageLeadsUseCase;

  MessageLeadPresenter(userRepo)
    : getMessageLeadsUseCase = GetMessageLeadsUseCase(userRepo);
  

  void getMessageLeads() {
    getMessageLeadsUseCase.execute(_GetMessageLeadsUseCaseObserver(this), GetMessageLeadsUseCaseParams());
  }

  @override
  void dispose() {
    getMessageLeadsUseCase.dispose();
  }
}



class _GetMessageLeadsUseCaseObserver extends Observer<GetMessageLeadsUseCaseResponse> {
  final MessageLeadPresenter presenter;
  _GetMessageLeadsUseCaseObserver(this.presenter);
  @override
  void onComplete() {
    assert(presenter.getMessageLeadsOnComplete != null);
    presenter.getMessageLeadsOnComplete();
  }

  @override
  void onError(e) {
    assert(presenter.getMessageLeadsOnError != null);
    presenter.getMessageLeadsOnError(e);
  }

  @override
  void onNext(response) {
    assert(presenter.getMessageLeadsOnNext != null);
    presenter.getMessageLeadsOnNext(response.messageLeads);
  }
}