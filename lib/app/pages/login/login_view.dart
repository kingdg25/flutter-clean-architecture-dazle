import 'package:dwellu/app/utils/dwellu.dart';
import 'package:dwellu/app/widgets/custom_text.dart';
import 'package:dwellu/app/widgets/form%20fields/custom_button.dart';
import 'package:dwellu/app/widgets/form%20fields/custom_flat_button.dart';
import 'package:dwellu/app/widgets/form%20fields/custom_text_field.dart';
import 'package:dwellu/app/widgets/form%20fields/custom_password_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:dwellu/app/pages/login/login_controller.dart';
import 'package:dwellu/app/pages/register/register_view.dart';
import 'package:dwellu/app/widgets/social_login.dart';
import 'package:dwellu/data/repositories/data_authentication_repository.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';



class LoginPage extends View {
  static const String id = 'login_page';

  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}


class _LoginPageState extends ViewState<LoginPage, LoginController> {
  _LoginPageState() : super(LoginController(DataAuthenticationRepository()));

  Widget customComputationPageLayout({
    List<Widget> mainChildren,
    Widget extendedChild
  }) {
    return LayoutBuilder(
      builder: (context, constraint){
        return Scrollbar(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraint.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        children: mainChildren,
                      ),
                    ),
                    extendedChild
                  ]
                )
              )
            )
          )
        );
      }
    );
  }

  forgotPassDialog({LoginController controller}) {
    var _formKey = controller.forgotPassFormKey;
    var _pageController = controller.resetPageController;
    var _changePassFormKey = controller.changePassFormKey;

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),      
          elevation: 1.0,
          backgroundColor: Colors.white,
          child: Container(
            constraints: BoxConstraints(maxWidth: 500, minWidth: 250, maxHeight: 350),
            padding: EdgeInsets.symmetric(vertical: 25.0),
            child: PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: _pageController,
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: customComputationPageLayout(
                    mainChildren: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 40.0),
                        child: Text(
                          "Forgot Password",
                          style: TextStyle(
                            color: Colors.blue[500],
                            fontSize: 18.0
                          ),
                        ),
                      ),
                      SizedBox(height: 30.0),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 40.0),
                        child: TextFormField(
                          controller: controller.forgotEmailTextController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            hintText: 'Input your Email Address',
                          ),
                          validator: (value) {
                            Pattern emailPattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                            RegExp regex = new RegExp(emailPattern);
                            if (!regex.hasMatch(value))
                              return 'Enter Valid Email';
                            else
                              return null;
                          },
                        ),
                      )
                    ],
                    extendedChild: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
                      child: MaterialButton(
                        elevation: 1.0,
                        child: Text(
                          "Send email",
                          style: TextStyle(color: Colors.white70),
                        ),
                        color: Colors.blue[600],
                        onPressed: () {
                          FocusScope.of(context).unfocus();

                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            
                            controller.forgotPassword();
                          }
                        },
                      ),
                    )
                  ),
                ),
                customComputationPageLayout(
                  mainChildren: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 40.0),
                      child: Text(
                        "Verification Code",
                        style: TextStyle(
                          color: Colors.blue[500],
                          fontSize: 18.0
                        ),
                      ),
                    ),
                    SizedBox(height: 30.0),
                    VerificationCode(
                      textStyle: TextStyle(fontSize: 20.0, color: Colors.red[900]),
                      underlineColor: Colors.amber,
                      keyboardType: TextInputType.text,
                      length: 4,
                      // clearAll is NOT required, you can delete it
                      // takes any widget, so you can implement your design
                      clearAll: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'clear all',
                          style: TextStyle(
                            fontSize: 14.0,
                            decoration: TextDecoration.underline,
                            color: Colors.blue[700]
                          ),
                        ),
                      ),
                      onCompleted: (String value) {
                        print('on completed $value');
                        controller.setUserVerificationCode = value;
                      },
                      onEditing: (bool value) {
                        print('on editing $value');
                        if(!value){
                          FocusScope.of(context).unfocus();
                        }
                      },
                    )
                  ],
                  extendedChild: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
                    child: MaterialButton(
                      elevation: 1.0,
                      child: Text(
                        "Verify code",
                        style: TextStyle(color: Colors.white70),
                      ),
                      color: Colors.blue[600],
                      onPressed: () {
                        controller.verifyCode();
                      },
                    ),
                  )
                ),
                Form(
                  key: _changePassFormKey,
                  child: customComputationPageLayout(
                    mainChildren: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 40.0),
                        child: Text(
                          "Change Password",
                          style: TextStyle(
                            color: Colors.blue[500],
                            fontSize: 18.0
                          ),
                        ),
                      ),
                      SizedBox(height: 30.0),
                      TextFormField(
                        controller: controller.resetPasswordTextController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'New Password',
                          hintText: 'Input your New Password',
                        ),
                        validator: (value) {
                          if (value.length < 1 || value == null)
                            return "Enter your new password";
                          else if (value.length < 5)
                            return "Password must be at least 5 characters";
                          else
                            return null;
                        },
                      ),
                    ],
                    extendedChild: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
                      child: MaterialButton(
                        elevation: 1.0,
                        child: Text(
                          "Change Password",
                          style: TextStyle(color: Colors.white70),
                        ),
                        color: Colors.blue[600],
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          
                          if (_changePassFormKey.currentState.validate()) {
                            _changePassFormKey.currentState.save();
                            
                            controller.resetPassword();

                            Navigator.pop(context);
                          }
                        },
                      ),
                    )
                  ),
                )
              ]
            )
          )
        );
      },
    );
  }

  @override
  Widget get view {
    return Scaffold(
      key: globalKey,
      backgroundColor: Dwellu.appMainColor,
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
                          CustomTextField(
                            controller: controller.emailTextController,
                            hintText: 'Email Address',
                            filled: true,
                            hintColor: Colors.white,
                            validator: (value) {
                              Pattern emailPattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                              RegExp regex = new RegExp(emailPattern);
                              if (!regex.hasMatch(value)){
                                return 'Enter Valid Email';
                              }
                              return null;
                            },
                          ),
                          CustomPasswordField(
                            controller: controller.passwordTextController,
                            hintText: 'Password',
                            filled: true,
                            hintColor: Colors.white,
                            validator: (value) {
                              if (value.length < 8) {
                                return "Password must be at least 8 characters.";
                              }
                              return null;
                            },
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
                          forgotPassDialog(
                            controller: controller,
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