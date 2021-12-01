import 'package:dazle/app/pages/connection/components/header_list_tile.dart';
import 'package:dazle/app/pages/connection/connection_controller.dart';
import 'package:dazle/app/pages/invites/invites_view.dart';
import 'package:dazle/app/pages/my_connection/my_connection_view.dart';
import 'package:dazle/app/widgets/custom_text.dart';
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
      appBar: AppBar(
        title: CustomText(
          text: 'Connections',
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          HeaderListTile(
            text: 'View all Connections',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (buildContext) => MyConnectionPage()
                )
              );
            },
          ),
          HeaderListTile(
            text: 'Invites',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (buildContext) => InvitesPage()
                )
              );
            },
          )
        ],
      )
    );
  }
}