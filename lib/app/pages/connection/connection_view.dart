import 'package:dazle/data/repositories/data_todo_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:dazle/app/pages/home/home_controller.dart';



class ConnectionPage extends View {
  ConnectionPage({Key key}) : super(key: key);

  @override
  _ConnectionPageState createState() => _ConnectionPageState();
}


class _ConnectionPageState extends ViewState<ConnectionPage, HomeController> {
  _ConnectionPageState() : super(HomeController(DataTodoRepository()));

  @override
  Widget get view {
    return Scaffold(
      key: globalKey,
      body: Center(
        child: Text('connection page'),
      ),
    );
  }
}