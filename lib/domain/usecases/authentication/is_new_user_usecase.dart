import 'dart:async';

import 'package:dazle/domain/repositories/todo_repository.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';


class IsNewUserUseCase extends UseCase<void, IsNewUserUseCaseParams> {
  final TodoRepository todoRepository;
  IsNewUserUseCase(this.todoRepository);

  @override
  Future<Stream<void>> buildUseCaseStream(IsNewUserUseCaseParams params) async {
    final controller = StreamController();
    
    try {
      await todoRepository.newUser(
        email: params.email,
        newUser: params.newUser
      );
      
      logger.finest('New User successful.');
      controller.close();

    } 
    catch (e) {
      logger.severe('New User fail.');
      // Trigger .onError
      controller.addError(e);
    }
    return controller.stream;
  }
  
}


class IsNewUserUseCaseParams {
  final String email;
  final bool newUser;

  IsNewUserUseCaseParams(this.email, this.newUser);
}