import 'package:dazle/app/pages/home/components/property_details_list_tile.dart';
import 'package:dazle/app/pages/home/components/property_list_tile.dart';
import 'package:dazle/app/utils/app.dart';
import 'package:dazle/app/widgets/form_fields/custom_search_field.dart';
import 'package:dazle/data/repositories/data_home_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:dazle/app/pages/home/home_controller.dart';



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
          height: 60.0,
          image: AssetImage('assets/brooky_logo.png'),
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
                print("Hello");
              }
            ),
          ),
          ControlledWidgetBuilder<HomeController>(
            builder: (context, controller) {
              return Container(
                padding: EdgeInsets.only(right: 10.0),
                child: IconButton(
                  icon: Icon(Icons.logout, color: Colors.black),
                  onPressed: () {
                    print("Logout");
                    controller.userLogout();
                  }
                ),
              );
            }
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
                    height: (screenWidth < 375) ? screenHeight/3 : screenHeight/2,
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
                    height: (screenWidth < 375) ? screenHeight/3 : screenHeight/2,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.25),
                          blurRadius: 4,
                          offset: Offset(0, 4), // changes position of shadow
                        ),
                      ],
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
                        borderSide:  BorderSide(
                          color: Colors.white
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:  BorderSide(
                          color: Colors.white
                        ),
                      ),
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
                      },
                    ),
                  ),
                  Positioned(
                    bottom: screenHeight/14,
                    left: 20,
                    right: screenWidth/2.6,
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "PropMatch\n",
                            style: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold
                            )
                          ),
                          TextSpan(
                            text: "Matching brokers with properties to brokers with clients.",
                            style: TextStyle(
                              fontSize: 15.0,
                              height: 1.5,
                              fontWeight: FontWeight.w600
                            )
                          ),
                        ]
                      ),
                      style: App.textStyle(
                        color: Colors.white,
                      )
                    ),
                  )
                ],
              ),
              PropertyListTile(
                title: 'Spotlight',
                subTitle: 'Most unique and exclusive properties',
              ),
              PropertyDetailsListTile(
                title: 'Matched Properties',
                subTitle: 'Just listed in the app',
              ),
              PropertyListTile(
                title: 'Why Brooky?',
                subTitle: 'Take control of the deal, Here’s how',
              ),
              PropertyDetailsListTile(
                title: 'New Homes',
                subTitle: 'Just listed in the app',
              ),
            ],
          );
        }
      )
    );
  }
}