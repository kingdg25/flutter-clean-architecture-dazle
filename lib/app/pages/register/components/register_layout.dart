import 'package:dwellu/app/utils/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class RegisterLayout extends StatelessWidget {
  final String svgAsset;
  final Widget child;

  RegisterLayout({
    @required this.svgAsset,
    @required this.child
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    
    return SizedBox(
      height: size.height,
      child: Stack(
        overflow: Overflow.visible,
        children: [
          Container(
            height: size.height * 0.33,
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: FractionalOffset.bottomCenter,
                      end: FractionalOffset.topCenter,
                      colors: [App.appMainColor, Color.fromRGBO(229, 250, 243, 0.9)]
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0)
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 200,
                    height: 200,
                    child: SvgPicture.asset(svgAsset)
                  )
                ),
              ]
            ),
          ),
          Positioned(
            top: size.height * 0.31,
            left: 0,
            right: 0,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 40.0),  
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 4),
                    blurRadius: 5,
                    color: Color.fromRGBO(0, 0, 0, 0.25)
                  )
                ]
              ),
              child: child,
            )
          )
        ],
      ),
    );
  }
}
