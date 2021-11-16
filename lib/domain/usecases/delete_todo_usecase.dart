import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:dazle/domain/repositories/todo_repository.dart';

class DeleteTodoUseCase extends UseCase<DeleteTodoUseCaseResponse, DeleteTodoUseCaseParams> {
  final TodoRepository todoRepository;
  DeleteTodoUseCase(this.todoRepository);

  @override
  Future<Stream<DeleteTodoUseCaseResponse>> buildUseCaseStream(DeleteTodoUseCaseParams params) async {
    final controller = StreamController<DeleteTodoUseCaseResponse>();
    
    try {
      // delete todo
      if(!params.check){
        await todoRepository.deleteTodo(params.uid);
        
        logger.finest('Delete Todo successful.');
      }
      else {
        logger.severe('Cannot delete completed todo.');
        controller.addError('Cannot delete completed todo.');
      }
      controller.close();
    } catch (e) {
      logger.severe('Delete Todo fail.');
      // Trigger .onError
      controller.addError(e);
    }
    return controller.stream;
  }

}


class DeleteTodoUseCaseParams {
  final String uid;
  final bool check;
  DeleteTodoUseCaseParams(this.uid, this.check);
}

class DeleteTodoUseCaseResponse {
  DeleteTodoUseCaseResponse();
}