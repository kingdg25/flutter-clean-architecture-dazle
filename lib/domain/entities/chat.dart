enum ChatMessageType { text, audio, image, video }

class Chat {
  final String text;
  final DateTime date;
  final bool isSentByMe;
  final ChatMessageType? messageType;

  Chat({
    required this.text,
    required this.date,
    required this.isSentByMe,
    this.messageType,
  });
}
