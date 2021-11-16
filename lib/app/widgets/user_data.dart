import 'package:flutter/material.dart';
import 'package:dazle/app/pages/home/home_controller.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';


class UserData extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    HomeController controller = FlutterCleanArchitecture.getController<HomeController>(context);
    return Container(
      height: 50.0,
      alignment: FractionalOffset.center,
      decoration: BoxDecoration(
        color: Color.fromRGBO(230, 38, 39, 1.0),
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: Text(
        controller.displayName ?? '',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.w300,
          letterSpacing: 0.4
        ),
      ),
    );
  }
}
