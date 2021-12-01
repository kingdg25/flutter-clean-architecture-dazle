import 'package:dazle/app/pages/my_connection/components/my_connection_list_tile.dart';
import 'package:dazle/app/pages/my_connection/my_connection_controller.dart';
import 'package:dazle/app/utils/app_constant.dart';
import 'package:dazle/app/widgets/custom_appbar.dart';
import 'package:dazle/app/widgets/form_fields/custom_search_field.dart';
import 'package:dazle/data/repositories/data_connection_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';



class MyConnectionPage extends View {
  MyConnectionPage({Key key}) : super(key: key);

  @override
  _MyConnectionPageState createState() => _MyConnectionPageState();
}


class _MyConnectionPageState extends ViewState<MyConnectionPage, MyConnectionController> {
  _MyConnectionPageState() : super(MyConnectionController(DataConnectionRepository()));

  @override
  Widget get view {
    return Scaffold(
      key: globalKey,
      appBar: CustomAppBar(
        title: 'My Connections',
      ),
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Container(
            decoration: AppConstant.bottomBorder,
            child: CustomSearchField(
              hintText: 'Search by name',
              iconData: Icons.menu,
              onPressedButton: () {
              },
            ),
          ),
          MyConnectionListTile()
        ],
      )
    );
  }
}