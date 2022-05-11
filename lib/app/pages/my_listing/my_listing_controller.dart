import 'dart:async';

import 'package:dazle/app/pages/my_listing/my_listing_presenter.dart';
import 'package:dazle/app/utils/app_constant.dart';
import 'package:dazle/domain/entities/property.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class MyListingController extends Controller {
  final MyListingPresenter myListingPresenter;

  List<Property> _myListing;
  List<Property> get myListing => _myListing;
  List<Property> _suggestionListing;
  List<Property> get suggestionListing => _suggestionListing;
  List<Property>? searchResultListing;

  Timer? _timer;

  MyListingController(userRepo)
      : myListingPresenter = MyListingPresenter(userRepo),
        _myListing = <Property>[],
        _suggestionListing = <Property>[],
        // _searchResultListing = <Property>[],
        super();

  @override
  void initListeners() {
    getData();
    const oneSec = Duration(seconds: 10);
    _timer = Timer.periodic(oneSec, (Timer t) {
      getData();
    });

    // get my listing
    myListingPresenter.getMyListingOnNext = (List<Property> res) {
      print('get my listing on next $res');
      if (res != null) {
        _myListing = res;
      }
    };

    myListingPresenter.getMyListingOnComplete = () {
      print('get my listing on complete');
      refreshUI();
    };

    myListingPresenter.getMyListingOnError = (e) {
      print('get my listing on error $e');

      if (e is Map) {
        if (e.containsKey("error_type")) {
          AppConstant.statusDialog(
              context: getContext(),
              text: "${e.toString()}",
              title: "Something went wrong'");
        }
      }
    };
  }

  void getData() {
    myListingPresenter.getMyListing();
  }

  void getSuggestionListings(String keyword) {
    _suggestionListing = _myListing
        .where((element) =>
            element.amenities!.toString().toLowerCase().contains(keyword) ||
            element.city!.toString().toLowerCase().contains(keyword) ||
            element.propertyType!.toString().toLowerCase().contains(keyword) ||
            element.propertyFor!.toString().toLowerCase().contains(keyword) ||
            element.timePeriod!.toString().toLowerCase().contains(keyword) ||
            element.totalBathRoom!.toString().toLowerCase().contains(keyword) ||
            element.totalBedRoom!.toString().toLowerCase().contains(keyword) ||
            element.totalParkingSpace!
                .toString()
                .toLowerCase()
                .contains(keyword) ||
            element.isYourProperty!
                .toString()
                .toLowerCase()
                .contains(keyword) ||
            element.street!.toString().toLowerCase().contains(keyword) ||
            element.description!.toString().toLowerCase().contains(keyword) ||
            element.viewType!.toString().toLowerCase().contains(keyword))
        .toList();
  }

  void getSearchResultListing(String keyword) {
    if (keyword != '') {
      searchResultListing = _myListing
          .where((element) =>
              element.amenities!.contains(keyword) ||
              element.city!.contains(keyword) ||
              element.propertyType!.contains(keyword) ||
              element.propertyFor!.contains(keyword) ||
              element.timePeriod!.contains(keyword) ||
              element.totalBathRoom!.contains(keyword) ||
              element.totalBedRoom!.contains(keyword) ||
              element.totalParkingSpace!.contains(keyword) ||
              element.isYourProperty!.contains(keyword) ||
              element.street!.contains(keyword) ||
              element.description!.contains(keyword) ||
              element.viewType!.contains(keyword))
          .toList();
    } else {
      searchResultListing = null;
    }

    refreshUI();
  }

  @override
  void onResumed() => print('On resumed');

  @override
  void onReassembled() => print('View is about to be reassembled');

  @override
  void onDeactivated() => print('View is about to be deactivated');

  @override
  void onDisposed() {
    _timer?.cancel();
    myListingPresenter.dispose(); // don't forget to dispose of the presenter
    super.onDisposed();
  }
}
