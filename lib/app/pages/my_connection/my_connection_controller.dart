import 'package:dazle/app/pages/my_connection/my_connection_presenter.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';


class MyConnectionController extends Controller {
  final MyConnectionPresenter myConnectionPresenter;

  MyConnectionController(userRepo)
    : myConnectionPresenter = MyConnectionPresenter(),
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
    myConnectionPresenter.dispose(); // don't forget to dispose of the presenter
    super.onDisposed();
  }
  
}