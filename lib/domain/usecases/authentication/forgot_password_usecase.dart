import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:dazle/data/repositories/data_authentication_repository.dart';


class ForgotPasswordUseCase extends UseCase<ForgotPasswordUseCaseResponse, ForgotPasswordUseCaseParams> {
  final DataAuthenticationRepository dataAuthenticationRepository;
  ForgotPasswordUseCase(this.dataAuthenticationRepository);


  @override
  Future<Stream<ForgotPasswordUseCaseResponse>> buildUseCaseStream(ForgotPasswordUseCaseParams params) async {
    final controller = StreamController<ForgotPasswordUseCaseResponse>();
    
    try {
      final code = await dataAuthenticationRepository.forgotPassword(params.email);
      
      if (code != null){
        controller.add(ForgotPasswordUseCaseResponse(code));
        logger.finest('Forgot Password successful.');
      }
      else{
        controller.addError('Response code is null');
        logger.severe('Forgot Password fail. code: $code');
      }
      
      controller.close();
    }
    catch (e) {
      logger.severe('Forgot Password fail.');
      // Trigger .onError
      controller.addError(e);
    }
    return controller.stream;
  }

}



class ForgotPasswordUseCaseParams {
  final String email;
  ForgotPasswordUseCaseParams(this.email);
}

class ForgotPasswordUseCaseResponse {
  final String code;
  ForgotPasswordUseCaseResponse(this.code);
}

