import 'package:dazle/app/pages/login/forgot_password/components/forgot_password.dart';
import 'package:dazle/app/pages/login/forgot_password/components/reset_password.dart';
import 'package:dazle/app/pages/login/forgot_password/components/verify_code.dart';
import 'package:dazle/app/pages/login/login_controller.dart';
import 'package:dazle/app/widgets/custom_appbar.dart';
import 'package:dazle/data/repositories/data_authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';



class ForgotPasswordScreen extends View {
  ForgotPasswordScreen({ Key key }) : super(key: key);

  @override
  _ForgotPasswordMainState createState() => _ForgotPasswordMainState();
}

class _ForgotPasswordMainState extends ViewState<ForgotPasswordScreen, LoginController> {
  _ForgotPasswordMainState() : super(LoginController(DataAuthenticationRepository()));

  @override
  Widget get view {
    
    return Scaffold(
      key: globalKey,
      appBar: CustomAppBar(),
      backgroundColor: Colors.white,
      body: ControlledWidgetBuilder<LoginController>(
        builder: (context, controller) {
          var _pageController = controller.forgotPasswordPageController;

          return PageView(
            // physics: NeverScrollableScrollPhysics(),
            controller: _pageController,
            children: [
              ForgotPassword(),
              VerifyCode(),
              ResetPassword()
            ],
          );
        }
      )
    );
  }
}