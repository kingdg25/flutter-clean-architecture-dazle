import 'package:dazle/data/repositories/data_todo_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:dazle/app/pages/home/home_controller.dart';



class ProfilePage extends View {
  ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}


class _ProfilePageState extends ViewState<ProfilePage, HomeController> {
  _ProfilePageState() : super(HomeController(DataTodoRepository()));

  @override
  Widget get view {
    return Scaffold(
      key: globalKey,
      body: Center(
        child: Text('profile page'),
      ),
    );
  }
}