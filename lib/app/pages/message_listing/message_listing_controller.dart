import 'package:dazle/app/pages/message_listing/message_listing_presenter.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';


class MessageListingController extends Controller {
  final MessageListingPresenter messageListingPresenter;

  MessageListingController(userRepo)
    : messageListingPresenter = MessageListingPresenter(),
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
    messageListingPresenter.dispose(); // don't forget to dispose of the presenter
    super.onDisposed();
  }
  
}