import 'package:dazle/domain/entities/property.dart';
import 'package:dazle/domain/entities/user.dart';

class Message {
  final Property property;
  final User sender;
  final String message;
  final String timeAgo;
  final String messageType;
  final String avatarURL;

  Message({
    this.property,
    this.sender,
    this.message,
    this.timeAgo,
    this.messageType,
    this.avatarURL
  });

  Message.fromJson(Map<String, dynamic> json)
    : property = json['property'],
      sender = json['sender'],
      message = json['message'],
      timeAgo = json['time_ago'],
      messageType = json['message_type'],
      avatarURL = json['avatar_url'];

  Map<String, dynamic> toJson() => {
    'property': property,
    'sender': sender,
    'message': message,
    'time_ago': timeAgo,
    'message_type': messageType,
    'avatar_url': avatarURL,
  };
}