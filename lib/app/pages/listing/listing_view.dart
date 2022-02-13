import 'package:dazle/app/pages/listing/components/listing_tab_bar.dart';
import 'package:dazle/app/pages/listing/listing_controller.dart';
import 'package:dazle/data/repositories/data_listing_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';



class ListingPage extends View {
  ListingPage({Key? key}) : super(key: key);

  @override
  _ListingPageState createState() => _ListingPageState();
}


class _ListingPageState extends ViewState<ListingPage, ListingController> {
  _ListingPageState() : super(ListingController(DataListingRepository()));

  @override
  Widget get view {
    return ListingTabBar();
  }
}