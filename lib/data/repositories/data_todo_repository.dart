import 'dart:math';
import 'dart:convert' as convert;

import 'package:dwellu/domain/entities/todo.dart';
import 'package:dwellu/domain/entities/todo_user.dart';
import 'package:dwellu/domain/repositories/todo_repository.dart';
import 'package:dwellu/data/constants.dart';
import 'package:http/http.dart' as http;


class DataTodoRepository extends TodoRepository {
  List<Todo> todos;
  TodoUser todoUser;

  static final DataTodoRepository _instance = DataTodoRepository._internal();
  DataTodoRepository._internal() {
    todos = <Todo>[];
  }
  factory DataTodoRepository() => _instance;

  String generateRandomString(int len) {
    var r = Random();
    return String.fromCharCodes(
        List.generate(len, (index) => r.nextInt(33) + 89));
  }

  @override
  Future<void> addTodo(String todo) async {
    final todoId = generateRandomString(5);
    final todoDoc = Todo(todoId, todo, false);

    todos.add(todoDoc);

    var _todos = todoDoc.toJson();

    await http.post(
      "${Constants.siteURL}/api/todo/add",
      body: convert.jsonEncode(_todos),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      }
    );
  }

  @override
  Future<List<Todo>> getAllTodo() async {
    var data = await http.get(
      "${Constants.siteURL}/api/todo/read",
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      }
    );

    if (data.statusCode == 200){
      var jsonResponse = await convert.jsonDecode(data.body);

      todos = List<Todo>.from(jsonResponse.map((i) => Todo.fromJson(i)));
    }

    return todos;
  }

  @override
  Future<Todo> updateTodo(String id, String todo, bool check) async {
    Todo newTodo = Todo(id, todo, check);
    todos[todos.indexWhere((element) => element.id == id)] = newTodo;

    await http.put(
      "${Constants.siteURL}/api/todo/update",
      body: convert.jsonEncode({
        'id': id,
        'newTodo': todo,
        'newCheck': check
      }),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      }
    );

    return newTodo;
  }

  @override
  Future<void> deleteTodo(String id) async {
    todos.removeWhere((element) => element.id == id);

    await http.delete(
      "${Constants.siteURL}/api/todo/delete?id=$id",
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      }
    );
  }
  
}