import 'package:dazle/domain/repositories/message_repository.dart';

class DataMessageRepository extends MessageRepository {
  static DataMessageRepository _instance = DataMessageRepository._internal();
  DataMessageRepository._internal();
  factory DataMessageRepository() => _instance;
  
}