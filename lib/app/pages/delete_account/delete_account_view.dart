import 'package:dazle/app/pages/delete_account/components/verify_delete_account_code.dart';
import 'package:dazle/app/pages/delete_account/delete_account_controller.dart';
import 'package:dazle/app/pages/delete_account/components/verify_passsword.dart';
import 'package:dazle/app/widgets/custom_appbar.dart';
import 'package:dazle/data/repositories/data_authentication_repository.dart';
import 'package:dazle/data/repositories/data_listing_repository.dart';
import 'package:dazle/data/repositories/data_profile_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import '../../../domain/entities/user.dart';
import 'components/delete_account.dart';

class DeleteAccountPage extends View {
  final User? user;
  final String? action;
  DeleteAccountPage({Key? key, this.user, this.action}) : super(key: key);

  @override
  _DeleteAccountPageState createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState
    extends ViewState<DeleteAccountPage, DeleteAccountController> {
  _DeleteAccountPageState()
      : super(DeleteAccountController(DataAuthenticationRepository(),
            DataProfileRepository(), DataListingRepository()));

  @override
  Widget get view {
    return ControlledWidgetBuilder<DeleteAccountController>(
        builder: (context, controller) {
      return Scaffold(
        key: globalKey,
        appBar: CustomAppBar(
          centerTitle: true,
          title: controller.action == ''
              ? widget.action
              : '${controller.action} Account',
        ),
        backgroundColor: Colors.white,
        body: ControlledWidgetBuilder<DeleteAccountController>(
          builder: (context, controller) {
            var _pageController = controller.deleteAccountPageController;

            return PageView(
              physics: PageScrollPhysics(),
              // physics: NeverScrollableScrollPhysics(),
              controller: _pageController,
              children: [
                DeleteAccount(
                  user: widget.user,
                ),
                VerifyDeleteAccountCode(),
                VerifyPassword()
              ],
            );
          },
        ),
      );
    });
  }
}
