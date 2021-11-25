import 'package:dazle/domain/repositories/profile_repository.dart';

class DataProfileRepository extends ProfileRepository {
  static DataProfileRepository _instance = DataProfileRepository._internal();
  DataProfileRepository._internal();
  factory DataProfileRepository() => _instance;
  
}