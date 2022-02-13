import 'package:dazle/app/pages/listing_details/listing_details_presenter.dart';
import 'package:dazle/app/utils/app.dart';
import 'package:dazle/domain/entities/user.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';


class ListingDetailsController extends Controller {
  final ListingDetailsPresenter listingDetailsPresenter;


  ListingDetailsController(userRepo)
    : listingDetailsPresenter = ListingDetailsPresenter(),
      super();

  User? _currentUser;

  User? get currentUser => _currentUser;

  @override
  void initListeners() async {
    await getCurrentUser();
  }

  getCurrentUser() async {
    User user = await App.getUser();

    if (user != null){
      _currentUser = user;
      refreshUI();
    }
  }


  @override
  void onResumed() => print('On resumed');

  @override
  void onReassembled() => print('View is about to be reassembled');

  @override
  void onDeactivated() => print('View is about to be deactivated');

  @override
  void onDisposed() {
    listingDetailsPresenter.dispose(); // don't forget to dispose of the presenter
    super.onDisposed();
  }
  
}