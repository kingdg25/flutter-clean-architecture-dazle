import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:dwellu/data/repositories/data_authentication_repository.dart';


class ResetPasswordUseCase extends UseCase<ResetPasswordUseCaseResponse, ResetPasswordUseCaseParams> {
  final DataAuthenticationRepository dataAuthenticationRepository;
  ResetPasswordUseCase(this.dataAuthenticationRepository);


  @override
  Future<Stream<ResetPasswordUseCaseResponse>> buildUseCaseStream(ResetPasswordUseCaseParams params) async {
    final controller = StreamController<ResetPasswordUseCaseResponse>();
    
    try {
      await dataAuthenticationRepository.resetPassword(params.email, params.code, params.password);

      logger.finest('Reset Password successful.');
      controller.close();
    }
    catch (e) {
      logger.severe('Reset Password fail.');
      // Trigger .onError
      controller.addError(e);
    }
    return controller.stream;
  }

}



class ResetPasswordUseCaseParams {
  final String email;
  final String code;
  final String password;
  ResetPasswordUseCaseParams(this.email, this.code, this.password);
}

class ResetPasswordUseCaseResponse {
  ResetPasswordUseCaseResponse();
}
