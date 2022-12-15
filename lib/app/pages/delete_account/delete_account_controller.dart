import 'dart:async';

import 'package:dazle/app/pages/delete_account/delete_account_presenter.dart';
import 'package:dazle/app/pages/login/login_view.dart';
import 'package:dazle/app/pages/main/main_view.dart';
import 'package:dazle/app/utils/app.dart';
import 'package:dazle/app/utils/app_constant.dart';
import 'package:dazle/domain/entities/user.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class DeleteAccountController extends Controller {
  final DeleteAccountPresenter deleteAccountPresenter;

  PageController deleteAccountPageController;
  User? currentUser;

  // delete or deactivate
  String? action;

  // User Login Type
  String? loginType;

  /// Sending Delete Account Code
  String deleteAccountCode;
  bool resendDeleteAccountcode;

  // Verify Delete Code
  TextEditingController verificationCodeTextController;
  StreamController<ErrorAnimationType> verificationCodeErrorController;

  //Verify password
  GlobalKey<FormState> verifyPasswordFormKey;
  final TextEditingController verifyPasswordTextController;

  DeleteAccountController(
      userRepo, dataProfileRepository, dataListingRepository)
      : deleteAccountPresenter = DeleteAccountPresenter(
            userRepo, dataProfileRepository, dataListingRepository),
        deleteAccountPageController = PageController(),
        deleteAccountCode = '',
        action = '',
        loginType = '',
        verificationCodeTextController = TextEditingController(),
        verificationCodeErrorController =
            StreamController<ErrorAnimationType>(),
        resendDeleteAccountcode = false,
        verifyPasswordFormKey = GlobalKey<FormState>(),
        verifyPasswordTextController = TextEditingController(),
        super();

  @override
  void initListeners() {
    getCurrentUSer();
    checkLoginType(user: currentUser);

    //Sending Delete Acount code to Email [Start] *****************
    deleteAccountPresenter.deleleteAccountCodeOnNext = (res) {
      print('Delete Account pass on next $res ${res.toString()}');
      print('Delete Account Code: $res');

      deleteAccountCode = res;

      if (res != null && !resendDeleteAccountcode) {
        //Todo: Add a message pront that email was re sent
      }
    };

    deleteAccountPresenter.deleleteAccountCodeOnComplete = () {
      print('Sending Delete Account Code on Complete');
      AppConstant.showLoader(getContext(), false);
    };

    deleteAccountPresenter.deleleteAccountCodeOnError = (e) {
      print('Sending Delete Account Code on error $e');
      AppConstant.showLoader(getContext(), false);

      if (!e['error']) {
        _statusDialog(false, 'Oops!', '${e['status'] ?? ''}');
      } else {
        _statusDialog(false, 'Something went wrong', '${e.toString()}');
      }
    };

    //Sending Delete Acount code to Email [End]   *****************
    // *************************************************************************
    //Checking Delete Acount code  [Start] *****************
    deleteAccountPresenter.checkDeleteAccountCodeOnNext = (res) {
      print('Check Delete Account Code on next $res ${res.toString()}');
    };

    deleteAccountPresenter.checkDeleteAccountCodeOnComplete = () {
      print('Check Delete Account Code on Complete.');
      AppConstant.showLoader(getContext(), false);
    };

    deleteAccountPresenter.checkDeleteAccountCodeOnError = (e) {
      print('Check Delete Account on Error: $e');
      AppConstant.showLoader(getContext(), false);

      if (!e['error']) {
        _statusDialog(false, 'Oops!', '${e['status'] ?? ''}');
      } else {
        _statusDialog(false, 'Something went wrong', '${e.toString()}');
      }
    };
    //Checking Delete Acount code  [End]   *****************
    // *************************************************************************
    //Deactivate/Acitvate Account [Start] *****************
    deleteAccountPresenter.deactivateActivateAccountOnNext = (res) {
      print('Deactivate/Activate Account on next: $res');
    };

    deleteAccountPresenter.deactivateActivateAccountOnComplete = () async {
      print('Deactivate/Activate Account on complete.');
      AppConstant.showLoader(getContext(), false);
      print('THE ACTION IS : $action');

      if (action == 'Deactivate') {
        AppConstant.statusDialog(
            context: getContext(),
            success: true,
            title: 'Deactivation Success',
            text: 'Account successfully deactivated.',
            onPressed: () {
              App.logOutUser();
              Navigator.of(getContext()).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (Route<dynamic> route) => false);
              // Navigator.popAndPushNamed(getContext(), LoginPage.id);
            });
      } else {
        AppConstant.statusDialog(
            context: getContext(),
            success: true,
            title: 'Account Reactivation Success',
            text: 'Account successfully Reactivated.',
            onPressed: () {
              Navigator.pushReplacement(
                  getContext(),
                  MaterialPageRoute(
                    builder: (context) => MainPage(
                      backCurrentIndex: "HomePage",
                    ),
                  ));
            });
      }
    };

    deleteAccountPresenter.deactivateActivateAccountOnError = (e) {
      print('Deactivate/Activate Account on Error: $e');
      AppConstant.showLoader(getContext(), false);

      if (!e['error']) {
        _statusDialog(false, 'Oops!', '${e['status'] ?? ''}');
      } else {
        _statusDialog(false, 'Something went wrong', '${e.toString()}');
      }
    };
    //Deactivate/Acitvate Account [End]   *****************
    // *************************************************************************
    // Check Login Type [Start] *****************
    deleteAccountPresenter.checkLoginTypeOnNext = (res) {
      print('Check login type on next $res ${res.toString()}');
      print('Login type: $res');

      loginType = res;
    };

    deleteAccountPresenter.checkLoginTypeOnComplete = () {
      print('Check login type on Complete');
      AppConstant.showLoader(getContext(), false);
    };

    deleteAccountPresenter.checkLoginTypeOnError = (e) {
      print('Check login type on error $e');
      AppConstant.showLoader(getContext(), false);

      if (!e['error']) {
        _statusDialog(false, 'Oops!', '${e['status'] ?? ''}');
      } else {
        _statusDialog(false, 'Something went wrong', '${e.toString()}');
      }
    };
    // Check Login Type [End]   *****************
    // *************************************************************************
    // Verify Password [Start] *****************
    deleteAccountPresenter.verifyPasswordOnNext = (res) {
      print('Verify password on next $res ${res.toString()}');
    };

    deleteAccountPresenter.verifyPasswordOnComplete = () async {
      print('Verify password on Complete.');
      AppConstant.showLoader(getContext(), false);
      print('THE ACTION IS : $action');

      if (action == 'Deactivate' || action == 'Reactivate') {
        await deactivateActivateAccount(user: currentUser);
      } else if (action == 'Delete') {
        await deleteAllUserListing(createdById: currentUser!.id);
        await deleteAccount(userId: currentUser!.id);
      }
    };

    deleteAccountPresenter.verifyPasswordOnError = (e) {
      print('Verify password on Error: $e');
      AppConstant.showLoader(getContext(), false);

      if (!e['error']) {
        _statusDialog(false, 'Oops!', '${e['status'] ?? ''}');
      } else {
        _statusDialog(false, 'Something went wrong', '${e.toString()}');
      }
    };
    // Verify Password [End]   *****************
    // *************************************************************************
    // Delete All user listings  [Start] *****************
    deleteAccountPresenter.deleteAllUserListingOnNext = () {
      print('delete listing on next');
    };

    deleteAccountPresenter.deleteAllUserListingOnComplete = () {
      print('delete listing on complete');
      AppConstant.showLoader(getContext(), false);
    };
    deleteAccountPresenter.deleteAllUserListingOnError = (e) {
      print('delete listing on eror $e');
      AppConstant.showLoader(getContext(), false);

      if (!e['error']) {
        _statusDialog(false, 'Oops!', '${e['status'] ?? ''}');
      } else {
        _statusDialog(false, 'Something went wrong', '${e.toString()}');
      }
    };
    // Delete All user listings  [End]   *****************
    // *************************************************************************
    // Delete Account  [Start] *****************
    deleteAccountPresenter.deleteAccountOnNext = () {
      print('delete listing on next');
    };

    deleteAccountPresenter.deleteAccountOnComplete = () {
      print('delete listing on complete');
      AppConstant.showLoader(getContext(), false);
      AppConstant.statusDialog(
          context: getContext(),
          success: true,
          title: 'Account Deletion Success',
          text: 'Account successfully deleted.',
          onPressed: () {
            App.logOutUser();
            Navigator.of(getContext()).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LoginPage()),
                (Route<dynamic> route) => false);
            // Navigator.popAndPushNamed(getContext(), LoginPage.id);
          });
    };
    deleteAccountPresenter.deleteAccountOnError = (e) {
      print('delete listing on eror $e');
      AppConstant.showLoader(getContext(), false);

      if (!e['error']) {
        _statusDialog(false, 'Oops!', '${e['status'] ?? ''}');
      } else {
        _statusDialog(false, 'Something went wrong', '${e.toString()}');
      }
    };
    // Delete Account  [End]   *****************
  }

  Future<void> deleteAccount({String? userId}) async {
    deleteAccountPresenter.deleteAccount(userId: userId);
  }

  Future<void> setAction({required String? selectedAction}) async {
    action = selectedAction;
    refreshUI();
  }

  Future<void> deleteAllUserListing({String? createdById}) async {
    deleteAccountPresenter.deleteAllUserListing(createdById: createdById);
  }

  void verifypassword({String? email, String? password}) async {
    deleteAccountPresenter.verifyPassword(email: email, password: password);
  }

  void checkLoginType({User? user}) {
    deleteAccountPresenter.checkLoginType(user: user);
    refreshUI();
  }

  void sendDeleteAccountCode({bool resend = false, required String email}) {
    print('Delete Account: $email ');
    resendDeleteAccountcode = resend;

    deleteAccountPresenter.deleteAccountCode(email: email, action: action);

    if (resendDeleteAccountcode == false) {
      deleteAccountPageController.jumpToPage(1);
    }
  }

  Future<void> deactivateActivateAccount({User? user}) async {
    deleteAccountPresenter.deactivateActivateAccount(user: user);
  }

  void getCurrentUSer() async {
    currentUser = await App.getUser();
    refreshUI();
    checkLoginType(user: currentUser);
  }

  void verifyCode() async {
    AppConstant.showLoader(getContext(), true);
    var userInputCode = verificationCodeTextController.text;
    print('verify code: $deleteAccountCode, user code input: $userInputCode');

    if (userInputCode.length != 4 || userInputCode != deleteAccountCode) {
      verificationCodeErrorController
          .add(ErrorAnimationType.shake); // Triggering error shake animation
    } else {
      // forgotPasswordPageController.nextPage(
      //     duration: Duration(milliseconds: 500), curve: Curves.ease);
      if (action == 'Deactivate' || action == 'Reactivate') {
        await deactivateActivateAccount(user: currentUser);
      } else if (action == 'Delete') {
        await deleteAllUserListing(createdById: currentUser!.id);
        await deleteAccount(userId: currentUser!.id);
      }
      print('SAKTO!!');
    }
  }

  _statusDialog(bool success, String title, String text) {
    AppConstant.statusDialog(
      context: getContext(),
      success: success,
      title: title,
      text: text,
    );
  }

  @override
  void onResumed() => print('On resumed');

  @override
  void onReassembled() => print('View is about to be reassembled');

  @override
  void onDeactivated() => print('View is about to be deactivated');

  @override
  void onDisposed() {
    deleteAccountPresenter
        .dispose(); // don't forget to dispose of the presenter
    super.onDisposed();
  }
}
