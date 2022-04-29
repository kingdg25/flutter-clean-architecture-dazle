import 'dart:math';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../../../domain/entities/connections.dart';
import '../../../domain/entities/user.dart';
import 'connection_presenter.dart';

class ConnectionController extends Controller {
  final ConnectionPresenter connectionPresenter;
  var isLoading = true;
  var error = false;

  Random rnd = new Random();
  List<Connections> _connections;
  List<Connections> get connections {
    return _connections;
  }

  User? _user;
  User? get user => _user;

  ConnectionController(userRepo)
      : connectionPresenter = ConnectionPresenter(userRepo),
        _connections = <Connections>[],
        super();

  @override
  void initListeners() {
    getConnection();
    // get user
    connectionPresenter.getUser();
    connectionPresenter.getUserOnNext = (User res) {
      print('get user on next $res ${res.displayName}');
      _user = res;
    };

    connectionPresenter.getUserOnComplete = () {
      refreshUI();
    };

    connectionPresenter.getUserOnError = (e) {};

    //read broker
    connectionPresenter.readConnectionOnNext = (List<Connections> res) {
      _connections = res;
      isLoading = false;
    };

    connectionPresenter.readConnectionOnComplete = () {
      refreshUI();
    };

    connectionPresenter.readConnectionOnError = (e) {
      isLoading = false;
      error = true;
      print('read my connection on error $e');
      refreshUI();
    };
  }

  void refreshUi() {
    error = false;
    isLoading = true;
    refreshUI();
    initListeners();
  }

  @override
  void onResumed() => print('On resumed');

  @override
  void onReassembled() => print('View is about to be reassembled');

  @override
  void onDeactivated() => print('View is about to be deactivated');

  @override
  void onDisposed() {
    connectionPresenter.dispose(); // don't forget to dispose of the presenter
    super.onDisposed();
  }

  void getConnection({String? filterByName}) {
    connectionPresenter.readConnection(filterByName: filterByName);
  }
}
