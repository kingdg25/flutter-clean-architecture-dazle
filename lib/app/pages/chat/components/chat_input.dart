import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import '../../../../domain/entities/chat.dart';
import '../../../utils/app.dart';
import '../chat_controller.dart';

class ChatInput extends StatefulWidget {
  final TextEditingController? messageController;
  const ChatInput({Key? key, this.messageController}) : super(key: key);

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ControlledWidgetBuilder<ChatController>(
          builder: (context, controller) => Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.photo_camera_rounded,
                  size: 30,
                  color: Colors.grey,
                ),
                onPressed: () {
                  controller.takePicture();
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.insert_photo_rounded,
                  size: 30,
                  color: Colors.grey,
                ),
                onPressed: () {
                  controller.uploadFromGallery();
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.gif_box_rounded,
                  size: 30,
                  color: Colors.grey,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(
                  Icons.attach_file_rounded,
                  size: 25,
                  color: Colors.grey,
                ),
                onPressed: () {
                  // controller.attachFile();
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.videocam,
                  size: 30,
                  color: Colors.grey,
                ),
                onPressed: () {
                  // controller.takeVideo();
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.more_horiz,
                  size: 30,
                  color: Colors.grey,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10, left: 10, bottom: 8),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: 5),
                  child: ControlledWidgetBuilder<ChatController>(
                    builder: (context, controller) => TextField(
                      controller: widget.messageController,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Type a message...',
                          enabled: true,
                          contentPadding: const EdgeInsets.only(
                            left: 14.0,
                            bottom: 8.0,
                            top: 8.0,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black87),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade500),
                            borderRadius: BorderRadius.circular(10),
                          )),
                      onSubmitted: (text) {
                        final tempText = Chat(
                          text: text,
                          date: DateTime.now(),
                          isSentByMe: true,
                        );
                        setState(() {
                          controller.chat.add(tempText);
                          widget.messageController?.clear();
                        });
                      },
                    ),
                  ),
                ),
              ),
              ControlledWidgetBuilder<ChatController>(
                builder: (context, controller) => CircleAvatar(
                  radius: 20,
                  backgroundColor: App.mainColor,
                  child: IconButton(
                    onPressed: () =>
                        controller.sentText(widget.messageController),
                    icon: Icon(
                      Icons.send_sharp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
