import 'package:dazle/app/pages/filter/filter_view.dart';
import 'package:dazle/app/pages/find_match/find_match_view.dart';
import 'package:dazle/app/pages/home/components/header_home_tile.dart';
import 'package:dazle/app/pages/home/components/property_list_tile.dart';
import 'package:dazle/app/pages/home/components/photo_list_tile.dart';
import 'package:dazle/app/utils/app.dart';
import 'package:dazle/app/utils/app_constant.dart';
import 'package:dazle/app/widgets/form_fields/custom_search_field.dart';
import 'package:dazle/data/repositories/data_home_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:dazle/app/pages/home/home_controller.dart';
import 'package:dazle/app/pages/listing_details/listing_details_view.dart';

class HomePage extends View {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ViewState<HomePage, HomeController> {
  _HomePageState() : super(HomeController(DataHomeRepository()));

  @override
  Widget get view {
    return Scaffold(
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
                  icon: Image.asset('assets/icons/find.png'),
                  iconSize: 30,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (buildContext) => FindMatchPage()));
                  }),
            )
          ],
        ),
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
                    child: CustomSearchField(
                      // controller: controller.searchTextController,
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
                        return null;
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
                                builder: (buildContext) => FilterPage()));
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
                                  fontSize: 30.0, fontWeight: FontWeight.bold)),
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
                ),
                viewAllOnTap: () {
                  print('view all your listings');
                },
              ),
              HeaderHomeTile(
                title: 'Spotlight',
                subTitle: 'Most unique and exclusive properties',
                child: PhotoListTile(items: controller.spotLight),
                viewAllOnTap: () {
                  print('view all spot light');
                },
              ),
              HeaderHomeTile(
                title: 'Matched Properties',
                subTitle: 'Just listed in the app',
                child: PropertyListTile(
                  items: controller.matchedProperties,
                ),
                viewAllOnTap: () {
                  print('view all matched properties');
                },
              ),
              HeaderHomeTile(
                title: 'Why Brooky?',
                subTitle: 'Take control of the deal, Here’s how',
                child: PhotoListTile(items: controller.whyBrooky),
                viewAllOnTap: () {
                  print('view all why brooky');
                },
              ),
              HeaderHomeTile(
                title: 'New Homes',
                subTitle: 'Just listed in the app',
                child: PropertyListTile(
                  items: controller.newHomes,
                ),
                viewAllOnTap: () {
                  print('view all new homes');
                },
              ),
            ],
          );
        }));
  }
}
