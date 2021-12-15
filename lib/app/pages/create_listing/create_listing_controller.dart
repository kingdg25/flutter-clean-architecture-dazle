import 'package:dazle/app/pages/create_listing/create_listing_presenter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';


class CreateListingController extends Controller {
  final CreateListingPresenter createListingPresenter;

  PageController createListingPageController;

  CreateListingController(userRepo)
    : createListingPresenter = CreateListingPresenter(),
      createListingPageController = PageController(),
      super();


  @override
  void initListeners() {

  }



  @override
  void onResumed() => print('On resumed');

  @override
  void onReassembled() => print('View is about to be reassembled');

  @override
  void onDeactivated() => print('View is about to be deactivated');

  @override
  void onDisposed() {
    createListingPresenter.dispose(); // don't forget to dispose of the presenter
    super.onDisposed();
  }
  
}