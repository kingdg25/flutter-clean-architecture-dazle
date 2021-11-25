import 'package:dazle/data/repositories/data_home_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:dazle/app/pages/home/home_controller.dart';



class HomePage extends View {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}


class _HomePageState extends ViewState<HomePage, HomeController> {
  _HomePageState() : super(HomeController(DataHomeRepository()));

  @override
  Widget get view {
    return Scaffold(
      key: globalKey,
      appBar: AppBar(
        title: Image(
          height: 60.0,
          image: AssetImage('assets/brooky_logo.png'),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        actions: [
          Container(
            padding: EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: Image.asset('assets/icons/find.png'),
              iconSize: 30,
              onPressed: () {
                print("Hello");
              }
            ),
          ),
          ControlledWidgetBuilder<HomeController>(
            builder: (context, controller) {
              return Container(
                padding: EdgeInsets.only(right: 10.0),
                child: IconButton(
                  icon: Icon(Icons.logout, color: Colors.black),
                  onPressed: () {
                    print("Logout");
                    controller.userLogout();
                  }
                ),
              );
            }
          )
        ],
      ),
      body: Center(
        child: Text('home page'),
      ),
    );
  }
}