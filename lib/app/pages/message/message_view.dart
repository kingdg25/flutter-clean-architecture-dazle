import 'package:dazle/data/repositories/data_todo_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:dazle/app/pages/home/home_controller.dart';



class MessagePage extends View {
  MessagePage({Key key}) : super(key: key);

  @override
  _MessagePageState createState() => _MessagePageState();
}


class _MessagePageState extends ViewState<MessagePage, HomeController> {
  _MessagePageState() : super(HomeController(DataTodoRepository()));

  @override
  Widget get view {
    return Scaffold(
      key: globalKey,
      body: Center(
        child: Text('message page'),
      ),
    );
  }
}