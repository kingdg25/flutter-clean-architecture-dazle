import 'package:dazle/app/pages/chat/components/text_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';

import '../../../../domain/entities/chat.dart';
import '../chat_controller.dart';

class ChatBody extends StatelessWidget {
  const ChatBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget? messageContaint(Chat message) {
      switch (message.messageType) {
        case ChatMessageType.text:
          return TextMessage(message: message);
        default:
          return const SizedBox();
      }
    }

    return Expanded(
      child: ControlledWidgetBuilder<ChatController>(
        builder: (context, controller) => GroupedListView<Chat, DateTime>(
          padding: const EdgeInsets.all(5),
          reverse: false,
          order: GroupedListOrder.DESC,
          useStickyGroupSeparators: true,
          floatingHeader: true,
          elements: controller.chat,
          groupBy: (message) => DateTime(
            message.date.year,
            message.date.month,
            message.date.day,
          ),
          groupHeaderBuilder: (Chat message) => ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Container(
              height: 32,
              color: Colors.grey[300],
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  DateFormat.yMMMd().format(message.date),
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),
          itemBuilder: (context, Chat message) => Row(
            mainAxisAlignment: message.isSentByMe
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  !message.isSentByMe
                      ? CircleAvatar(
                          radius: 20,
                          backgroundImage: AssetImage('assets/client.png'),
                        )
                      : Container(),
                  messageContaint(message)!,
                  message.isSentByMe
                      ? CircleAvatar(
                          radius: 20,
                          backgroundImage:
                              AssetImage('assets/user_profile.png'),
                        )
                      : Container(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
