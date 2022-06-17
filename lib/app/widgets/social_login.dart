import 'package:auth_buttons/auth_buttons.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

class SocialLogin extends StatelessWidget {
  final Function facebookHandleSignIn;
  final Function googleHandleSignIn;
  final Function? appleHandleSignIn;

  SocialLogin(
      {required this.facebookHandleSignIn,
      required this.googleHandleSignIn,
      required this.appleHandleSignIn});

  Widget brookySocialButton(
      {String? text,
      Color textColor = Colors.black,
      Color? backgroundColor = Colors.white,
      Border? border,
      required AssetImage image,
      double imageHeight = 25.0,
      double imageWidth = 25.0,
      required Function? onPressed}) {
    return Tooltip(
      message: text ?? '',
      child: GestureDetector(
        onTap: onPressed as void Function()?,
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
              color: backgroundColor ?? Colors.transparent,
              shape: BoxShape.circle,
              border: border),
          child: Center(
              child: Image(
            image: image,
            height: imageHeight,
            width: imageWidth,
          )),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: true
          ? <Widget>[
              /** ===============================    LOGIN WITH APPLE           ============================================ */
              Platform.isIOS
                  ? AppleAuthButton(
                      onPressed: facebookHandleSignIn as Function()?,
                      darkMode: false,
                      style: AuthButtonStyle(
                        buttonType: AuthButtonType.icon,
                        borderRadius: 100,
                      ),
                    )
                  : Container(),
              Platform.isIOS ? SizedBox(width: 20.0) : Container(),
              /** ===============================    LOGIN WITH GOOGLE           ============================================ */
              GoogleAuthButton(
                onPressed: googleHandleSignIn as Function(),
                darkMode: false,
                text: 'Continue with Google',
                style: AuthButtonStyle(
                  // buttonType: AuthButtonType.,
                  height: 50,
                  textStyle: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                  iconSize: 25,
                  borderRadius: 100,
                  separator: 30,
                ),
              ),
              SizedBox(height: 20.0),
              /** ===============================    LOGIN WITH FACEBOOK           ============================================ */
              FacebookAuthButton(
                onPressed: facebookHandleSignIn as Function(),
                darkMode: false,
                text: 'Continue with Facebook',
                style: AuthButtonStyle(
                  // buttonType: AuthButtonType.secondary,
                  height: 50,
                  width: double.infinity,
                  borderRadius: 100,
                  textStyle: TextStyle(
                    fontSize: 18,
                  ),
                  // separator: 10
                  // iconType: AuthIconType.,
                ),
              ),
            ]
          :

          /** OLD VERSION */ <Widget>[
              /** ===============================    LOGIN WITH APPLE           ============================================ */
              Platform.isIOS
                  ? brookySocialButton(
                      text: 'Sign in with Apple',
                      textColor: Colors.white,
                      backgroundColor: Colors.black,
                      image: AssetImage(
                        "graphics/apple_logo_white.png",
                        // package: "flutter_auth_buttons",
                      ),
                      onPressed: appleHandleSignIn,
                    )
                  : Container(),
              Platform.isIOS ? SizedBox(width: 20.0) : Container(),
              /** ===============================    LOGIN WITH FACEBOOK           ============================================ */
              brookySocialButton(
                text: 'Facebook',
                backgroundColor: Color(0xff3b5999),
                textColor: Colors.white,
                image: AssetImage(
                  "graphics/flogo-HexRBG-Wht-100.png",
                  // package: "flutter_auth_buttons",
                ),
                onPressed: facebookHandleSignIn,
              ),
              SizedBox(width: 20.0),
              /** ===============================    LOGIN WITH GOOGLE           ============================================ */
              brookySocialButton(
                text: 'Google',
                image: AssetImage(
                  "graphics/google-logo.png",
                  package: "flutter_auth_buttons",
                ),
                border: Border.all(color: Colors.grey[300]!),
                onPressed: googleHandleSignIn,
              ),
            ],
    );
  }
}
