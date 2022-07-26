import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:dazle/data/repositories/data_authentication_repository.dart';

class DeleteAccountCodeUseCase extends UseCase<DeleteAccountCodeUseCaseResponse,
    DeleteAccountCodeUseCaseParams> {
  final DataAuthenticationRepository dataAuthenticationRepository;
  DeleteAccountCodeUseCase(this.dataAuthenticationRepository);

  @override
  Future<Stream<DeleteAccountCodeUseCaseResponse>> buildUseCaseStream(
      DeleteAccountCodeUseCaseParams? params) async {
    final controller = StreamController<DeleteAccountCodeUseCaseResponse>();
    try {
      final code = await dataAuthenticationRepository.deleteAccountCode(
          email: params!.email, action: params.action);

      if (code != null) {
        controller.add(DeleteAccountCodeUseCaseResponse(code));
        logger.finest('Sending Delete Account Code Successful.');
      } else {
        controller.addError('Delete Account Code is null.');
        logger.severe('Sending Delete Account Code fail. code: $code');
      }
      controller.close();
    } catch (e) {
      logger.severe('Sending Delete Account fail.');
      //Trigger .onError
      controller.addError(e);
    }

    return controller.stream;
  }
}

class DeleteAccountCodeUseCaseParams {
  final String? email;
  final String? action;

  DeleteAccountCodeUseCaseParams(this.email, this.action);
}

class DeleteAccountCodeUseCaseResponse {
  final String code;

  DeleteAccountCodeUseCaseResponse(this.code);
}
