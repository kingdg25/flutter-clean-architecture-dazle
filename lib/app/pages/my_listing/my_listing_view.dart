import 'package:dazle/app/utils/app.dart';
import 'package:dazle/app/utils/app_constant.dart';
import 'package:dazle/app/widgets/listing/listing_property_list_tile.dart';
import 'package:dazle/app/pages/my_listing/my_listing_controller.dart';
import 'package:dazle/app/widgets/form_fields/custom_search_field.dart';
import 'package:dazle/data/repositories/data_listing_repository.dart';
import 'package:dazle/domain/entities/property.dart';
import 'package:dazle/domain/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../create_listing/create_listing_view.dart';
import '../listing_details/listing_details_view.dart';

class MyListingPage extends View {
  MyListingPage({Key? key}) : super(key: key);

  @override
  _MyListingPageState createState() => _MyListingPageState();
}

class _MyListingPageState
    extends ViewState<MyListingPage, MyListingController> {
  _MyListingPageState() : super(MyListingController(DataListingRepository()));

  @override
  Widget get view {
    return Scaffold(
      key: globalKey,
      backgroundColor: Colors.white,
      body: ControlledWidgetBuilder<MyListingController>(
          builder: (context, controller) {
        return ListView(
          children: [
            CustomSearchField(
              // controller: controller.searchTextController,
              hintText: 'Building, Neighborhood, City',
              withIcon: false,
              iconData: Icons.contacts_outlined,
              borderRadius: 10,
              onChanged: (value) {
                print('onChanged onChanged $value');
                // controller.searchUser();
                //
                if (value == '') {
                  controller.getSearchResultListing(value);
                }
              },
              suggestionsCallback: (pattern) async {
                print('suggestionsCallback $pattern');
                if (pattern != '') {
                  controller.getSuggestionListings(pattern);
                  print(controller.suggestionListing.length);

                  return controller.suggestionListing;
                } else
                  return [];
              },
              onSuggestionSelected: (suggestion) {
                // controller.searchTextController.text = suggestion;
                // controller.getInvites(filterByName: suggestion);
                Property selected = suggestion;
                print("suggestion clicked: ${selected.id}");
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (buildContext) => ListingDetailsPage(
                              listingId: selected.id,
                            )));
              },
              onSubmitted: (value) {
                // controller.getInvites(filterByName: value);
                controller.getSearchResultListing(value);
              },
            ),
            ListingPropertyListTile(
              items: controller.searchResultListing?.length == null
                  ? controller.myListing
                  : controller.searchResultListing,
              mixpanel: controller.mixpanel,
              height: 300,
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            )
          ],
        );
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FractionallySizedBox(
        widthFactor: 0.90,
        child: ControlledWidgetBuilder<MyListingController>(
          builder: (context, controller) {
            return FloatingActionButton.extended(
                onPressed: () async {
                  User currentUser = await App.getUser();
                  if (currentUser.accountStatus != 'Deactivated') {
                    controller.mixpanel!.track('Create New Listing',
                        properties: {'Page Pressed': 'Home Page'});
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (buildContext) => CreateListingPage()));
                  } else {
                    AppConstant.statusDialog(
                        context: context,
                        title: 'Action not Allowed',
                        text: 'Please Reactivate your account first.',
                        success: false);
                  }
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                tooltip: 'Create listing',
                backgroundColor: App.mainColor,
                label: const Text('Add New Listing')
                // child: Icon(Icons.add)
                );
          },
        ),
      ),
    );
  }
}
