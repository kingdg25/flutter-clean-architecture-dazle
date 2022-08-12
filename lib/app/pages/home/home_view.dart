import 'package:dazle/app/pages/create_listing/create_listing_view.dart';
import 'package:dazle/app/pages/filter/filter_view.dart';
import 'package:dazle/app/pages/find_match/find_match_view.dart';
import 'package:dazle/app/pages/home/components/header_home_tile.dart';
import 'package:dazle/app/pages/home/components/property_list_tile.dart';
import 'package:dazle/app/pages/home/components/photo_list_tile.dart';
import 'package:dazle/app/pages/login/login_view.dart';
import 'package:dazle/app/pages/main/main_view.dart';
import 'package:dazle/app/pages/profile/profile_view.dart';
import 'package:dazle/app/utils/app.dart';
import 'package:dazle/app/utils/app_constant.dart';
import 'package:dazle/app/widgets/custom_progress_bar.dart';
import 'package:dazle/app/widgets/custom_text.dart';
import 'package:dazle/app/widgets/form_fields/custom_search_field.dart';
import 'package:dazle/data/repositories/data_home_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:dazle/app/pages/home/home_controller.dart';
import 'package:dazle/app/pages/listing_details/listing_details_view.dart';
import 'package:upgrader/upgrader.dart';
import 'dart:io' show Platform;

class HomePage extends View {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ViewState<HomePage, HomeController> {
  _HomePageState() : super(HomeController(DataHomeRepository()));
  @override
  Widget get view {
    return UpgradeAlert(
      upgrader: Platform.isIOS
          ? Upgrader(dialogStyle: UpgradeDialogStyle.cupertino)
          : null,
      child: WillPopScope(
          onWillPop: () async {
            AppConstant.deleteDialog(
                context: context,
                title: 'Log Out',
                text: 'Are you sure you want to log out?',
                onConfirm: () {
                  print('user logout home controller');
                  AppConstant.showLoader(context, true);
                  App.logOutUser();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => LoginPage()),
                      (Route<dynamic> route) => false);
                  return true;
                });
            return false;
          },
          child: Scaffold(
            key: globalKey,
            appBar: AppBar(
              title: Image(
                height: 30.0,
                image: AssetImage('assets/dazle_sample_logo.png'),
              ),
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              actions: [
                Container(
                  padding: EdgeInsets.only(right: 10.0),
                  child: IconButton(
                      icon: Image.asset('assets/user_profile.png'),
                      iconSize: 45,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (buildContext) => ProfilePage()));
                      }),
                )
              ],
            ),
            floatingActionButton: FractionallySizedBox(
                widthFactor: 0.90,
                child: ControlledWidgetBuilder<HomeController>(
                    builder: (context, controller) {
                  return FloatingActionButton.extended(
                      onPressed: () {
                        if (controller.user?.accountStatus != 'Deactivated') {
                          controller.mixpanel!.track('Create New Listing',
                              properties: {'Page Pressed': 'Home Page'});
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (buildContext) =>
                                      CreateListingPage()));
                        } else {
                          AppConstant.statusDialog(
                              context: context,
                              title: 'Action not Allowed',
                              text: 'Please Reactivate your account first.',
                              success: false);
                        }
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      tooltip: 'Create listing',
                      backgroundColor: App.mainColor,
                      label: const Text('Add New Listing')
                      // child: Icon(Icons.add)
                      );
                })),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            body: ControlledWidgetBuilder<HomeController>(
                builder: (context, controller) {
              final double screenHeight = MediaQuery.of(context).size.height;
              final double screenWidth = MediaQuery.of(context).size.width;

              return ListView(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: screenWidth,
                        height: screenHeight / 2,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                            image: AssetImage('assets/header.jpg'),
                          ),
                        ),
                      ),
                      Container(
                        width: screenWidth,
                        height: (screenWidth < 375)
                            ? screenHeight / 3
                            : screenHeight / 2,
                        decoration: BoxDecoration(
                          boxShadow: [AppConstant.boxShadow],
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: 1,
                        right: 1,
                        child: true
                            ? Container()
                            : CustomSearchField(
                                controller: controller.searchTextController,
                                hintText: 'Building, Neighboorhood, City',
                                iconData: Icons.contacts_outlined,
                                borderRadius: 10.0,
                                filled: true,
                                fillColor: Colors.white,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                withIcon: true,
                                isAssetIcon: true,
                                asset: 'assets/icons/filter.png',
                                onChanged: (value) {
                                  // controller.searchUser();
                                },
                                suggestionsCallback: (pattern) async {
                                  return [];
                                },
                                onSuggestionSelected: (suggestion) {
                                  // controller.searchTextController.text = suggestion;
                                  // controller.getMyConnection(filterByName: suggestion);
                                },
                                onSubmitted: (value) {
                                  // controller.getMyConnection(filterByName: value);
                                },
                                onPressedButton: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (buildContext) =>
                                              FilterPage()));
                                },
                              ),
                      ),
                      Positioned(
                        bottom: screenHeight / 14,
                        left: 20,
                        right: screenWidth / 2.6,
                        child: Text.rich(
                            TextSpan(children: [
                              TextSpan(
                                  text: "Dazle\n",
                                  style: TextStyle(
                                      fontSize: 30.0,
                                      fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text:
                                      "Matching brokers with properties to brokers with clients.",
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      height: 1.5,
                                      fontWeight: FontWeight.w600)),
                            ]),
                            style: App.textStyle(
                              color: Colors.white,
                            )),
                      )
                    ],
                  ),
                  HeaderHomeTile(
                    title: 'Your Listings',
                    subTitle: 'Your Listings',
                    child: PropertyListTile(
                      items: controller.myListing,
                      mixpanel: controller.mixpanel,
                    ),
                    viewAllOnTap: () {
                      print('view all your listings');
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MainPage(
                              backCurrentIndex: "ListingPage",
                            ),
                          ));
                    },
                  ),
                  HeaderHomeTile(
                    title: 'Spotlight',
                    subTitle: 'Properties you might be interested in',
                    child: PhotoListTile(items: controller.spotLight),
                    viewAllOnTap: () {
                      print('view all spot light');
                    },
                  ),
                  HeaderHomeTile(
                    title: 'Matched Properties',
                    subTitle: 'You\'ve got a match!',
                    child: PhotoListTile(items: controller.spotLight),
                    viewAllOnTap: () {
                      print('view all matched properties');
                    },
                  ),
                  HeaderHomeTile(
                    title: 'Why Dazle?',
                    subTitle: 'Take control of the deal, Here’s how',
                    child: PhotoListTile(items: controller.spotLight),
                    viewAllOnTap: () {
                      print('view all why brooky');
                    },
                  ),
                  HeaderHomeTile(
                    title: 'New Homes',
                    subTitle: 'Just listed in the app',
                    child: PhotoListTile(items: controller.spotLight),
                    viewAllOnTap: () {
                      print('view all new homes');
                    },
                  ),
                ],
              );
            }),
          )),
    );
  }
}
