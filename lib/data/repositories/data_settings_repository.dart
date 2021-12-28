import 'package:dazle/domain/repositories/settings_repository.dart';

class DataSettingsRepository extends SettingsRepository {
  static DataSettingsRepository _instance = DataSettingsRepository._internal();
  DataSettingsRepository._internal();
  factory DataSettingsRepository() => _instance;
  
}