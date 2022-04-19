import 'package:dazle/domain/usecases/connection/read_connections_usecase.dart';
import 'package:dazle/domain/usecases/get_user_usecase.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class ConnectionPresenter extends Presenter {
  Function? getUserOnNext;
  Function? getUserOnComplete;
  Function? getUserOnError;

  Function? readConnectionOnNext;
  Function? readConnectionOnComplete;
  Function? readConnectionOnError;

  final GetUserUseCase getUserUseCase;

  final ReadConnectionsUseCase readConnectionsUseCase;

  ConnectionPresenter(userRepo)
      : getUserUseCase = GetUserUseCase(),
        readConnectionsUseCase = ReadConnectionsUseCase(userRepo);

  void getUser() {
    getUserUseCase.execute(
        _GetUserUseCaseObserver(this), GetUserUseCaseParams());
  }

  void readConnection({String? filterByName}) {
    readConnectionsUseCase.execute(
      _ReadConnectionUseCaseObserver(this),
      ReadConnectionsUseCaseParams(filterByName),
    );
  }

  @override
  void dispose() {
    getUserUseCase.dispose();
    readConnectionsUseCase.dispose();
  }
}

class _ReadConnectionUseCaseObserver
    extends Observer<ReadConnectionsUseCaseResponse> {
  final ConnectionPresenter presenter;
  _ReadConnectionUseCaseObserver(this.presenter);
  @override
  void onComplete() {
    assert(presenter.readConnectionOnComplete != null);
    presenter.readConnectionOnComplete!();
  }

  @override
  void onError(e) {
    assert(presenter.readConnectionOnError != null);
    presenter.readConnectionOnError!(e);
  }

  @override
  void onNext(ReadConnectionsUseCaseResponse? response) {
    assert(presenter.readConnectionOnNext != null);
    presenter.readConnectionOnNext!(response?.connection);
  }
}

class _GetUserUseCaseObserver extends Observer<GetUserUseCaseResponse> {
  final ConnectionPresenter presenter;
  _GetUserUseCaseObserver(this.presenter);
  @override
  void onComplete() {
    assert(presenter.getUserOnComplete != null);
    presenter.getUserOnComplete!();
  }

  @override
  void onError(e) {
    assert(presenter.getUserOnError != null);
    presenter.getUserOnError!(e);
  }

  @override
  void onNext(response) {
    assert(presenter.getUserOnNext != null);
    presenter.getUserOnNext!(response!.user);
  }
}
