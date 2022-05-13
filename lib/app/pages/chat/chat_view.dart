import 'package:dazle/app/pages/chat/chat_controller.dart';
import 'package:dazle/app/pages/chat/components/chat_body.dart';
import 'package:dazle/app/pages/chat/components/chat_input.dart';
import 'package:dazle/app/pages/chat/components/chat_top.dart';
import 'package:dazle/data/repositories/data_chat_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../../utils/app.dart';

class ChatPage extends View {
  static const id = "/ChatPage";
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends ViewState<ChatPage, ChatController> {
  _ChatPageState() : super(ChatController(DataChatRepository()));

  final TextEditingController messageController = TextEditingController();

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget get view => Scaffold(
        key: globalKey,
        appBar: AppBar(
          leadingWidth: 90,
          backgroundColor: Colors.white,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Colors.black,
                ),
                CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage('assets/client.png'),
                ),
              ],
            ),
          ),
          actions: [
            Container(
              padding: EdgeInsets.only(right: 10.0),
              child: IconButton(
                icon: Icon(
                  Icons.more_horiz_sharp,
                  color: App.textColor,
                ),
                iconSize: 30,
                onPressed: () {},
              ),
            ),
          ],
          title: Row(
            children: [
              ControlledWidgetBuilder<ChatController>(
                builder: (context, controller) {
                  final arguments =
                      (ModalRoute.of(context)?.settings.arguments ??
                          <String, dynamic>{}) as Map;
                  return Text(
                    arguments['msgData'].property!.keywordsToString,
                    style: TextStyle(
                        fontSize: 19,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  );
                },
              )
            ],
          ),
        ),
        body: Column(
          children: [
            ChatTop(),
            ChatBody(),
            ChatInput(messageController: messageController),
          ],
        ),
      );
}
