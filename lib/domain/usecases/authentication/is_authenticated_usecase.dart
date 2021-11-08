import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:dwellu/data/repositories/data_authentication_repository.dart';


class IsAuthenticatedUseCase extends UseCase<IsAuthenticatedUseCaseResponse, IsAuthenticatedUseCaseParams> {
  final DataAuthenticationRepository dataAuthenticationRepository;
  IsAuthenticatedUseCase(this.dataAuthenticationRepository);


  @override
  Future<Stream<IsAuthenticatedUseCaseResponse>> buildUseCaseStream(IsAuthenticatedUseCaseParams params) async {
    final controller = StreamController<IsAuthenticatedUseCaseResponse>();
    
    try {
      bool isAuthenticated = await dataAuthenticationRepository.isAuthenticated();
      controller.add(IsAuthenticatedUseCaseResponse(isAuthenticated));

      logger.finest('Is Authenticated successful.');
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




class IsAuthenticatedUseCaseParams {
  IsAuthenticatedUseCaseParams();
}

class IsAuthenticatedUseCaseResponse {
  final bool isAuthenticate;
  IsAuthenticatedUseCaseResponse(this.isAuthenticate);
}
