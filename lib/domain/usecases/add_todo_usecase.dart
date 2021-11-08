import 'dart:async';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:dwellu/domain/repositories/todo_repository.dart';


class AddTodoUseCase extends UseCase<AddTodoUseCaseResponse, AddTodoUseCaseParams>{
  final TodoRepository todoRepository;
  AddTodoUseCase(this.todoRepository);

  @override
  Future<Stream<AddTodoUseCaseResponse>> buildUseCaseStream(AddTodoUseCaseParams params) async {
    final controller = StreamController<AddTodoUseCaseResponse>();

    try {
      // add todo
      await todoRepository.addTodo(params.todo);
      
      logger.finest('Add Todo successful.');
      controller.close();
    } catch (e) {
      logger.severe('Add Todo fail.');
      // Trigger .onError
      controller.addError(e);
    }
    return controller.stream;
  }
  
}




class AddTodoUseCaseParams {
  final String todo;
  AddTodoUseCaseParams(this.todo);
}

class AddTodoUseCaseResponse {
  AddTodoUseCaseResponse();
}
