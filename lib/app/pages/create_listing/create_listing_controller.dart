import 'package:dazle/app/pages/create_listing/create_listing_presenter.dart';
import 'package:dazle/app/utils/app_constant.dart';
// import 'package:dazle/domain/entities/amenity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';


class CreateListingController extends Controller {
  final CreateListingPresenter createListingPresenter;

  PageController createListingPageController;

  // page 1
  String propertyType;
  String propertyFor;
  String timePeriod;
  final TextEditingController priceTextController;

  // page 2
  String numberOfBedRooms;
  String numberOfBathRooms;
  String numberOfParking;
  final TextEditingController areaTextController;
  String isYourProperty;

  // page 3
  final TextEditingController streetTextController;
  final TextEditingController landmarkTextController;
  final TextEditingController cityTextController;

  // page 4
  List amenities;

  // page 5
  List<AssetEntity> assets;

  CreateListingController(userRepo)
    : createListingPresenter = CreateListingPresenter(userRepo),
      createListingPageController = PageController(),
      priceTextController = TextEditingController(),
      areaTextController = TextEditingController(),
      streetTextController = TextEditingController(),
      landmarkTextController = TextEditingController(),
      cityTextController = TextEditingController(),
      amenities = [],
      assets = <AssetEntity>[],
      super();


  @override
  void initListeners() {
    // create listing
    createListingPresenter.createListingOnNext = () {
      print('create listing on next');
    };

    createListingPresenter.createListingOnComplete = () {
      print('create listing on complete');
      AppConstant.showLoader(getContext(), false);
      Navigator.pop(getContext());
    };

    createListingPresenter.createListingOnError = (e) {
      print('create listing on error $e');
      AppConstant.showLoader(getContext(), false);
      
      if ( !e['error'] ) {
        _statusDialog('Oops!', '${e['status'] ?? ''}');
      }
      else{
        _statusDialog('Something went wrong', '${e.toString()}');
      } 
    };
  }


  validatePage1(){
    bool isValidated = false;

    if (
      propertyType != null &&
      propertyFor != null &&
      timePeriod != null &&
      priceTextController.text.isNotEmpty
    ) {
      isValidated = true;
    }

    return isValidated;
  }

  validatePage2(){
    bool isValidated = false;

    if (
      numberOfBedRooms != null &&
      numberOfBathRooms != null &&
      numberOfParking != null &&
      areaTextController.text.isNotEmpty &&
      isYourProperty != null
    ) {
      isValidated = true;
    }

    return isValidated;
  }

  validatePage3(){
    bool isValidated = false;

    if (
      priceTextController.text.isNotEmpty &&
      priceTextController.text.isNotEmpty &&
      priceTextController.text.isNotEmpty
    ) {
      isValidated = true;
    }

    return isValidated;
  }

  validatePage4(){
    bool isValidated = false;

    if ( amenities.length > 4 ) {
      isValidated = true;
    }

    return isValidated;
  }

  validatePage5(){
    bool isValidated = false;

    if ( assets.length > 4 ) {
      isValidated = true;
    }

    return isValidated;
  }


  void createListing() {
    // AppConstant.showLoader(getContext(), true);

    // createListingPresenter.createListing(listing: );
  }


  _statusDialog(String title, String text, {bool success, Function onPressed}){
    AppConstant.statusDialog(
      context: getContext(),
      success: success ?? false,
      title: title,
      text: text,
      onPressed: onPressed
    );
  }


  @override
  void onResumed() => print('On resumed');

  @override
  void onReassembled() => print('View is about to be reassembled');

  @override
  void onDeactivated() => print('View is about to be deactivated');

  @override
  void onDisposed() {
    createListingPageController.dispose();
    
    priceTextController.dispose();
    areaTextController.dispose();
    streetTextController.dispose();
    landmarkTextController.dispose();
    cityTextController.dispose();

    createListingPresenter.dispose(); // don't forget to dispose of the presenter
    Loader.hide();
    super.onDisposed();
  }
  
}