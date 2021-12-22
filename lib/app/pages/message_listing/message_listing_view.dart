import 'package:dazle/app/pages/message_listing/message_listing_controller.dart';
import 'package:dazle/data/repositories/data_message_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';



class MessageListingPage extends View {
  MessageListingPage({Key key}) : super(key: key);

  @override
  _MessageListingPageState createState() => _MessageListingPageState();
}


class _MessageListingPageState extends ViewState<MessageListingPage, MessageListingController> {
  _MessageListingPageState() : super(MessageListingController(DataMessageRepository()));

  @override
  Widget get view {
    return Scaffold(
      key: globalKey,
      backgroundColor: Colors.white,
      body: Center(
        child: Text('message listing page'),
      ),
    );
  }
}