import 'package:dazle/app/pages/edit_profile/edit_profile_view.dart';
import 'package:dazle/app/pages/profile/profile_controller.dart';
import 'package:dazle/app/utils/app.dart';
import 'package:dazle/app/widgets/custom_text.dart';
import 'package:dazle/app/widgets/form_fields/custom_button.dart';
import 'package:dazle/data/repositories/data_profile_repository.dart';
import 'package:dazle/domain/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';



class ProfilePage extends View {
  final User user;

  ProfilePage({
    Key key,
    this.user
  }) : super(key: key);

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

          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
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
                    text: widget.user.displayName ?? '',
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(height: 5),
                  CustomText(
                    text: 'Real Estate ${widget.user.position ?? ''}',
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  SizedBox(height: 10),
                  CustomText(
                    text: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s.",
                    fontSize: 11,
                    color: App.hintColor,
                    fontWeight: FontWeight.w500,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomButton(
                        text: 'Edit Profile',
                        width: 120,
                        borderRadius: 30,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (buildContext) => EditProfilePage(
                                user: widget.user,
                              )
                            )
                          );
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
                  Row(
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