import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:dwellu/data/repositories/data_authentication_repository.dart';
import 'package:dwellu/domain/entities/todo_user.dart';



class LoginUserUseCase extends UseCase<LoginUserUseCaseResponse, LoginUserUseCaseParams> {
  final DataAuthenticationRepository dataAuthenticationRepository;
  LoginUserUseCase(this.dataAuthenticationRepository);


  @override
  Future<Stream<LoginUserUseCaseResponse>> buildUseCaseStream(LoginUserUseCaseParams params) async {
    final controller = StreamController<LoginUserUseCaseResponse>();
    
    try {
      final user = await dataAuthenticationRepository.login(email: params.email, password: params.password);

      controller.add(LoginUserUseCaseResponse(user));

      logger.finest('Login User successful.');
      controller.close();
    }
    catch (e) {
      logger.severe('Login User fail.');
      // Trigger .onError
      controller.addError(e);
    }
    return controller.stream;
  }

}




class LoginUserUseCaseParams {
  final String email;
  final String password;
  LoginUserUseCaseParams(this.email, this.password);
}

class LoginUserUseCaseResponse {
  final TodoUser user;
  LoginUserUseCaseResponse(this.user);
}
