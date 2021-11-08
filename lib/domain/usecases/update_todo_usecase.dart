

import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:dwellu/domain/entities/todo.dart';
import 'package:dwellu/domain/repositories/todo_repository.dart';

class UpdateTodoUseCase extends UseCase<UpdateTodoUseCaseResponse, UpdateTodoUseCaseParams> {
  final TodoRepository todoRepository;
  UpdateTodoUseCase(this.todoRepository);

  @override
  Future<Stream<UpdateTodoUseCaseResponse>> buildUseCaseStream(UpdateTodoUseCaseParams params) async {
    final controller = StreamController<UpdateTodoUseCaseResponse>();

    try {
      // update todo
      final todo = await todoRepository.updateTodo(params.uid, params.todo, params.check);
      
      controller.add(UpdateTodoUseCaseResponse(todo));
      logger.finest('Update Todo successful.');
      controller.close();
    } catch (e) {
      logger.severe('Update Todo fail.');
      // Trigger .onError
      controller.addError(e);
    }
    return controller.stream;
  }

}


class UpdateTodoUseCaseParams {
  final String uid;
  final String todo;
  final bool check;
  UpdateTodoUseCaseParams(this.uid, this.todo, this.check);
}

class UpdateTodoUseCaseResponse {
  final Todo todo;
  UpdateTodoUseCaseResponse(this.todo);
}