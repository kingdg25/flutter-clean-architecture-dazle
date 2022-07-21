import 'dart:async';
import 'dart:io';

import 'package:dazle/data/repositories/data_profile_repository.dart';
import 'package:dazle/domain/entities/user.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class DeactivateActivateAccountUseCase
    extends UseCase<void, DeactivateActivateAccountUseCaseParams> {
  final DataProfileRepository dataProfileRepository;

  DeactivateActivateAccountUseCase(this.dataProfileRepository);

  @override
  Future<Stream<void>> buildUseCaseStream(
      DeactivateActivateAccountUseCaseParams? params) async {
    final controller = StreamController();

    try {
      await dataProfileRepository.deactivateActivateAccount(user: params!.user);
      logger.finest('Deactivate/Activate Account Successful.');
      controller.close();
    } catch (e) {
      logger.severe('Deactivate/Activate Account Fail.');
      controller.addError(e);
    }
    return controller.stream;
  }
}

class DeactivateActivateAccountUseCaseParams {
  final User? user;

  DeactivateActivateAccountUseCaseParams(this.user);
}
