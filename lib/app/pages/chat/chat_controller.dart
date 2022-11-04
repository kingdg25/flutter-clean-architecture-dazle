import 'package:dazle/app/pages/chat/chat_presenter.dart';
import 'package:dazle/domain/entities/chat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:file_picker/file_picker.dart';

import 'dart:io';

class ChatController extends Controller {
  List<Chat> get chat => _chat.reversed.toList();
  List<Chat> _chat;
  final picker = ImagePicker();

  final ChatPresenter chatPresenter;

  ChatController(chatRepository)
      : _chat = [],
        chatPresenter = ChatPresenter(chatRepository),
        super();
  @override
  void initListeners() {
    getChatMessage();
    chatPresenter.getChatOnNext = (List<Chat> chat) {
      _chat = chat;
      refreshUI();
    };
    chatPresenter.getChatOnError = (e) {};
    chatPresenter.getChatOnComplete = () {};
  }

  void sentText(TextEditingController? messageController) {
    if (messageController!.text.isNotEmpty) {
      final msg = Chat(
        text: messageController.text.toString(),
        date: DateTime.now(),
        isSentByMe: true,
        messageType: ChatMessageType.text,
      );
      _chat.add(msg);
      refreshUI();
      FocusScope.of(getContext()).unfocus();
      messageController.clear();
    }
  }

  /// Take a photo
  Future takePicture() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      refreshUI();
    } else {
      print('No image selected.');
      refreshUI();
    }
  }

  /// Upload from device
  Future uploadFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      refreshUI();
    } else {
      refreshUI();
    }
  }

  /// Attach file
  //   Future attachFile() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     type: FileType.custom,
  //     allowedExtensions: ['pdf', 'doc'],
  //   );

  //   if (result != null) {
  //     File file = File(result.files.single.path.toString());
  //     refreshUI();
  //   } else {
  //     refreshUI();
  //     // User canceled the picker
  //   }
  // }

  Future takeVideo() async {
    final pickedFile = await picker.getVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      refreshUI();
    } else {
      print('No video selected.');
      refreshUI();
    }
  }

  void getChatMessage() {
    chatPresenter.getAllMessage();
  }

  @override
  void onResumed() => debugPrint('On Resumed');

  @override
  void onReassembled() => debugPrint('View is about to be reassembled');

  @override
  void onDeactivated() => debugPrint('View is about to be deactivated');

  @override
  void onDisposed() {
    chatPresenter.dispose();
    super.onDisposed();
  }
}
