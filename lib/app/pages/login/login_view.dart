import 'package:dazle/app/pages/login/forgot_password/forgot_password_screen.dart';
import 'package:dazle/app/utils/app.dart';
import 'package:dazle/app/widgets/custom_text.dart';
import 'package:dazle/app/widgets/form_fields/custom_button.dart';
import 'package:dazle/app/widgets/form_fields/custom_email_field.dart';
import 'package:dazle/app/widgets/form_fields/custom_flat_button.dart';
import 'package:dazle/app/widgets/form_fields/custom_password_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:dazle/app/pages/login/login_controller.dart';
import 'package:dazle/app/pages/register/register_view.dart';
import 'package:dazle/app/widgets/social_login.dart';
import 'package:dazle/data/repositories/data_authentication_repository.dart';



class LoginPage extends View {
  static const String id = 'login_page';

  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}


class _LoginPageState extends ViewState<LoginPage, LoginController> {
  _LoginPageState() : super(LoginController(DataAuthenticationRepository()));

  @override
  Widget get view {
    return Scaffold(
      key: globalKey,
      backgroundColor: App.mainColor,
      body: ControlledWidgetBuilder<LoginController>(
        builder: (context, controller) {
          var _formKey = controller.loginFormKey;

          return Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).orientation == Orientation.landscape ? 80.0 : 20.0,
                bottom: 40.0,
                left: 40.0,
                right: 40.0
              ),
              child: Container(
                constraints: BoxConstraints(maxWidth: 300, minWidth: 250),
                child: Column(
                  children: [
                    CustomText(
                      text: "Welcome",
                      fontSize: 30.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                    ),
                    CustomText(
                      text: 'Sign in to continue',
                      fontSize: 18.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                    SizedBox(height: 30.0),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          CustomEmailField(
                            controller: controller.emailTextController,
                            hintText: 'Email Address',
                            filled: true,
                            hintColor: Colors.white
                          ),
                          CustomPasswordField(
                            controller: controller.passwordTextController,
                            hintText: 'Password',
                            filled: true,
                            hintColor: Colors.white
                          )
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      child: CustomFlatButton(
                        text: 'Forgot Password?',
                        color: Colors.white,
                        fontSize: 13.0,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (buildContext) => ForgotPasswordScreen()
                            )
                          );
                        }
                      ),
                    ),
                    SizedBox(height: 30.0),
                    CustomButton(
                      text: 'SIGN IN',
                      backgroudColor: Color.fromRGBO(0, 126, 203, 1.0),
                      expanded: true,
                      borderRadius: 10.0,
                      onPressed: () {
                        FocusScope.of(context).unfocus();

                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          controller.login();
                        }
                      }
                    ),
                    SizedBox(height: 30.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Divider(
                            color: Colors.white,
                            thickness: 1.0,
                            endIndent: 8.0,
                          ),
                        ),
                        CustomText(
                          text: 'OR',
                          fontSize: 11.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                        Expanded(
                          child: Divider(
                            color: Colors.white,
                            thickness: 1.0,
                            indent: 8.0,
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 30.0),
                    SocialLogin(
                      googleHandleSignIn: controller.googleSignIn,
                      facebookHandleSignIn: controller.facebookSignIn,
                      appleHandleSignIn: null, 
                    ),
                    SizedBox(height: 80.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Flexible(
                          child: CustomText(
                            text: "Don’t have an account yet?",
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          )
                        ),
                        CustomFlatButton(
                          text: 'Click here',
                          color: Color.fromRGBO(0, 126, 203, 1.0),
                          fontWeight: FontWeight.w500,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (buildContext) => RegisterPage()
                              )
                            );
                          },
                        )
                      ]
                    )
                  ],
                ),
              ),
            ),
          );
        }
      )
    );
  }
}