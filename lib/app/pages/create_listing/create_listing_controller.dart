import 'dart:async';

import 'package:dazle/app/pages/create_listing/create_listing_presenter.dart';
import 'package:dazle/app/utils/app_constant.dart';
import 'package:dazle/app/widgets/custom_text.dart';
import 'package:dazle/app/widgets/form_fields/custom_button.dart';
import 'package:dazle/app/widgets/form_fields/custom_radio_group_button.dart';
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
  final TextEditingController descriptionTextController;
  String isYourProperty;

  // page 3
  final TextEditingController streetTextController;
  final TextEditingController landmarkTextController;
  final TextEditingController cityTextController;

  // page 4
  List amenities;

  // page 5
  List<AssetEntity> assets;
  String viewType;

  CreateListingController(userRepo)
    : createListingPresenter = CreateListingPresenter(userRepo),
      createListingPageController = PageController(),
      priceTextController = TextEditingController(),
      areaTextController = TextEditingController(),
      descriptionTextController = TextEditingController(),
      streetTextController = TextEditingController(),
      landmarkTextController = TextEditingController(),
      cityTextController = TextEditingController(),
      amenities = [],
      assets = <AssetEntity>[],
      viewType = "public",
      super();


  @override
  void initListeners() {
    // create listing
    createListingPresenter.createListingOnNext = () {
      print('create listing on next');
    };

    createListingPresenter.createListingOnComplete = () async {
      print('create listing on complete');
      AppConstant.showLoader(getContext(), false);
      await _statusDialog('Done!', 'Your listing has been created.');
      Navigator.pop(getContext());
    };

    createListingPresenter.createListingOnError = (e) {
      print('create listing on error $e');
      AppConstant.showLoader(getContext(), false);
      
      if ( !e['error'] ) {
        if (e['error_type']=="filesize_error") {
          _statusDialog('File size error.', '${e['status'] ?? ''}');
        } else {
          _statusDialog('Oops!', '${e['status'] ?? ''}');
        }
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
    } else AppConstant.statusDialog(context: getContext(), text: "All inputs in this section are required.", title: "Values missing.");

    return isValidated;
  }

  validatePage2(){
    bool isValidated = false;

    if (
      numberOfBedRooms != null &&
      numberOfBathRooms != null &&
      numberOfParking != null &&
      areaTextController.text.isNotEmpty &&
      descriptionTextController.text.isNotEmpty &&
      isYourProperty != null
    ) {
      isValidated = true;
    } else AppConstant.statusDialog(context: getContext(), text: "All inputs in this section are required.", title: "Values missing.");

    return isValidated;
  }

  validatePage3(){
    bool isValidated = false;

    if (
      streetTextController.text.isNotEmpty &&
      cityTextController.text.isNotEmpty
    ) {
      isValidated = true;
    } else AppConstant.statusDialog(context: getContext(), text: "Street Address and City inputs are required.", title: "Values missing.");

    return isValidated;
  }

  validatePage4(){
    bool isValidated = false;

    if ( amenities.length > 1 ) {
      isValidated = true;
    } else AppConstant.statusDialog(context: getContext(), text: "Choose at least 1 amenities.", title: "Choose more amenities.");

    return isValidated;
  }

  validatePage5() async {
    bool isValidated = false;

    if ( assets.length > 0 ) {
      isValidated = true;
    } else {
      await AppConstant.statusDialog(context: getContext(), text: "Upload files at least 4 photos.", title: "Upload Photos.");
      return false;
    }

    final confirmViewType = await _viewType(getContext());

    if (confirmViewType==null) {
      AppConstant.statusDialog(context: getContext(), text: "Please confirm the view type of your list.", title: "Confirm");
      return false;
    }
    
    await AppConstant.statusDialog(context: getContext(), text: "Your listing will view as $confirmViewType", title: "View Type");

    return isValidated;
  }


  void createListing() async {
    AppConstant.showLoader(getContext(), true);

    final assetsBased64 = await AppConstant.initializeAssetImages(images: assets);

    var listing = {
      "cover_photo": 'https://picsum.photos/id/73/200/300',
      "photos": [],
      "property_type": propertyType,
      "property_for": propertyFor,
      "time_period": timePeriod,
      "price": priceTextController.text,

      "number_of_bedrooms": numberOfBedRooms,
      "number_of_bathrooms": numberOfBathRooms,
      "number_of_parking_space": numberOfParking,
      "total_area": areaTextController.text,
      "is_your_property": isYourProperty,
      "description": descriptionTextController.text,

      "street": streetTextController.text,
      "landmark": landmarkTextController.text,
      "city": cityTextController.text,

      "amenities": amenities,

      "assets": assetsBased64, // for photos

      "view_type": viewType
    };

    createListingPresenter.createListing(listing: listing);
  }


  Future _statusDialog(String title, String text, {bool success, Function onPressed}) async {
    return await AppConstant.statusDialog(
      context: getContext(),
      success: success ?? false,
      title: title,
      text: text,
      onPressed: onPressed
    );
  }
  
  Future _viewType(parentContext) async {
    // String viewType = "public";
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return Center(
          child: SingleChildScrollView(
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)
              ),
              actionsPadding: EdgeInsets.all(20.0),
              title: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: CustomText(
                  text: "Do you want to make your list...",
                  fontSize: 15.0,
                  textAlign: TextAlign.left,
                  fontWeight: FontWeight.bold,
                ),
              ),
              insetPadding: EdgeInsets.all(0.0),
              content: Container(
                margin: EdgeInsets.all((0.0)),
                // color: Colors.blue,
                constraints: BoxConstraints(maxHeight: double.infinity, maxWidth: 300),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Center(
                      child: Container(
                        width: 400,
                        height: 50,
                        child: Center(
                          child: CustomRadioGroupButton(
                            radioPadding: 15,radioWidth: 130,
                            buttonLables: ["Public", "Private",
                            ],
                            buttonValues: ["public", "private",
                            ],
                            radioButtonValue: (value) {
                              print(value);
                              viewType = value;
                            },
                            defaultSelected: viewType,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: CustomText(
                        text: """If you make your list public, your connections will be able to see your list. While making your list private means you are the only one can see your list but you can still change it to public later.
                          """,
                        fontSize: 13.0,
                        textAlign: TextAlign.left,
                      ),
                    )
                  ],
                ),
              ),
              actions: <Widget>[
                CustomButton(
                  text: 'Confirm',
                  expanded: true,
                  borderRadius: 20.0,
                  onPressed: () {
                    Navigator.pop(context, viewType);
                  },
                ),
              ],
            ),
          ),
        );
      },
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
    descriptionTextController.dispose();
    streetTextController.dispose();
    landmarkTextController.dispose();
    cityTextController.dispose();

    createListingPresenter.dispose(); // don't forget to dispose of the presenter
    Loader.hide();
    super.onDisposed();
  }
  
}