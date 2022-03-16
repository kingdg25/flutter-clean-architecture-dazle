import 'package:dazle/app/pages/listing_details/listing_details_presenter.dart';
import 'package:dazle/app/utils/app.dart';
import 'package:dazle/data/repositories/data_listing_repository.dart';
import 'package:dazle/domain/entities/user.dart';
import 'package:dazle/domain/entities/property.dart';
import 'package:dazle/app/utils/app_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class ListingDetailsController extends Controller {
  final ListingDetailsPresenter listingDetailsPresenter;

  User? _currentUser;

  User? get currentUser => _currentUser;

  Property? _selectedListing;
  Property? get selectedListing => _selectedListing;

  final listingId;

  ListingDetailsController(
      {DataListingRepository? dataListingRepo, this.listingId})
      : listingDetailsPresenter = ListingDetailsPresenter(dataListingRepo),
        super();

  @override
  void initListeners() async {
    await getCurrentUser();
    await getSelectedListing();

    // get selected listing
    listingDetailsPresenter.getSelectedListingOnNext = (Property res) {
      print('get selected listing on next $res');
      if (res != null) {
        _selectedListing = res;
      }
    };

    listingDetailsPresenter.getSelectedListingOnComplete = () {
      print('get selected listing on complete');
      refreshUI();
    };

    listingDetailsPresenter.getSelectedListingOnError = (e) {
      print('get selected listing on error $e');

      if (e is Map) {
        if (e.containsKey("error_type")) {
          AppConstant.statusDialog(
              context: getContext(),
              text: "${e.toString()}",
              title: "Something went wrong'");
        }
      }
    };

    // delete listing
    listingDetailsPresenter.deleteListinOnNext = () {
      print('delete listing on next');
    };

    listingDetailsPresenter.deleteListinOnComplete = () {
      print('delete listing on complete');
      AppConstant.showLoader(getContext(), false);
      _statusDialog('Success!', 'Deleted Sucessfully');
    };
    listingDetailsPresenter.deleteListinOnError = (e) {
      print('delete listing on eror $e');
      AppConstant.showLoader(getContext(), false);

      if (!e['error']) {
        _statusDialog('Oops!', '${e['status'] ?? ''}');
      } else {
        _statusDialog('Something went wrong', '${e.toString()}');
      }
    };
  }

  getCurrentUser() async {
    User user = await App.getUser();

    if (user != null) {
      _currentUser = user;
      refreshUI();
    }
  }

  getSelectedListing() async {
    listingDetailsPresenter.getSelectedListing(listingId);
  }

  deleteListing({String? listingId}) async {
    listingDetailsPresenter.deleteListing(listingId!);
  }

  getListingToDisplay() async {}

  _statusDialog(String title, String text,
      {bool? success, Function? onPressed}) {
    AppConstant.statusDialog(
        context: getContext(),
        success: success ?? false,
        title: title,
        text: text,
        onPressed: onPressed);
  }

  @override
  void onResumed() => print('On resumed');

  @override
  void onReassembled() => print('View is about to be reassembled');

  @override
  void onDeactivated() => print('View is about to be deactivated');

  @override
  void onDisposed() {
    listingDetailsPresenter
        .dispose(); // don't forget to dispose of the presenter
    super.onDisposed();
  }
}
