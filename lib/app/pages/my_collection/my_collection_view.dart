import 'package:dazle/app/widgets/listing/listing_property_list_tile.dart';
import 'package:dazle/app/pages/my_collection/my_collection_controller.dart';
import 'package:dazle/app/widgets/form_fields/custom_search_field.dart';
import 'package:dazle/data/repositories/data_listing_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';



class MyCollectionPage extends View {
  MyCollectionPage({Key key}) : super(key: key);

  @override
  _MyCollectionPageState createState() => _MyCollectionPageState();
}


class _MyCollectionPageState extends ViewState<MyCollectionPage, MyCollectionController> {
  _MyCollectionPageState() : super(MyCollectionController(DataListingRepository()));

  @override
  Widget get view {
    return Scaffold(
      key: globalKey,
      backgroundColor: Colors.white,
      body: ControlledWidgetBuilder<MyCollectionController>(
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
                items: controller.myCollection
              )
            ],
          );
        }
      )
    );
  }
}