import 'package:dazle/domain/entities/todo.dart';

abstract class TodoRepository {
  Future<void> addTodo(String todo);
  Future<List<Todo>> getAllTodo();
  Future<Todo> updateTodo(String id, String todo, bool check);
  Future<void> deleteTodo(String id);
}
