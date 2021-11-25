import 'package:dazle/data/repositories/data_todo_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:dazle/app/pages/home/home_controller.dart';



class ListingPage extends View {
  ListingPage({Key key}) : super(key: key);

  @override
  _ListingPageState createState() => _ListingPageState();
}


class _ListingPageState extends ViewState<ListingPage, HomeController> {
  _ListingPageState() : super(HomeController(DataTodoRepository()));

  @override
  Widget get view {
    return Scaffold(
      key: globalKey,
      body: Center(
        child: Text('listing page'),
      ),
    );
  }
}