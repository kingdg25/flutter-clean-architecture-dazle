import 'package:dazle/app/pages/main/main_presenter.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';


class MainController extends Controller {
  final MainPresenter mainPresenter;

  MainController(userRepo)
    : mainPresenter = MainPresenter(),
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
    mainPresenter.dispose(); // don't forget to dispose of the presenter
    super.onDisposed();
  }
  
}