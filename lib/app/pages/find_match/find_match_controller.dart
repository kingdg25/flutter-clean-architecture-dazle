import 'package:dazle/app/pages/find_match/find_match_presenter.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';


class FindMatchController extends Controller {
  final FindMatchPresenter findMatchPresenter;

  FindMatchController(userRepo)
    : findMatchPresenter = FindMatchPresenter(),
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
    findMatchPresenter.dispose(); // don't forget to dispose of the presenter
    super.onDisposed();
  }
  
}