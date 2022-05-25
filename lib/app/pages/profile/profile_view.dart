import 'package:dazle/app/widgets/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../../../data/repositories/data_profile_repository.dart';
import '../../../domain/entities/property.dart';
import '../../../domain/entities/user.dart';
import '../../utils/app.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/profile/box_container.dart';
import '../../widgets/profile/profile_card.dart';
import 'profile_controller.dart';

class ProfilePage extends View {
  final String? uid;
  ProfilePage({Key? key, this.uid}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState(uid);
}

class _ProfilePageState extends ViewState<ProfilePage, ProfileController> {
  User? user;
  List<Property>? listings;
  _ProfilePageState(uid)
      : super(ProfileController(
            dataProfileRepo: DataProfileRepository(), uidToDisplay: uid));

  @override
  Widget get view {
    return Scaffold(
      key: globalKey,
      appBar: AppBar(
        title: CustomText(
          text: 'Profile',
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: [
          Container(
            padding: EdgeInsets.only(right: 10.0),
            child: IconButton(
                icon: Icon(
                  Icons.more_horiz_sharp,
                  color: App.textColor,
                ),
                iconSize: 30,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (buildContext) => SettingsPage()));
                }),
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: ControlledWidgetBuilder<ProfileController>(
        builder: (context, controller) {
          user = controller.userToDisplay;
          listings = controller.listings;

          if (user == null || listings == null) {
            return Center(
              child: CircularProgressIndicator(color: App.mainColor),
            );
          }
          // print("IN THE CONTROLLERERERERERERE $user");
          // controller.getUserToDisplay();
          return SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: controller.getProportionateScreenWidth(16.0)),
                child: Column(
                  children: [
                    SizedBox(
                      height: controller.getProportionateScreenHeight(8.0),
                    ),
                    //
                    CustomImage(
                        assetImage: 'assets/user_profile.png',
                        imageUrl: user!.profilePicture.toString()),
                    SizedBox(
                      height: controller.getProportionateScreenHeight(8.0),
                    ),
                    FittedBox(
                      child: CustomText(
                        text: user!.displayName,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    FittedBox(
                      child: CustomText(
                        text: user!.email,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black.withOpacity(.5),
                      ),
                    ),
                    Divider(
                      height: controller.getProportionateScreenHeight(32.0),
                    ),
                    BoxContainer(
                        widget: Column(
                      children: [
                        ProfileCard(
                          icon: Icons.account_circle_outlined,
                          color: App.mainColor.withOpacity(0.3),
                          colorIcon: Colors.green,
                          title: 'My Profile',
                          tapHandler: controller.profilePage,
                        ),
                        ProfileCard(
                          icon: Icons.notifications_none_outlined,
                          color: Colors.lightBlueAccent,
                          title: 'Notifications',
                          tapHandler: controller.comingSoon,
                        ),
                        ProfileCard(
                          icon: Icons.edit_outlined,
                          color: Colors.purpleAccent.withOpacity(0.3),
                          title: 'Edit Profile',
                          tapHandler: controller.editProfile,
                        ),
                      ],
                    )),
                    SizedBox(
                      height: controller.getProportionateScreenHeight(15.0),
                    ),
                    BoxContainer(
                      widget: Column(
                        children: [
                          ProfileCard(
                            icon: Icons.help_center_outlined,
                            color: Colors.grey,
                            title: 'Help Center',
                            tapHandler: controller.comingSoon,
                          ),
                          ProfileCard(
                            icon: Icons.privacy_tip_outlined,
                            color: Colors.grey,
                            title: 'Privacy Policy',
                            tapHandler: controller.comingSoon,
                          ),
                          ProfileCard(
                            icon: Icons.accessibility_new_outlined,
                            color: Colors.grey,
                            title: 'Accessibility',
                            tapHandler: controller.comingSoon,
                          ),
                          ProfileCard(
                            icon: Icons.handshake_outlined,
                            color: Colors.grey,
                            title: 'End User License Agreement',
                            tapHandler: controller.comingSoon,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: controller.getProportionateScreenHeight(15.0),
                    ),
                    BoxContainer(
                        widget: Column(
                      children: [
                        ProfileCard(
                          icon: Icons.exit_to_app_outlined,
                          color: Colors.redAccent,
                          title: 'Logout',
                          tapHandler: controller.signOut,
                        ),
                      ],
                    )),
                    SizedBox(
                      height: controller.getProportionateScreenHeight(50.0),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
