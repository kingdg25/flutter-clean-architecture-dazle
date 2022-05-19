import 'package:dazle/domain/usecases/chat/get_chat_message_usecase.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class ChatPresenter extends Presenter {
  late Function getChatOnComplete;
  late Function getChatOnError;
  late Function getChatOnNext;

  final GetChatMessageUseCase getChatMessageUseCase;

  ChatPresenter(chatRepository)
      : getChatMessageUseCase = GetChatMessageUseCase(chatRepository);

  @override
  void dispose() {
    getChatMessageUseCase.dispose();
  }

  getAllMessage() {
    getChatMessageUseCase.execute(_GetChatMessageUseCaseObserver(this));
  }
}

class _GetChatMessageUseCaseObserver
    extends Observer<GetChatMessageUseCaseResponse> {
  final ChatPresenter chatPresenter;

  _GetChatMessageUseCaseObserver(this.chatPresenter);

  @override
  void onComplete() {
    chatPresenter.getChatOnComplete();
  }

  @override
  void onError(e) {
    chatPresenter.getChatOnError(e);
  }

  @override
  void onNext(GetChatMessageUseCaseResponse? response) {
    chatPresenter.getChatOnNext(response!.chat);
  }
}
