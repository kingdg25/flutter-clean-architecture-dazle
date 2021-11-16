import 'dart:async';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:dazle/domain/entities/todo.dart';
import 'package:dazle/domain/repositories/todo_repository.dart';

class GetAllTodoUseCase extends UseCase<GetAllTodoUseCaseResponse, GetAllTodoUseCaseParams> {
  final TodoRepository todoRepository;
  GetAllTodoUseCase(this.todoRepository);

  @override
  Future<Stream<GetAllTodoUseCaseResponse>> buildUseCaseStream(GetAllTodoUseCaseParams params) async {
    final controller = StreamController<GetAllTodoUseCaseResponse>();
    
    try {
      // all todo
      final allTodo = await todoRepository.getAllTodo();

      controller.add(GetAllTodoUseCaseResponse(allTodo));
      logger.finest('Get All Todo successful. $allTodo');
      controller.close();
    } catch (e) {
      logger.severe('Get All Todo fail. $e');
      // Trigger .onError
      controller.addError(e);
    }
    return controller.stream;
  }

  
}


class GetAllTodoUseCaseParams {
  GetAllTodoUseCaseParams();
}

class GetAllTodoUseCaseResponse {
  List<Todo> todos;
  GetAllTodoUseCaseResponse(this.todos);
}