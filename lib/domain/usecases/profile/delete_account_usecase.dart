import 'dart:async';
// import 'dart:io';

import 'package:dazle/data/repositories/data_profile_repository.dart';
// import 'package:dazle/domain/entities/user.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class DeleteAccountUseCase extends UseCase<void, DeleteAccountUseCaseParams> {
  final DataProfileRepository dataProfileRepository;

  DeleteAccountUseCase(this.dataProfileRepository);

  @override
  Future<Stream<void>> buildUseCaseStream(
      DeleteAccountUseCaseParams? params) async {
    final controller = StreamController();

    try {
      await dataProfileRepository.deleteAccount(userId: params!.userId);
      logger.finest('Delete Account successful.');
      controller.close();
    } catch (e) {
      logger.severe('Delete Account fail.');
      // Trigger .onError
      controller.addError(e);
    }

    return controller.stream;
  }
}

class DeleteAccountUseCaseParams {
  final String? userId;

  DeleteAccountUseCaseParams(this.userId);
}
