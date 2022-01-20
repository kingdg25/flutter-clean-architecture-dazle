import 'package:dazle/app/widgets/listing/listing_property_list_tile.dart';
import 'package:dazle/app/pages/my_listing/my_listing_controller.dart';
import 'package:dazle/app/widgets/form_fields/custom_search_field.dart';
import 'package:dazle/data/repositories/data_listing_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';



class MyListingPage extends View {
  MyListingPage({Key key}) : super(key: key);

  @override
  _MyListingPageState createState() => _MyListingPageState();
}


class _MyListingPageState extends ViewState<MyListingPage, MyListingController> {
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
                },
                suggestionsCallback: (pattern) async {
                  print('suggestionsCallback $pattern');

                  return null;
                },
                onSuggestionSelected: (suggestion) {
                  // controller.searchTextController.text = suggestion;
                  // controller.getInvites(filterByName: suggestion);
                },
                onSubmitted: (value) {
                  // controller.getInvites(filterByName: value);
                },
              ),
              ListingPropertyListTile(
                items: controller.myListing,
                height: 300,
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              )
            ],
          );
        }
      )
    );
  }
}