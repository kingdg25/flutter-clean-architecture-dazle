import 'package:dazle/domain/entities/user.dart';

abstract class ProfileRepository {
  Future<void> update({ User user });
}