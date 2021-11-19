import 'package:dazle/domain/usecases/authentication/is_new_user_usecase.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:dazle/domain/usecases/add_todo_usecase.dart';
import 'package:dazle/domain/usecases/authentication/get_user_usecase.dart';
import 'package:dazle/domain/usecases/authentication/logout_user_usecase.dart';
import 'package:dazle/domain/usecases/delete_todo_usecase.dart';
import 'package:dazle/domain/usecases/get_all_todo_usecase.dart';
import 'package:dazle/domain/usecases/update_todo_usecase.dart';

class HomePresenter extends Presenter {
  Function addTodoOnNext;
  Function addTodoOnComplete;
  Function addTodoOnError;

  Function getAllTodoOnNext;
  Function getAllTodoOnComplete;
  Function getAllTodoOnError;

  Function updateTodoOnNext;
  Function updateTodoOnComplete;
  Function updateTodoOnError;

  Function deleteTodoOnNext;
  Function deleteTodoOnComplete;
  Function deleteTodoOnError;

  Function logoutUserOnNext;
  Function logoutUserOnComplete;
  Function logoutUserOnError;

  Function getUserOnNext;
  Function getUserOnComplete;
  Function getUserOnError;

  final AddTodoUseCase addTodoUseCase;
  final GetAllTodoUseCase getAllTodoUseCase;
  final UpdateTodoUseCase updateTodoUseCase;
  final DeleteTodoUseCase deleteTodoUseCase;

  Function isNewUserOnNext;
  Function isNewUserOnComplete;
  Function isNewUserOnError;

  final LogoutUserUseCase logoutUserUseCase;
  final GetUserUseCase getUserUseCase;
  final IsNewUserUseCase newUserUseCase;

  HomePresenter(userRepo)
    : addTodoUseCase = AddTodoUseCase(userRepo),
      getAllTodoUseCase = GetAllTodoUseCase(userRepo),
      updateTodoUseCase = UpdateTodoUseCase(userRepo),
      deleteTodoUseCase = DeleteTodoUseCase(userRepo),
      getUserUseCase = GetUserUseCase(),
      logoutUserUseCase = LogoutUserUseCase(userRepo),
      newUserUseCase = IsNewUserUseCase(userRepo);
  
  void addTodo(String todo) {
    addTodoUseCase.execute(_AddTodoUseCaseObserver(this), AddTodoUseCaseParams(todo));
  }

  void getAllTodo() {
    getAllTodoUseCase.execute(_GetAllTodoUseCaseObserver(this), GetAllTodoUseCaseParams());
  }

  void updateTodo(String id, String todo, bool check) {
    updateTodoUseCase.execute(_UpdateTodoUseCaseObserver(this), UpdateTodoUseCaseParams(id, todo, check));
  }

  void deleteTodo(String id, bool check) {
    deleteTodoUseCase.execute(_DeleteTodoUseCaseObserver(this), DeleteTodoUseCaseParams(id, check));
  }

  void logoutUser(){
    logoutUserUseCase.execute(_LogoutUserUseCaseObserver(this), LogoutUserUseCaseParams());
  }

  void getUser() {
    getUserUseCase.execute(_GetUserUseCaseObserver(this), GetUserUseCaseParams());
  }

  void isNewUser(String email, bool isNewUser) {
    newUserUseCase.execute(_IsNewUserUseCaseObserver(this), IsNewUserUseCaseParams(email, isNewUser));
  }


  @override
  void dispose() {
    addTodoUseCase.dispose();
    getAllTodoUseCase.dispose();
    updateTodoUseCase.dispose();
    deleteTodoUseCase.dispose();
    logoutUserUseCase.dispose();
  }
}



class _AddTodoUseCaseObserver extends Observer<AddTodoUseCaseResponse> {
  final HomePresenter presenter;
  _AddTodoUseCaseObserver(this.presenter);
  @override
  void onComplete() {
    assert(presenter.addTodoOnComplete != null);
    presenter.addTodoOnComplete();
  }

