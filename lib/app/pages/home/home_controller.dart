import 'package:dazle/app/pages/home/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:dazle/app/pages/home/home_presenter.dart';
import 'package:dazle/app/pages/login/login_view.dart';
import 'package:dazle/domain/entities/todo.dart';
import 'package:dazle/domain/entities/todo_user.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';


class HomeController extends Controller {
  TodoUser _user;
  TodoUser get user => _user;

  Todo _todo;
  Todo get todo => _todo;

  List<Todo> _allTodo;
  List<Todo> get allTodos => _allTodo;

  final TextEditingController _todoTextController;
  TextEditingController get todoTextController => _todoTextController;

  final TextEditingController _updateTodoTextController;
  TextEditingController get updateTodoTextController => _updateTodoTextController;

  List<String> _menu;
  List<String> get menu => _menu;

  String _displayName;
  String get displayName => _displayName;

  final HomePresenter homePresenter;

  HomeController(userRepo)
    : _allTodo = <Todo>[],
      _todoTextController = TextEditingController(),
      _menu = [],
      _updateTodoTextController = TextEditingController(),
      _displayName = '',
      homePresenter = HomePresenter(userRepo),
      super();


  @override
  void initListeners() {
    // get all todo
    homePresenter.getAllTodo();
    homePresenter.getAllTodoOnNext = (List<Todo> todos) {
      print('get all todo on next $todos');
      _menu = ['Update','Delete'];
      _allTodo = todos;
    };

    homePresenter.getAllTodoOnComplete = () {
      print('get all todo on complete');
    };

    homePresenter.getAllTodoOnError = (e) {
      print('get all todo on error $e');
    };


    // add todo
    homePresenter.addTodoOnNext = () {
      print('get all todo on next');
    };

    homePresenter.addTodoOnComplete = () {
      print('add todo on complete');
      Loader.hide();
      _todoTextController.clear();
    };

    homePresenter.addTodoOnError = (e) {
      print('add todo on error $e');
      Loader.hide();
    };


    // delete todo
    homePresenter.deleteTodoOnNext = () {
      print('delete todo on next');
    };

    homePresenter.deleteTodoOnComplete = () {
      print('delete todo on complete');
      Loader.hide();
    };

    homePresenter.deleteTodoOnError = (e) {
      print('delete todo on error ${e.toString()}');
      Loader.hide();
      cannotDeleteDoneTodoDialog(e.toString());
    };


    // update todo
    homePresenter.updateTodoOnNext = (Todo todo) {
      print('update todo on next $todo');
    };

    homePresenter.updateTodoOnComplete = () {
      print('update todo on complete');
      Loader.hide();
    };

    homePresenter.updateTodoOnError = (e) {
      print('update todo on error $e');
      Loader.hide();
    };

    // logout
    homePresenter.logoutUserOnNext = () {
      print('logout on next $todo');
    };

    homePresenter.logoutUserOnComplete = () {
      print('logout on complete');
      Loader.hide();
      loginPage();
    };

    homePresenter.logoutUserOnError = (e) {
      print('logout on error $e');
      Loader.hide();
    };

    homePresenter.getUser();
    // get user
    homePresenter.getUserOnNext = (TodoUser res) {
      print('get user on next $res');
      if(res != null) {
        _user = res;

        _displayName = res.displayName ?? res.email;
      }
    };

    homePresenter.getUserOnComplete = () {
      print('get user on complete');
    };

    homePresenter.getUserOnError = (e) {
      print('get user on error $e');
    };


    //new user or not
    homePresenter.newUserOnNext = (res) {
      print('new user on next $res');
    };

    homePresenter.newUserOnComplete = () {
      print('new user on complete');
      Loader.hide();

      homePage();
    };

    homePresenter.newUserOnError = (e) {
      print('new user on error $e');
      Loader.hide();
    };

  }

  void newUser() {
    print('_user _user _user $_user ${_user.displayName} ${_user.newUser}');

    if ( _user != null ) {
      homePresenter.newUser(_user.email, false);
    }
  }

  void addTodo() {
    Loader.show(getContext());

    homePresenter.addTodo(todoTextController.text);
  }

  void deleteTodo(String uid, bool check){
    Loader.show(getContext());

    homePresenter.deleteTodo(uid, check);
  }

  void updateTodo(String uid, String todo, bool check){
    Loader.show(getContext());
    
    homePresenter.updateTodo(uid, todo, check);
  }

  cannotDeleteDoneTodoDialog(String message){
    return showDialog(
      context: getContext(),
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)),
          title: Text('Error Message', style: TextStyle(fontSize: 15.0)),
          content: Text(message, style: TextStyle(fontSize: 15.0)),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.pop(context);
              }
            ),
          ],
        );
      },
    );
  }


  void userLogout(){
    print('user logout home controller');
    homePresenter.logoutUser();
  }

  void homePage() {
    Navigator.popAndPushNamed(getContext(), HomePage.id);
  }

  void loginPage() {
    Navigator.popAndPushNamed(getContext(), LoginPage.id);
  }



  @override
  void onResumed() => print('On resumed');

  @override
  void onReassembled() => print('View is about to be reassembled');

  @override
  void onDeactivated() => print('View is about to be deactivated');

  @override
  void onDisposed() {
    homePresenter.dispose(); // don't forget to dispose of the presenter
    _todoTextController.dispose();
    _updateTodoTextController.dispose();
    super.onDisposed();
  }
  
}