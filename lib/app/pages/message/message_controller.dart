import 'package:dazle/app/pages/message/message_presenter.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';


class MessageController extends Controller {
  final MessagePresenter messagePresenter;

  MessageController(userRepo)
    : messagePresenter = MessagePresenter(),
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
    messagePresenter.dispose(); // don't forget to dispose of the presenter
    super.onDisposed();
  }
  
}