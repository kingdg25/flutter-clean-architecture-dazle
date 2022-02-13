import 'package:dazle/domain/usecases/message/get_message_listings_usecase.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class MessageListingPresenter extends Presenter {
  Function? getMessageListingsOnNext;
  Function? getMessageListingsOnComplete;
  Function? getMessageListingsOnError;

  final GetMessageListingsUseCase getMessageListingsUseCase;

  MessageListingPresenter(userRepo)
    : getMessageListingsUseCase = GetMessageListingsUseCase(userRepo);
  

  void getMessageListings() {
    getMessageListingsUseCase.execute(_GetMessageListingsUseCaseObserver(this), GetMessageListingsUseCaseParams());
  }

  @override
  void dispose() {
    getMessageListingsUseCase.dispose();
  }
}



class _GetMessageListingsUseCaseObserver extends Observer<GetMessageListingsUseCaseResponse> {
  final MessageListingPresenter presenter;
  _GetMessageListingsUseCaseObserver(this.presenter);
  @override
  void onComplete() {
    assert(presenter.getMessageListingsOnComplete != null);
    presenter.getMessageListingsOnComplete!();
  }

  @override
  void onError(e) {
    assert(presenter.getMessageListingsOnError != null);
    presenter.getMessageListingsOnError!(e);
  }

  @override
  void onNext(response) {
    assert(presenter.getMessageListingsOnNext != null);
    presenter.getMessageListingsOnNext!(response?.messageListings);
  }
}