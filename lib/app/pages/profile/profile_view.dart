import 'package:dazle/app/pages/edit_profile/edit_profile_view.dart';
import 'package:dazle/app/pages/profile/profile_controller.dart';
import 'package:dazle/app/utils/app.dart';
import 'package:dazle/app/widgets/custom_text.dart';
import 'package:dazle/app/widgets/form_fields/custom_button.dart';
import 'package:dazle/app/widgets/form_fields/custom_field_layout.dart';
import 'package:dazle/data/repositories/data_profile_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';



class ProfilePage extends View {
  ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}


class _ProfilePageState extends ViewState<ProfilePage, ProfileController> {
  _ProfilePageState() : super(ProfileController(DataProfileRepository()));

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
                print("Hello");
              }
            ),
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: ControlledWidgetBuilder<ProfileController>(
        builder: (context, controller) {
          var user = controller.user;

          if ( user == null ) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 40),
              child: Column(
                children: [
                  Center(
                    child: Image(
                      image: AssetImage('assets/user_profile.png'),
                      width: 200,
                      height: 200,
                    ),
                  ),
                  CustomText(
                    text: user.displayName ?? '',
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(height: 5),
                  CustomText(
                    text: 'Real Estate ${user.position ?? ''}',
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  SizedBox(height: 10),
                  CustomFieldLayout(
                    child: CustomText(
                      text: user.aboutMe ?? '',
                      fontSize: 11,
                      color: App.hintColor,
                      fontWeight: FontWeight.w500,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomButton(
                        text: 'Edit Profile',
                        width: 120,
                        borderRadius: 30,
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (buildContext) => EditProfilePage(
                                user: user,
                              )
                            )
                          );

                          controller.getCurrentUser();
                        }
                      ),
                      SizedBox(width: 8),
                      CustomButton(
                        text: 'Share Profile',
                        width: 120,
                        borderRadius: 30,
                        main: false,
                        onPressed: () {}
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                  CustomFieldLayout(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            CustomText(
                              text: '25',
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                            CustomText(
                              text: 'LISTING',
                              fontSize: 10,
                              color: App.hintColor,
                              fontWeight: FontWeight.w400,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 25,
                          child: VerticalDivider(
                            color: App.hintColor,
                            thickness: 1,
                          ),
                        ),
                        Column(
                          children: [
                            CustomText(
                              text: '125',
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                            CustomText(
                              text: 'CONNECTIONS',
                              fontSize: 10,
                              color: App.hintColor,
                              fontWeight: FontWeight.w400,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 25,
                          child: VerticalDivider(
                            color: App.hintColor,
                            thickness: 1,
                          ),
                        ),
                        Column(
                          children: [
                            CustomText(
                              text: '250',
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                            CustomText(
                              text: 'FOLLOWING',
                              fontSize: 10,
                              color: App.hintColor,
                              fontWeight: FontWeight.w400,
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ]
              ),
            )
          );
        }
      )
    );
  }
}