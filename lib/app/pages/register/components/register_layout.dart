import 'package:dazle/app/utils/app.dart';
import 'package:dazle/app/widgets/custom_form_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RegisterLayout extends StatelessWidget {
  final double height;
  final String svgAsset;
  final Widget child;
  final Key? formKey;

  RegisterLayout(
      {required this.height,
      required this.svgAsset,
      required this.child,
      this.formKey});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SizedBox(
      height: height,
      child: Stack(
        // overflow: Overflow.visible,
        children: [
          Container(
            height: size.height * 0.33,
            child: Stack(children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: FractionalOffset.bottomCenter,
                      end: FractionalOffset.topCenter,
                      colors: [
                        App.mainColor,
                        Color.fromRGBO(229, 250, 243, 0.9)
                      ]),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0)),
                ),
              ),
              Container(
                  alignment: Alignment.center,
                  child: SizedBox(
                      width: 200,
                      height: 200,
                      child: SvgPicture.asset(svgAsset))),
            ]),
          ),
          Positioned(
              top: size.height * 0.31,
              left: 40,
              right: 40,
              bottom: 40,
              child: CustomFormLayout(
                child: child,
                formKey: formKey,
                isAutoValidate: false,
              ))
        ],
      ),
    );
  }
}
