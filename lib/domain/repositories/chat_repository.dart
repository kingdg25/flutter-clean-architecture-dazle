import '../entities/chat.dart';

abstract class ChatRepository {
  Future<List<Chat>> getMessage();
}
