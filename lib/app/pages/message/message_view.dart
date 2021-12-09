import 'package:dazle/app/pages/message/message_controller.dart';
import 'package:dazle/app/widgets/custom_text.dart';
import 'package:dazle/data/repositories/data_message_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';



class MessagePage extends View {
  MessagePage({Key key}) : super(key: key);

  @override
  _MessagePageState createState() => _MessagePageState();
}


class _MessagePageState extends ViewState<MessagePage, MessageController> {
  _MessagePageState() : super(MessageController(DataMessageRepository()));

  @override
  Widget get view {
    return Scaffold(
      key: globalKey,
      appBar: AppBar(
        title: CustomText(
          text: 'Inbox',
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Text('message page'),
      ),
    );
  }
}