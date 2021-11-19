import 'dart:async';

import 'package:dazle/domain/repositories/todo_repository.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';


class NewUserUseCase extends UseCase<void, NewUserUseCaseParams> {
  final TodoRepository todoRepository;
  NewUserUseCase(this.todoRepository);

  @override
  Future<Stream<void>> buildUseCaseStream(NewUserUseCaseParams params) async {
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


class NewUserUseCaseParams {
  final String email;
  final bool newUser;

  NewUserUseCaseParams(this.email, this.newUser);
}