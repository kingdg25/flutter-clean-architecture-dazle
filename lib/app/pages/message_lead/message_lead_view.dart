import 'package:dazle/app/pages/message_lead/message_lead_controller.dart';
import 'package:dazle/data/repositories/data_message_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';



class MessageLeadPage extends View {
  MessageLeadPage({Key key}) : super(key: key);

  @override
  _MessageLeadPageState createState() => _MessageLeadPageState();
}


class _MessageLeadPageState extends ViewState<MessageLeadPage, MessageLeadController> {
  _MessageLeadPageState() : super(MessageLeadController(DataMessageRepository()));

  @override
  Widget get view {
    return Scaffold(
      key: globalKey,
      backgroundColor: Colors.white,
      body: Center(
        child: Text('message lead page'),
      ),
    );
  }
}