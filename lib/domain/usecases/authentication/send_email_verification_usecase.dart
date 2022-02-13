import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:dazle/data/repositories/data_authentication_repository.dart';


class SendEmailVerificationUseCase extends UseCase<void, SendEmailVerificationUseCaseParams> {
  final DataAuthenticationRepository dataAuthenticationRepository;
  SendEmailVerificationUseCase(this.dataAuthenticationRepository);


  @override
  Future<Stream<void>> buildUseCaseStream(SendEmailVerificationUseCaseParams? params) async {
    final controller = StreamController<void>();
    
    try {
      await dataAuthenticationRepository.sendEmailVerification();

      logger.finest('Send Verification successful.');
      controller.close();
    }
    catch (e) {
      logger.severe('Is Authenticated fail.');
      // Trigger .onError
      controller.addError(e);
    }
    return controller.stream;
  }

}

class SendEmailVerificationUseCaseParams {
  SendEmailVerificationUseCaseParams();
}
