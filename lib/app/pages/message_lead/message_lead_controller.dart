import 'package:dazle/app/pages/message_lead/message_lead_presenter.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';


class MessageLeadController extends Controller {
  final MessageLeadPresenter messageLeadPresenter;

  MessageLeadController(userRepo)
    : messageLeadPresenter = MessageLeadPresenter(),
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
    messageLeadPresenter.dispose(); // don't forget to dispose of the presenter
    super.onDisposed();
  }
  
}