import 'package:dazle/app/pages/connection/connection_presenter.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';


class ConnectionController extends Controller {
  final ConnectionPresenter connectionPresenter;

  ConnectionController(userRepo)
    : connectionPresenter = ConnectionPresenter(),
      super();


  @override
  void initListeners() {

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