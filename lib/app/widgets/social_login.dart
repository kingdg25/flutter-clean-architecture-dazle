import 'package:dwellu/app/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

class SocialLogin extends StatelessWidget {
  final Function facebookHandleSignIn;
  final Function googleHandleSignIn;
  final Function appleHandleSignIn;

  SocialLogin({
    @required this.facebookHandleSignIn, 
    @required this.googleHandleSignIn, 
    @required this.appleHandleSignIn
  });


  Widget brookySocialButton({
    String text,
    Color textColor = Colors.black,
    Color backgroundColor = Colors.white,
    Border border,
    @required AssetImage image,
    double imageHeight = 15.0,
    double imageWidth = 15.0,
    @required Function onPressed
  }){
    double borderRadius = 24.0;
    
    return Material(
      elevation: 5.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
      child: Container(
        constraints: BoxConstraints(maxWidth: 200),
        height: 48.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          color: backgroundColor,
          border: border
        ),
        child: FlatButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(borderRadius))
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.only(right: 6.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                child: Center(
                  child: Image(
                    image: image,
                    height: imageHeight,
                    width: imageWidth,
                  ),
                ),
              ),
              Flexible(
                child: CustomText(
                  text: text,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                  textAlign: TextAlign.center
                ),
              ),
            ]
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            /** ===============================    LOGIN WITH FACEBOOK           ============================================ */
            Flexible(
              child: brookySocialButton(
                text: 'Facebook',
                backgroundColor: Color(0xff3b5999),
                textColor: Colors.white,
                image: AssetImage(
                  "graphics/flogo-HexRBG-Wht-100.png",
                  package: "flutter_auth_buttons",
                ),
                onPressed: facebookHandleSignIn,
              )
            ),
            SizedBox(width: 10.0),
            /** ===============================    LOGIN WITH GOOGLE           ============================================ */
            Flexible(
              child: brookySocialButton(
                text: 'Google',
                image: AssetImage(
                  "graphics/google-logo.png",
                  package: "flutter_auth_buttons",
                ),
                border: Border.all(
                  color: Colors.grey[300]
                ),
                onPressed: googleHandleSignIn,
              ),
            )
          ],
        ),
        SizedBox(height: 10.0),
        /** ===============================    LOGIN WITH APPLE           ============================================ */
        Platform.isIOS ?
        brookySocialButton(
          text: 'Sign in with Apple',
          textColor: Colors.white,
          backgroundColor: Colors.black,
          imageHeight: 17.0,
          imageWidth: 17.0,
          image: AssetImage(
            "graphics/apple_logo_white.png",
            package: "flutter_auth_buttons",
          ),
          onPressed: appleHandleSignIn,
        ) : Container(),
      ],
    );
  }
}
