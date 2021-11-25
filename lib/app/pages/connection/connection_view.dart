import 'package:dazle/app/pages/connection/connection_controller.dart';
import 'package:dazle/data/repositories/data_connection_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';



class ConnectionPage extends View {
  ConnectionPage({Key key}) : super(key: key);

  @override
  _ConnectionPageState createState() => _ConnectionPageState();
}


class _ConnectionPageState extends ViewState<ConnectionPage, ConnectionController> {
  _ConnectionPageState() : super(ConnectionController(DataConnectionRepository()));

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