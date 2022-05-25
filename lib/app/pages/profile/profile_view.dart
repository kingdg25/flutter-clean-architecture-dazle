import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../../../data/repositories/data_profile_repository.dart';
import '../../../domain/entities/property.dart';
import '../../../domain/entities/user.dart';
import '../../utils/app.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/profile/profile_info.dart';
import '../settings/settings_view.dart';
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
            child: Column(
              children: [
                /**reserve*/
                // Container(
                //   decoration: BoxDecoration(
                //     color: Color.fromRGBO(221, 99, 110, 0.5),
                //     borderRadius: BorderRadius.circular(10),
                //   ),
                //   padding: EdgeInsets.all(20.0),
                //   child: Row(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         Icon(
                //           Icons.error_outline_outlined,
                //           color: Color.fromRGBO(226, 87, 76, 1),
                //           size: 26.0,
                //         ),
                //         SizedBox(
                //           width: 10.0,
                //         ),
                //         Expanded(
                //             child: CustomRichText(
                //           mainText:
                //               'Your profile is still unverified, due to this you can only access limited features. of the app. Click this link to ',
                //           mainTextFontWeight: FontWeight.normal,
                //           valueText: 'verify now.',
                //           valueTextDecoration: TextDecoration.underline,
                //           valueTextCallback: () {
                //             print('Value text Callback called!');
                //             Navigator.push(
                //                 context,
                //                 MaterialPageRoute(
                //                     builder: (buildContext) => VerifyProfilePage(
                //                           userPosition: user.position,
                //                         )));
                //           },
                //         ))
                //       ]),
                // ),
                ProfileInfo(
                  user!,
                  listings: listings!,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

//============================================
