import 'dart:async';

import 'package:dazle/domain/repositories/chat_repository.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../../entities/chat.dart';

class GetChatMessageUseCase extends UseCase {
  final ChatRepository chatRepository;

  GetChatMessageUseCase(this.chatRepository);

  @override
  Future<Stream<GetChatMessageUseCaseResponse?>> buildUseCaseStream(_) async {
    final controller = StreamController<GetChatMessageUseCaseResponse>();
    try {
      final chat = await chatRepository.getMessage();
      controller.add(GetChatMessageUseCaseResponse(chat: chat));
      logger.finest("GetChatMessageUseCaseResponse Success");
      controller.close();
    } catch (e) {
      logger.severe("GetChatMessageUseCaseResponse Unsuccessful");
      controller.addError(e);
    }
    return controller.stream;
  }
}

class GetChatMessageUseCaseResponse {
  final List<Chat> chat;

  GetChatMessageUseCaseResponse({required this.chat});
}
