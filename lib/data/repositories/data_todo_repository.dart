import 'dart:math';
import 'dart:convert' as convert;

import 'package:dazle/domain/entities/todo.dart';
import 'package:dazle/domain/entities/todo_user.dart';
import 'package:dazle/domain/repositories/todo_repository.dart';
import 'package:dazle/data/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


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

  @override
  Future<void> isNewUser({String email, bool isNewUser}) async {
    Map params = {
      "user": {
        "email": email,
        "is_new_user": isNewUser
      }
    };

    var response = await http.post(
      "${Constants.siteURL}/api/users/is-new-user",
      body: convert.jsonEncode(params),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      }
    );

    var jsonResponse = await convert.jsonDecode(response.body);
    if (response.statusCode == 200){
      print('new user json data $jsonResponse');
      bool success = jsonResponse['success'];
      var user = jsonResponse['user'];

      if (success) {
        print('isNewUser isNewUser isNewUser isNewUser ${user['is_new_user']} $user');
        SharedPreferences prefs = await SharedPreferences.getInstance();

        if(user != null){
          await prefs.setString('user', convert.jsonEncode(user));
        }

      }
      else {
        throw {
          "error": false,
          "status": "$jsonResponse"
        };
      }
      
    }
    else {
      throw {
        "error": true,
        "status": "$jsonResponse"
      };
    }
  
  }
  
}