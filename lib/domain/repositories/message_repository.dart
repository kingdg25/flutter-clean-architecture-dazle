import 'package:dazle/domain/entities/message.dart';

abstract class MessageRepository {
  Future<List<Message>> getMessageListings();

  Future<List<Message>> getMessageLeads();
}