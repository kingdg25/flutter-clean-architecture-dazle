import 'package:dazle/domain/repositories/chat_repository.dart';

import '../../domain/entities/chat.dart';

class DataChatRepository extends ChatRepository {
  late List<Chat> chat;

  static final DataChatRepository _instance = DataChatRepository._internal();

  DataChatRepository._internal() {
    chat = [];
    chat.addAll([
      Chat(
        text: "Hello, Great to see you again!",
        date: DateTime.now().subtract(const Duration(minutes: 10)),
        isSentByMe: false,
        messageType: ChatMessageType.text,
      ),
      Chat(
        text: "Are you free this afternoon?",
        date: DateTime.now().subtract(const Duration(minutes: 5)),
        isSentByMe: true,
        messageType: ChatMessageType.text,
      ),
      Chat(
        text: "Yes I am!",
        date: DateTime.now().subtract(const Duration(minutes: 1)),
        isSentByMe: false,
        messageType: ChatMessageType.text,
      ),
    ]);
  }

  factory DataChatRepository() => _instance;

  @override
  Future<List<Chat>> getMessage() async {
    return chat;
  }
}
