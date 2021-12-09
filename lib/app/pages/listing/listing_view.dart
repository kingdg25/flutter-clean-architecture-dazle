import 'package:dazle/app/pages/listing/listing_controller.dart';
import 'package:dazle/app/widgets/custom_text.dart';
import 'package:dazle/data/repositories/data_listing_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';



class ListingPage extends View {
  ListingPage({Key key}) : super(key: key);

  @override
  _ListingPageState createState() => _ListingPageState();
}


class _ListingPageState extends ViewState<ListingPage, ListingController> {
  _ListingPageState() : super(ListingController(DataListingRepository()));

  @override
  Widget get view {
    return Scaffold(
      key: globalKey,
      appBar: AppBar(
        title: CustomText(
          text: 'My Listings',
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Text('listing page'),
      ),
    );
  }
}