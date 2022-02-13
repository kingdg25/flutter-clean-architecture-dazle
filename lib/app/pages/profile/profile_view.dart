import 'package:dazle/app/pages/edit_profile/edit_profile_view.dart';
import 'package:dazle/app/pages/profile/profile_controller.dart';
import 'package:dazle/app/pages/settings/settings_view.dart';
import 'package:dazle/app/utils/app.dart';
import 'package:dazle/app/widgets/custom_richtext.dart';
import 'package:dazle/app/widgets/custom_text.dart';
import 'package:dazle/app/widgets/form_fields/custom_button.dart';
import 'package:dazle/app/widgets/form_fields/custom_field_layout.dart';
import 'package:dazle/app/widgets/listing/listing_property_list_tile.dart';
import 'package:dazle/data/repositories/data_profile_repository.dart';
import 'package:dazle/domain/entities/property.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:dazle/app/pages/verify_profile/verify_profile_view.dart';

class ProfilePage extends View {
  final String? uid;
  ProfilePage({Key? key, this.uid}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState(uid);
}

class _ProfilePageState extends ViewState<ProfilePage, ProfileController> {
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
          var user = controller.userToDisplay;
          print("IN THE CONTROLLERERERERERERE $user");
          controller.getUserToDisplay();

          if (user == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return SingleChildScrollView(
              child: Container(
            padding: EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 20),
            child: Column(children: [
              Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(221, 99, 110, 0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(20.0),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.error_outline_outlined,
                        color: Color.fromRGBO(226, 87, 76, 1),
                        size: 26.0,
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                          child: CustomRichText(
                        mainText:
                            'Your profile is still unverified, due to this you can only access limited features. of the app. Click this link to ',
                        mainTextFontWeight: FontWeight.normal,
                        valueText: 'verify now.',
                        valueTextDecoration: TextDecoration.underline,
                        valueTextCallback: () {
                          print('Value text Callback called!');
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (buildContext) => VerifyProfilePage(
                                        userPosition: user.position,
                                      )));
                        },
                      ))
                    ]),
              ),
              Center(
                child: Image(
                  image: AssetImage('assets/user_profile.png'),
                  width: 200,
                  height: 200,
                ),
              ),
              CustomText(
                text: user.displayName,
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
                                    )));

                        controller.getCurrentUser();
                      }),
                  SizedBox(width: 8),
                  CustomButton(
                      text: 'Share Profile',
                      width: 120,
                      borderRadius: 30,
                      main: false,
                      onPressed: () async {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (buildContext) => ProfilePage()));
                      })
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
              ),
              Container(
                width: double.infinity,
                child: ListingPropertyListTile(
                    items: controller.listings,
                    height: 300.0,
                    padding: EdgeInsets.symmetric(vertical: 10.0)),
              )
            ]),
          ));
        }));
  }
}
