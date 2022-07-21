import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:dazle/data/repositories/data_authentication_repository.dart';

class VerifyPasswordUseCase extends UseCase<VerifyPasswordUseCaseResponse,
    VerifyPasswordUseCaseParams> {
  final DataAuthenticationRepository dataAuthenticationRepository;

  VerifyPasswordUseCase(this.dataAuthenticationRepository);

  @override
  Future<Stream<VerifyPasswordUseCaseResponse>> buildUseCaseStream(
      VerifyPasswordUseCaseParams? params) async {
    final controller = StreamController<VerifyPasswordUseCaseResponse>();

    try {
      await dataAuthenticationRepository.verifyPassword(
          email: params!.email, password: params.password);
      logger.finest('Verify Password Successful.');
      controller.close();
    } catch (e) {
      logger.severe('Verify Password fail.');
      // Trigger .onError
      controller.addError(e);
    }

    return controller.stream;
  }
}

class VerifyPasswordUseCaseParams {
  final String? email;
  final String? password;

  VerifyPasswordUseCaseParams(this.email, this.password);
}

class VerifyPasswordUseCaseResponse {
  VerifyPasswordUseCaseResponse();
}
