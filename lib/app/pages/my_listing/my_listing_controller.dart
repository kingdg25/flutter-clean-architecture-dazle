import 'dart:async';

import 'package:dazle/app/pages/my_listing/my_listing_presenter.dart';
import 'package:dazle/app/utils/app_constant.dart';
import 'package:dazle/domain/entities/property.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class MyListingController extends Controller {
  final MyListingPresenter myListingPresenter;

  List<Property> _myListing;
  List<Property> get myListing => _myListing;
  Timer? _timer;

  MyListingController(userRepo)
      : myListingPresenter = MyListingPresenter(userRepo),
        _myListing = <Property>[],
        super();

  @override
  void initListeners() {
    // const oneSec = Duration(seconds: 1);
    // _timer = Timer.periodic(oneSec, (Timer t) {
    getData();
    // });

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
