import 'dart:io';

import 'package:dazle/domain/entities/user.dart';

abstract class ProfileRepository {
  Future<void> update({User? user, File? profilePicture});

  Future<Verification> requestVerification({File? attachment});

  Future<UserFeedback> createFeedback({UserFeedback? feedback});

  Future<void> deactivateActivateAccount({User? user});

  Future<String> checkLoginType({User? user});

  Future<void> deleteAccount({String? userId});
}
