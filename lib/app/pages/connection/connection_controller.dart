import 'package:dazle/app/pages/connection/connection_presenter.dart';
import 'package:dazle/domain/entities/user.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';


class ConnectionController extends Controller {
  final ConnectionPresenter connectionPresenter;

  User? _user;
  User? get user => _user;

  ConnectionController(userRepo)
    : connectionPresenter = ConnectionPresenter(userRepo),
      super();


  @override
  void initListeners() {
    // get user
    connectionPresenter.getUser();
    connectionPresenter.getUserOnNext = (User res) {
      print('get user on next $res ${res.displayName}');
      if(res != null) {
        _user = res;
      }
    };

    connectionPresenter.getUserOnComplete = () {
      print('get user on complete');
      refreshUI();
    };

    connectionPresenter.getUserOnError = (e) {
      print('get user on error $e');
    };
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
  
}