  @override
  void onError(e) {
    assert(presenter.addTodoOnError != null);
    presenter.addTodoOnError(e);
  }

  @override
  void onNext(response) {
    // assert(presenter.addTodoOnNext != null);
    // presenter.addTodoOnNext();
  }
}





class _GetAllTodoUseCaseObserver extends Observer<GetAllTodoUseCaseResponse> {
  final HomePresenter presenter;
  _GetAllTodoUseCaseObserver(this.presenter);
  @override
  void onComplete() {
    assert(presenter.getAllTodoOnComplete != null);
    presenter.getAllTodoOnComplete();
  }

  @override
  void onError(e) {
    assert(presenter.getAllTodoOnError != null);
    presenter.getAllTodoOnError(e);
  }

  @override
  void onNext(response) {
    assert(presenter.getAllTodoOnNext != null);
    presenter.getAllTodoOnNext(response.todos);
  }
}




class _UpdateTodoUseCaseObserver extends Observer<UpdateTodoUseCaseResponse> {
  final HomePresenter presenter;
  _UpdateTodoUseCaseObserver(this.presenter);
  @override
  void onComplete() {
    assert(presenter.updateTodoOnComplete != null);
    presenter.updateTodoOnComplete();
  }

  @override
  void onError(e) {
    assert(presenter.updateTodoOnError != null);
    presenter.updateTodoOnError(e);
  }

  @override
  void onNext(response) {
    assert(presenter.updateTodoOnNext != null);
    presenter.updateTodoOnNext(response.todo);
  }
}






class _DeleteTodoUseCaseObserver extends Observer<DeleteTodoUseCaseResponse> {
  final HomePresenter presenter;
  _DeleteTodoUseCaseObserver(this.presenter);
  @override
  void onComplete() {
    assert(presenter.deleteTodoOnComplete != null);
    presenter.deleteTodoOnComplete();
  }

  @override
  void onError(e) {
    assert(presenter.deleteTodoOnError != null);
    presenter.deleteTodoOnError(e);
  }

  @override
  void onNext(response) {
    // assert(presenter.deleteTodoOnNext != null);
    // presenter.deleteTodoOnNext();
  }
}



class _LogoutUserUseCaseObserver extends Observer<LogoutUserUseCaseResponse> {
  final HomePresenter presenter;
  _LogoutUserUseCaseObserver(this.presenter);
  @override
  void onComplete() {
    assert(presenter.logoutUserOnComplete != null);
    presenter.logoutUserOnComplete();
  }

  @override
  void onError(e) {
    assert(presenter.logoutUserOnError != null);
    presenter.logoutUserOnError(e);
  }

  @override
  void onNext(response) {
    // assert(presenter.logoutUserOnNext != null);
    // presenter.logoutUserOnNext(response);
  }
}


class _GetUserUseCaseObserver extends Observer<GetUserUseCaseResponse> {
  final HomePresenter presenter;
  _GetUserUseCaseObserver(this.presenter);
  @override
  void onComplete() {
    assert(presenter.getUserOnComplete != null);
    presenter.getUserOnComplete();
  }

  @override
  void onError(e) {
    assert(presenter.getUserOnError != null);
    presenter.getUserOnError(e);
  }

  @override
  void onNext(response) {
    assert(presenter.getUserOnNext != null);
    presenter.getUserOnNext(response.user);
  }
}



class _IsNewUserUseCaseObserver extends Observer<void> {
  final HomePresenter presenter;
  _IsNewUserUseCaseObserver(this.presenter);

  @override
  void onComplete() {
    assert(presenter.isNewUserOnComplete != null);
    presenter.isNewUserOnComplete();
  }

  @override
  void onError(e) {
    assert(presenter.isNewUserOnError != null);
    presenter.isNewUserOnError(e);
  }

  @override
  void onNext(response) {
  }
}