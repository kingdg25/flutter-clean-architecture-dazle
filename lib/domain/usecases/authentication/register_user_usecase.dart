import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:dwellu/data/repositories/data_authentication_repository.dart';


class RegisterUserUseCase extends UseCase<void, RegisterUserUseCaseParams> {
  final DataAuthenticationRepository dataAuthenticationRepository;
  RegisterUserUseCase(this.dataAuthenticationRepository);

  @override
  Future<Stream<void>> buildUseCaseStream(RegisterUserUseCaseParams params) async {
    final controller = StreamController();
    
    try {
      await dataAuthenticationRepository.register(
        firstName: params.firstName, 
        lastName: params.lastName, 
        email: params.email, 
        password: params.password
      );
      
      logger.finest('Register User successful.');
      controller.close();

    } 
    catch (e) {
      logger.severe('Register User fail.');
      // Trigger .onError
      controller.addError(e);
    }
    return controller.stream;
  }
  
}


class RegisterUserUseCaseParams {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  RegisterUserUseCaseParams(this.firstName, this.lastName, this.email, this.password);
}