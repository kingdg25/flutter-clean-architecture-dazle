import 'package:cached_network_image/cached_network_image.dart';
import 'package:dazle/app/pages/delete_account/delete_account_controller.dart';
import 'package:dazle/app/utils/app.dart';
import 'package:dazle/app/widgets/custom_text.dart';
import 'package:dazle/app/widgets/form_fields/custom_button.dart';
import 'package:dazle/app/widgets/form_fields/custom_email_field.dart';
import 'package:dazle/app/widgets/form_fields/custom_field_layout.dart';
import 'package:dazle/app/widgets/form_fields/custom_flat_button.dart';
import 'package:dazle/app/widgets/form_fields/custom_icon_button.dart';
import 'package:dazle/app/widgets/form_fields/title_field.dart';
import 'package:dazle/domain/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:dazle/app/pages/delete_account/delete_account_controller.dart';

class DeleteAccount extends StatelessWidget {
  final User? user;
  const DeleteAccount({Key? key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Declaring Controller
    DeleteAccountController controller =
        FlutterCleanArchitecture.getController<DeleteAccountController>(
            context);
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).orientation == Orientation.landscape
                  ? 80.0
                  : 20.0,
              bottom: 40.0,
              left: 20.0,
              right: 20.0),
          child: ListView(
            children: [
              Center(
                child: CachedNetworkImage(
                  imageUrl: this.user!.profilePicture.toString(),
                  imageBuilder: (context, imageProvider) => CircleAvatar(
                    radius: 60,
                    backgroundImage: imageProvider,
                    backgroundColor: App.mainColor,
                  ),
                  progressIndicatorBuilder: (context, url, progress) => Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color?>(App.mainColor),
                      value: progress.progress,
                    ),
                  ),
                  errorWidget: (context, url, error) => CircleAvatar(
                    backgroundColor: App.mainColor,
                    radius: 95,
                    backgroundImage: AssetImage('assets/user_profile.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Column(
                  children: [
                    CustomText(
                      textAlign: TextAlign.center,
                      text:
                          controller.currentUser?.accountStatus == 'Deactivated'
                              ? 'Reactivate your account?'
                              : 'Deactivate your account instead of deleting?',
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    controller.currentUser?.accountStatus == 'Deactivated'
                        ? Container()
                        : ListTile(
                            // leading: Icon(Icons.abc),
                            title: CustomText(
                              text: 'Deactivating your account is temporary',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                            subtitle: CustomText(
                                text:
                                    'Your profile and listings will be hidden until you enable it by logging back in.'),
                          ),
                    SizedBox(
                      height: 10,
                    ),
                    controller.currentUser?.accountStatus == 'Deactivated'
                        ? Container()
                        : ListTile(
                            // leading: Icon(Icons.abc),
                            title: CustomText(
                              text: 'Deleting your account is permanent',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                            subtitle: CustomText(
                                text:
                                    'Your profile and listings will be permanently deleted.'),
                          ),
                  ],
                ),
              )
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Divider(
              // color: Colors.red,
              height: 1,
              thickness: 1,
            ),
            Container(
              color: Colors.white,
              constraints: BoxConstraints(
                  maxHeight: 150, maxWidth: MediaQuery.of(context).size.width),
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              child: Column(
                children: [
                  CustomButton(
                      text:
                          controller.currentUser?.accountStatus == 'Deactivated'
                              ? 'Reactivate Account'
                              : 'Deactivate Account',
                      fontSize: 16,
                      height: 40,
                      expanded: true,
                      onPressed: () async {
                        String deleteAction = '';
                        if (controller.currentUser?.accountStatus ==
                            'Deactivated') {
                          deleteAction = 'Reactivate';
                        } else {
                          deleteAction = 'Deactivate';
                        }
                        await controller.setAction(
                            selectedAction: deleteAction);
                        print('Action is: ${controller.action}');
                        print('login type of user: ${controller.loginType}');
                        if (controller.loginType == 'email&pass') {
                          controller.deleteAccountPageController.jumpToPage(3);
                        } else {
                          controller.sendDeleteAccountCode(
                              email: this.user!.email!);
                        }
                      }),
                  SizedBox(
                    height: 10,
                  ),
                  controller.currentUser?.accountStatus == 'Deactivated'
                      ? Container()
                      : CustomFlatButton(
                          text: 'Delete Account',
                          fontSize: 17,
                          color: App.mainColor,
                          fontWeight: FontWeight.w500,
                          onPressed: () async {
                            await controller.setAction(
                                selectedAction: 'Delete');
                            print('Action is: ${controller.action}');
                            print(
                                'login type of user: ${controller.loginType}');
                            if (controller.loginType != 'email&pass') {
                              controller.sendDeleteAccountCode(
                                  email: this.user!.email!);
                            } else {
                              controller.deleteAccountPageController
                                  .jumpToPage(3);
                            }
                          },
                        )
                ],
              ),
            ),
          ]),
        )
      ],
    );
  }
}
