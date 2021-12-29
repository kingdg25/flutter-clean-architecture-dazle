import 'package:dazle/app/pages/message_listing/message_listing_controller.dart';
import 'package:dazle/app/widgets/message/message_property_list_tile.dart';
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
      body: ControlledWidgetBuilder<MessageListingController>(
        builder: (context, controller) {
          
          return ListView(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
            children: [
              MessagePropertyListTile(
                items: controller.messageListings
              )
            ],
          );
        
        }
      )
    );
  }
}