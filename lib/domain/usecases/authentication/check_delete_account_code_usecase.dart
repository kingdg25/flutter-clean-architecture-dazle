import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:dazle/data/repositories/data_authentication_repository.dart';

class CheckDeleteAccountCodeUseCase extends UseCase<
    CheckDeleteAccountCodeUseCaseResponse,
    CheckDeleteAccountCodeUseCaseParams> {
  final DataAuthenticationRepository dataAuthenticationRepository;

  CheckDeleteAccountCodeUseCase(this.dataAuthenticationRepository);

  @override
  Future<Stream<CheckDeleteAccountCodeUseCaseResponse>> buildUseCaseStream(
      CheckDeleteAccountCodeUseCaseParams? params) async {
    final controller =
        StreamController<CheckDeleteAccountCodeUseCaseResponse>();

    try {
      await dataAuthenticationRepository.checkDeleteAccountCode(
          email: params!.email, code: params.code);

      logger.finest('Check Delete Account Code Successful.');
      controller.close();
    } catch (e) {
      logger.severe('Check Delete Account Code fail.');
      // Trigger .onError
      controller.addError(e);
    }

    return controller.stream;
  }
}

class CheckDeleteAccountCodeUseCaseParams {
  final String? email;
  final String? code;

  CheckDeleteAccountCodeUseCaseParams(this.email, this.code);
}

class CheckDeleteAccountCodeUseCaseResponse {
  CheckDeleteAccountCodeUseCaseResponse();
}
