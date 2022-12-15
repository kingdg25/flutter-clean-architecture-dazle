import 'package:dazle/app/pages/message_listing/message_listing_presenter.dart';
import 'package:dazle/domain/entities/message.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class MessageListingController extends Controller {
  final MessageListingPresenter messageListingPresenter;

  List<Message> _messageListings;
  List<Message> get messageListings => _messageListings;

  MessageListingController(userRepo)
      : messageListingPresenter = MessageListingPresenter(userRepo),
        _messageListings = <Message>[],
        super();

  @override
  void initListeners() {
    messageListingPresenter.getMessageListings();
    // get message listings
    messageListingPresenter.getMessageListingsOnNext = (List<Message> res) {
      print('get message listings on next $res');
      // if(res != null) {
      _messageListings = res;
      // }
      refreshUI();
    };

    messageListingPresenter.getMessageListingsOnComplete = () {
      print('get message listings on complete');
    };

    messageListingPresenter.getMessageListingsOnError = (e) {
      print('get message listings on error $e');
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
    messageListingPresenter
        .dispose(); // don't forget to dispose of the presenter
    super.onDisposed();
  }
}
