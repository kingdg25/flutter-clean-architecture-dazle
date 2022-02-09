import 'dart:io';

import 'package:dazle/domain/entities/user.dart';

abstract class ProfileRepository {
  Future<void> update({User user});

  Future<Verification> requestVerification({File attachment});
}
