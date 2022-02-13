import 'package:dazle/app/pages/forgot_password/components/forgot_password.dart';
import 'package:dazle/app/pages/forgot_password/components/reset_password.dart';
import 'package:dazle/app/pages/forgot_password/components/verify_code.dart';
import 'package:dazle/app/pages/forgot_password/forgot_password_controller.dart';
import 'package:dazle/app/widgets/custom_appbar.dart';
import 'package:dazle/data/repositories/data_authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';



class ForgotPasswordPage extends View {
  ForgotPasswordPage({ Key? key }) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ViewState<ForgotPasswordPage, ForgotPasswordController> {
  _ForgotPasswordPageState() : super(ForgotPasswordController(DataAuthenticationRepository()));

  @override
  Widget get view {
    
    return Scaffold(
      key: globalKey,
      appBar: CustomAppBar(),
      backgroundColor: Colors.white,
      body: ControlledWidgetBuilder<ForgotPasswordController>(
        builder: (context, controller) {
          var _pageController = controller.forgotPasswordPageController;

          return PageView(
            physics: NeverScrollableScrollPhysics(),
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