import 'package:dazle/domain/repositories/connection_repository.dart';

class DataConnectionRepository extends ConnectionRepository {
  static DataConnectionRepository _instance = DataConnectionRepository._internal();
  DataConnectionRepository._internal();
  factory DataConnectionRepository() => _instance;
  
}