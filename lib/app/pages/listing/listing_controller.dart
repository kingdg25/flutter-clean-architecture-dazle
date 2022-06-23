import 'package:dazle/app/pages/listing/listing_presenter.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class ListingController extends Controller {
  final ListingPresenter listingPresenter;

  ListingController(userRepo)
      : listingPresenter = ListingPresenter(),
        super();

  @override
  void initListeners() {}

  @override
  void onResumed() => print('On resumed');

  @override
  void onReassembled() => print('View is about to be reassembled');

  @override
  void onDeactivated() => print('View is about to be deactivated');

  @override
  void onDisposed() {
    listingPresenter.dispose(); // don't forget to dispose of the presenter
    super.onDisposed();
  }
}
