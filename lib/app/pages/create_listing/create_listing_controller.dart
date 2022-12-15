import 'dart:async';

import 'package:dazle/app/pages/create_listing/create_listing_presenter.dart';
import 'package:dazle/app/pages/listing_details/listing_details_view.dart';
import 'package:dazle/app/utils/app.dart';
import 'package:dazle/app/utils/app_constant.dart';
import 'package:dazle/app/widgets/custom_text.dart';
import 'package:dazle/app/widgets/form_fields/custom_button.dart';
import 'package:dazle/app/widgets/form_fields/custom_radio_group_button.dart';
import 'package:dazle/domain/entities/property.dart';
import 'package:dazle/domain/entities/user.dart';
// import 'package:dazle/domain/entities/amenity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../../../data/constants.dart';
// import '../map_location_picker/map_location_picker_view.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class CreateListingController extends Controller {
  final CreateListingPresenter createListingPresenter;
  final Property? property;

  PageController createListingPageController;

  // page 1
  String? propertyType;
  String? propertyFor;
  String? timePeriod;
  String? pricing;
  final TextEditingController priceTextController;

  // page 2
  String? numberOfBedRooms;
  String? numberOfBathRooms;
  String? numberOfParking;
  final TextEditingController numOfBedroomController;
  final TextEditingController numOfBathroomsController;
  final TextEditingController areaTextController;
  final TextEditingController frontageTextController;
  final TextEditingController floorAreaTextController;
  final TextEditingController titleTextController;
  final TextEditingController descriptionTextController;

  String? isYourProperty;
  String? ownwership;

  // page 3
  final TextEditingController streetTextController;
  final TextEditingController landmarkTextController;
  final TextEditingController cityTextController;
  bool mapSwitch;
  double? latitude;
  double? longitude;
  Map<dynamic, dynamic>? propertyCoordinates;
  // Map<dynamic, dynamic>? location;

  List<DropdownMenuItem<String>> provinces = [];
  List<DropdownMenuItem<String>> cities = [];
  List<DropdownMenuItem<String>> barangays = [];
  List<String?> provinceCodes = [];
  List<String?> provinceNames = [];
  List<String>? sortedProvinceNames = [];
  List<String?> cityCodes = [];
  List<String>? cityNames = [];
  List<String?> brgyCodes = [];
  List<String>? brgyNames = [];
  String? selectedProvinceCode;
  String? selectedCityCode;
  String? selectedBarangayCode;
  String? selectedProvinceName;
  String? selectedCityName;
  String? selectedBarangayName;
  Map<String, dynamic> location;

  final TextEditingController subdivisionTextController;
  final TextEditingController streetNameTextController;
  final TextEditingController houseNumberTextController;
  final TextEditingController buildingNameTextController;
  final TextEditingController floorTextController;

  // Visibility
  bool showProvince = true;
  bool showCity = true;
  bool showBarangay = true;
  bool showSubdivision = true;
  bool showStreet = true;
  bool showHouseNumber = true;
  bool showBuildingName = true;
  bool showFloorNumber = true;

  // page 4
  List<String> amenitiesSelection;
  List? amenities;

  // page 5
  List<AssetEntity> assets;
  String? viewType;
  int currentPhotosCount;
  bool isUpdating = false;
  List<String>? currentPhotos;

  CreateListingController(userRepo, this.property)
      : createListingPresenter = CreateListingPresenter(userRepo),
        amenitiesSelection = [
          "Kitchen",
          "Wifi",
          "Eco Friendly",
          "Sharing Gym",
          "Sharing Pool",
          "Security",
          "Covered Parking",
          "Central A.C.",
          "Balcony",
          "Tile Flooring",
        ],
        createListingPageController = PageController(),
        priceTextController = TextEditingController(),
        numOfBedroomController = TextEditingController(),
        numOfBathroomsController = TextEditingController(),
        areaTextController = TextEditingController(),
        frontageTextController = TextEditingController(),
        floorAreaTextController = TextEditingController(),
        titleTextController = TextEditingController(),
        descriptionTextController = TextEditingController(),
        streetTextController = TextEditingController(),
        landmarkTextController = TextEditingController(),
        cityTextController = TextEditingController(),
        amenities = [],
        assets = <AssetEntity>[],
        viewType = "public",
        currentPhotosCount = 0,
        isUpdating = false,
        mapSwitch = false,
        subdivisionTextController = TextEditingController(),
        streetNameTextController = TextEditingController(),
        houseNumberTextController = TextEditingController(),
        buildingNameTextController = TextEditingController(),
        floorTextController = TextEditingController(),
        location = {
          "ProvinceCode": '',
          "CityCode": '',
          "BrgyCode": '',
          "Subdivision": '',
          "Street": '',
          "HouseNo": '',
          "BuildingName": '',
          "RoomNo": ''
        },
        super();

  @override
  void initListeners() {
    initializeProperty();
    // create listing
    createListingPresenter.createListingOnNext = (listing) async {
      print('create listing on next $listing');
      AppConstant.showLoader(getContext(), false);
      await _statusDialog('Done!', 'Your listing has been created.');
      Navigator.pop(getContext());
      final Property newList = listing;

      if (listing != null) {
        Navigator.push(
            getContext(),
            MaterialPageRoute(
                builder: (buildContext) => ListingDetailsPage(
                      listingId: newList.id,
                    )));
      }
    };

    createListingPresenter.createListingOnComplete = () async {
      print('create listing on complete');
      AppConstant.showLoader(getContext(), false);
    };

    createListingPresenter.createListingOnError = (e) {
      print('create listing on error $e');
      AppConstant.showLoader(getContext(), false);
      if (!e['error']) {
        if (e['error_type'] == "filesize_error") {
          _statusDialog('File size error.', '${e['status'] ?? ''}');
        } else {
          _statusDialog('Oops!', '${e['status'] ?? ''}');
        }
      } else {
        _statusDialog('Something went wrong', '${e.toString()}');
      }
    };

    createListingPresenter.updateListingOnNext = (Property property) async {
      AppConstant.showLoader(getContext(), false);
      await _statusDialog('Done!', 'Your listing has been updated.');

      print(property);
      // if (property != null && property.id != null) {
      Navigator.pop(getContext(), true);
      Navigator.push(
          getContext(),
          MaterialPageRoute(
              builder: (buildContext) => ListingDetailsPage(
                    listingId: property.id,
                  )));
      // }
    };
    createListingPresenter.updateListingOnComplete = () async {
      // await _statusDialog('Done!', 'Updating listing complete.');
    };
    createListingPresenter.updateListingOnError = (e) async {
      AppConstant.showLoader(getContext(), false);
      await _statusDialog(
          'Cannot update listing!', 'Your listing cannot be updated: $e.');
    };
  }

  void mixpanelSendData() async {
    AppConstant.mixPanelInstance!.track('Listing Saved');
    AppConstant.mixPanelInstance!
      ..track('Property Type', properties: {'Property Type': propertyType});
    AppConstant.mixPanelInstance!
      ..track('Property For', properties: {'Property For': propertyFor});
    AppConstant.mixPanelInstance!
      ..track('Time Period', properties: {'Time Period': timePeriod});
    AppConstant.mixPanelInstance!
      ..track('Furnished', properties: {'Furnished': isYourProperty});
    AppConstant.mixPanelInstance!
      ..track('Ownership', properties: {'Ownership': ownwership});
    AppConstant.mixPanelInstance!
      ..track('Amenities', properties: {'Amenities': amenities});
    AppConstant.mixPanelInstance!
      ..track('View Type', properties: {'View Type': viewType});
    if (mapSwitch) {
      AppConstant.mixPanelInstance!..track('Map Displayed');
    }
    User user = await App.getUser();
    AppConstant.mixPanelInstance!..identify(user.id!);
    AppConstant.mixPanelInstance!..getPeople().increment('Total Listings', 1);
  }

  updateAmenitiesSelection({List amenities = const []}) {
    amenities.forEach((val) {
      if (!amenitiesSelection.contains(val)) {
        amenitiesSelection.add(val);
      }
    });
    refreshUI();
  }

  void initializeProperty() async {
    if (this.property != null && this.property!.id != null) {
      updateAmenitiesSelection(amenities: this.property?.amenities ?? []);
      await setValues();
      createListingPresenter.fetchListingDetails(id: this.property!.id);

      // Initializing map coordinates for updating
      if (propertyCoordinates != null && propertyCoordinates!.isNotEmpty) {
        mapSwitch = true;
        refreshUI();
      }
    } else {
      await getProvinces();
    }
  }

  void switchHandler() async {
    if (mapSwitch == true) {
      propertyCoordinates = {};
      mapSwitch = false;
    } else {
      mapSwitch = true;
    }
    refreshUI();
  }

  // initialize values on updating
  setValues() async {
    numOfBedroomController.text = '${this.property!.totalBedRoom!}';
    numOfBathroomsController.text = '${this.property!.totalBathRoom!}';
    priceTextController.text = this.property!.formatPrice;
    areaTextController.text = this.property!.formatArea;
    frontageTextController.text = this.property!.formatFrontageArea;
    floorAreaTextController.text = this.property!.formatFloorArea;
    descriptionTextController.text = this.property!.description!;
    streetTextController.text = this.property!.street!;
    landmarkTextController.text = this.property!.landmark!;
    cityTextController.text = this.property!.city!;
    propertyType = this.property!.propertyType == 'Commercial'
        ? null
        : this.property!.propertyType;
    propertyFor = this.property!.propertyFor;
    ownwership = this.property!.ownership;
    timePeriod = this.property!.timePeriod;
    numberOfParking = this.property!.totalParkingSpace;
    isYourProperty = this.property!.isYourProperty;
    amenities = this.property!.amenities;
    viewType = this.property!.viewType;
    propertyCoordinates = this.property?.coordinates;
    pricing = this.property?.pricing;
    titleTextController.text =
        this.property!.title == null ? '' : this.property!.title!;

    if (propertyCoordinates != null) {
      latitude = propertyCoordinates!["Latitude"];
      longitude = propertyCoordinates!["Longitude"];
    }
    print('LatLong on update: $latitude , $longitude');

    if (this.property!.location != null) {
      await getProvinces();
      await getCities(this.property!.location['ProvinceCode']);
      await getBarangays(this.property!.location['CityCode']);
      selectedProvinceCode = this.property!.location['ProvinceCode'];
      selectedCityCode = this.property!.location['CityCode'];
      selectedBarangayCode = this.property!.location['BrgyCode'];
      selectedProvinceName = this.property!.location['ProvinceName'];
      selectedCityName = this.property!.location['CityName'];
      selectedBarangayName = this.property!.location['BrgyName'];

      subdivisionTextController.text = this.property!.location['Subdivision'];
      streetNameTextController.text = this.property!.location['Street'];
      houseNumberTextController.text = this.property!.location['HouseNo'];
      buildingNameTextController.text = this.property!.location['BuildingName'];
      floorTextController.text = this.property!.location['RoomNo'];

      showProvince = this.property!.location['ShowProvince'] ?? true;
      showCity = this.property!.location['ShowCity'] ?? true;
      showBarangay = this.property!.location['ShowBarangay'] ?? true;
      showSubdivision = this.property!.location['ShowSubdivision'] ?? true;
      showStreet = this.property!.location['ShowStreet'] ?? true;
      showHouseNumber = this.property!.location['ShowHouseNumber'] ?? true;
      showBuildingName = this.property!.location['ShowBuildingName'] ?? true;
      showFloorNumber = this.property!.location['ShowFloorNumber'] ?? true;

      AppConstant.showLoader(getContext(), false);
      Fluttertoast.cancel();
    } else {
      await getProvinces();
      AppConstant.showLoader(getContext(), false);
      Fluttertoast.cancel();
    }

    refreshUI();
  }

  Future<Map<dynamic, dynamic>?> getRegions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userToken = prefs.getString("accessToken");
    Map<dynamic, dynamic>? regions;

    var response = await http
        .post(Uri.parse("${Constants.siteURL}/api/listings/regions"), headers: {
      'Authorization': 'Bearer $userToken',
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    });

    var jsonResponse = await convert.jsonDecode(response.body);
    if (response.statusCode == 200) {
      regions = await convert.jsonDecode(response.body);
      print('Regions Length: ${jsonResponse['regions'].length}');
    }

    return regions;
  }

  //Setting location codes
  setSelectedProvinceCode({String? provinceName}) {
    selectedProvinceCode = provinceCodes[provinceNames.indexOf(provinceName)];
  }

  setSelectedCityCode({String? cityName}) {
    selectedCityCode = cityCodes[cityNames!.indexOf(cityName!)];
  }

  setSelectedBarangayCode({String? barangayName}) {
    selectedBarangayCode = brgyCodes[brgyNames!.indexOf(barangayName!)];
  }

  //Setting location names
  setSelectedProvinceName({String? provinceCode}) {
    selectedProvinceName = provinceNames[provinceCodes.indexOf(provinceCode)];
  }

  setSelectedCityName({String? cityCode}) {
    selectedCityName = cityNames![cityCodes.indexOf(cityCode)];
  }

  setSelectedBarangayName({String? barangayCode}) {
    selectedBarangayName = brgyNames![brgyCodes.indexOf(barangayCode)];
  }

  getProvinces() async {
    provinceNames.clear();
    provinceCodes.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    for (int region = 1; region <= 17; region++) {
      String apiLink =
          "${Constants.siteURL}/api/listings/provinces?region_id=$region";

      if (region < 10) {
        apiLink =
            "${Constants.siteURL}/api/listings/provinces?region_id=0$region";
      }
      var response = await http.get(Uri.parse(apiLink), headers: {
        'Authorization': 'Bearer ${prefs.getString("accessToken")}',
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      });

      var jsonResponse = await convert.jsonDecode(response.body);
      if (response.statusCode == 200) {
        // regions = await convert.jsonDecode(response.body);

        print('Provinces Length: ${jsonResponse['provinces'].length}');
        jsonResponse['provinces'].forEach((val) {
          provinceCodes.add(val['province_code']);
          provinceNames.add(val['province_name']);
          sortedProvinceNames?.add(val['province_name']);
          // provinces.add(DropdownMenuItem(
          //   child: Text(val['province_name']),
          //   value: val['province_code'],
          // ));
        });
      }
    }
    List<String?> sortedProvNames = [];
    sortedProvNames.addAll(provinceNames);
    sortedProvNames.sort(((a, b) => a!.compareTo(b!)));
    sortedProvinceNames?.sort(((a, b) => a.compareTo(b)));

    sortedProvNames.forEach((val) {
      provinces.add(DropdownMenuItem(
        child: Text(val!),
        value: provinceCodes[provinceNames.indexOf(val)],
      ));
    });

    refreshUI();
  }

  getCities(String? provinceID) async {
    refreshUI();
    cityNames?.clear();
    cityCodes.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // List<DropdownMenuItem<String>> citiesFromAPi = [];
    var response = await http.get(
        Uri.parse(
            "${Constants.siteURL}/api/listings/cities?province_id=$provinceID"),
        headers: {
          'Authorization': 'Bearer ${prefs.getString("accessToken")}',
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        });

    var jsonResponse = await convert.jsonDecode(response.body);
    if (response.statusCode == 200) {
      print('Cities Length: ${jsonResponse['cities'].length}');
      jsonResponse['cities'].forEach((val) {
        cityNames?.add(val['city_name']);
        cityCodes.add(val['city_code']);
        cities.add(DropdownMenuItem(
          child: Text(val['city_name']),
          value: val['city_code'],
        ));
      });
    }

    refreshUI();
  }

  getBarangays(String? cityID) async {
    brgyNames?.clear();
    brgyCodes.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http.get(
        Uri.parse(
            "${Constants.siteURL}/api/listings/barangays?city_id=$cityID"),
        headers: {
          'Authorization': 'Bearer ${prefs.getString("accessToken")}',
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        });

    var jsonResponse = await convert.jsonDecode(response.body);
    if (response.statusCode == 200) {
      print('Barangays Length: ${jsonResponse['barangays'].length}');
      jsonResponse['barangays'].forEach((val) {
        brgyNames?.add(val['brgy_name']);
        brgyCodes.add(val['brgy_code']);
        barangays.add(DropdownMenuItem(
          child: Text(val['brgy_name']),
          value: val['brgy_code'],
        ));
      });
    }

    refreshUI();
  }

  validatePage1() {
    bool isValidated = false;
    bool numberFound = priceTextController.text.contains(new RegExp(r'[0-9]'));

    if (propertyType != null) {
      // Validation for lot and Commercial
      if (propertyType == 'Commercial Lot' ||
          propertyType == 'Commercial Building') {
        if (propertyFor != null && propertyFor == "Rent") {
          // Rent validation
          if (timePeriod != null &&
              priceTextController.text.isNotEmpty &&
              numberFound == true &&
              pricing != null &&
              priceTextController.text != '0') {
            isValidated = true;
          }
        } else if (propertyFor != null && propertyFor == "Sell") {
          //Sale validation
          timePeriod = null;
          if (priceTextController.text.isNotEmpty &&
              numberFound == true &&
              pricing != null &&
              priceTextController.text != '0') {
            isValidated = true;
          }
        }
      } else {
        pricing = null;
        if (propertyFor != null && propertyFor == "Rent") {
          // Rent validation
          if (timePeriod != null &&
              priceTextController.text.isNotEmpty &&
              numberFound == true &&
              priceTextController.text != '0') {
            isValidated = true;
          }
        } else if (propertyFor != null && propertyFor == "Sell") {
          //Sale validation
          timePeriod = null;
          if (priceTextController.text.isNotEmpty &&
              numberFound == true &&
              priceTextController.text != '0') {
            isValidated = true;
          }
        }
      }
    }

    // Error Message if isValidated is False
    if (isValidated == false) {
      AppConstant.statusDialog(
          context: getContext(),
          text: "All inputs in this section are required.",
          title: "Values missing.");
    }

    return isValidated;
  }

  validatePage2() {
    bool isValidated = false;
    // bool numberFound = areaTextController.text.contains(new RegExp(r'[0-9]'));

    bool generalValidation =
        page2GeneralValidation(); // Execute the general validation

    if (propertyType == 'Residential House') {
      if (generalValidation && residentialHouseValidationPage2()) {
        isValidated = true;
      }
    } else if (propertyType == 'Apartment') {
      if (generalValidation && apartmentValidationPage2()) {
        isValidated = true;
      }
    } else if (propertyType == 'Condo') {
      if (generalValidation && condoValidationPage2()) {
        isValidated = true;
      }
    } else if (propertyType == 'Villa') {
      if (generalValidation && villaValidationPage2()) {
        isValidated = true;
      }
    } else if (propertyType == 'Townhouse') {
      if (generalValidation && townhouseValidationPage2()) {
        isValidated = true;
      }
    } else if (propertyType == 'Commercial Building') {
      if (generalValidation && commercialBuildingValidationPage2()) {
        isValidated = true;
      }
    } else if (propertyType == 'Warehouse') {
      if (generalValidation && warehouseValidationPage2()) {
        isValidated = true;
      }
    } else if (propertyType == 'Commercial Lot') {
      if (generalValidation && commercialLotValidationPage2()) {
        isValidated = true;
      }
    } else if (propertyType == 'Lot') {
      if (generalValidation && lotValidationPage2()) {
        isValidated = true;
      }
    } else if (propertyType == 'Farm Lot') {
      if (generalValidation && farmLotValidationPage2()) {
        isValidated = true;
      }
    } else if (propertyType == 'Beach') {
      if (generalValidation && beachValidationPage2()) {
        isValidated = true;
      }
    }

    // Error Message if isValidated is False
    if (isValidated == false) {
      AppConstant.statusDialog(
          context: getContext(),
          text: "All inputs in this section are required.",
          title: "Values missing.");
    }
    return isValidated;
  }

  bool page2GeneralValidation() {
    bool isValidated = false;

    if (titleTextController.text.isNotEmpty &&
        descriptionTextController.text.isNotEmpty) {
      isValidated = true;
    }

    print('General validation is: $isValidated');
    return isValidated;
  }

  bool residentialHouseValidationPage2() {
    bool isValidated = false;
    if (numOfBathroomsController.text != '' &&
        numOfBathroomsController.text != '' &&
        numberOfParking != null &&
        areaTextController.text.isNotEmpty &&
        areaTextController.text != '0' &&
        floorAreaTextController.text.isNotEmpty &&
        floorAreaTextController.text != '0' &&
        isYourProperty != null &&
        ownwership != null) {
      isValidated = true;
    }
    print('residential validation is: $isValidated');
    return isValidated;
  }

  bool apartmentValidationPage2() {
    bool isValidated = false;
    if (numOfBathroomsController.text != '' &&
        numOfBathroomsController.text != '' &&
        numberOfParking != null &&
        areaTextController.text.isNotEmpty &&
        areaTextController.text != '0' &&
        floorAreaTextController.text.isNotEmpty &&
        floorAreaTextController.text != '0' &&
        isYourProperty != null &&
        ownwership != null) {
      isValidated = true;
    }
    print('apartment validation is: $isValidated');
    return isValidated;
  }

  bool condoValidationPage2() {
    bool isValidated = false;
    areaTextController.text = '';
    if (numOfBathroomsController.text != '' &&
        numOfBathroomsController.text != '' &&
        numberOfParking != null &&
        floorAreaTextController.text.isNotEmpty &&
        floorAreaTextController.text != '0' &&
        isYourProperty != null &&
        ownwership != null) {
      isValidated = true;
    }
    print('condo validation is: $isValidated');
    return isValidated;
  }

  bool villaValidationPage2() {
    bool isValidated = false;
    if (numOfBathroomsController.text != '' &&
        numOfBathroomsController.text != '' &&
        numberOfParking != null &&
        areaTextController.text.isNotEmpty &&
        areaTextController.text != '0' &&
        floorAreaTextController.text.isNotEmpty &&
        floorAreaTextController.text != '0' &&
        isYourProperty != null &&
        ownwership != null) {
      isValidated = true;
    }
    print('villa validation is: $isValidated');
    return isValidated;
  }

  bool townhouseValidationPage2() {
    bool isValidated = false;
    if (numOfBathroomsController.text != '' &&
        numOfBathroomsController.text != '' &&
        numberOfParking != null &&
        areaTextController.text.isNotEmpty &&
        areaTextController.text != '0' &&
        floorAreaTextController.text.isNotEmpty &&
        floorAreaTextController.text != '0' &&
        isYourProperty != null &&
        ownwership != null) {
      isValidated = true;
    }
    print('townhouse validation is: $isValidated');
    return isValidated;
  }

  bool commercialBuildingValidationPage2() {
    bool isValidated = false;

    numOfBedroomController.text = '';
    numOfBathroomsController.text = '';

    if (numberOfParking != null &&
        areaTextController.text.isNotEmpty &&
        areaTextController.text != '0' &&
        isYourProperty != null &&
        ownwership != null) {
      isValidated = true;
    }
    print('commercial building validation is: $isValidated');
    return isValidated;
  }

  bool warehouseValidationPage2() {
    bool isValidated = false;

    numOfBedroomController.text = '';
    numOfBathroomsController.text = '';

    if (numberOfParking != null &&
        areaTextController.text.isNotEmpty &&
        areaTextController.text != '0' &&
        floorAreaTextController.text.isNotEmpty &&
        floorAreaTextController.text != '0' &&
        isYourProperty != null &&
        ownwership != null) {
      isValidated = true;
    }
    print('warehouse validation is: $isValidated');
    return isValidated;
  }

  bool commercialLotValidationPage2() {
    bool isValidated = false;

    numOfBedroomController.text = '';
    numOfBathroomsController.text = '';
    floorAreaTextController.text = '';
    numberOfParking = null;
    isYourProperty = null;

    if (areaTextController.text.isNotEmpty &&
        areaTextController.text != '0' &&
        ownwership != null) {
      isValidated = true;
    }
    print('commercial lot validation is: $isValidated');
    return isValidated;
  }

  bool lotValidationPage2() {
    bool isValidated = false;

    numOfBedroomController.text = '';
    numOfBathroomsController.text = '';
    floorAreaTextController.text = '';
    numberOfParking = null;
    isYourProperty = null;

    if (areaTextController.text.isNotEmpty &&
        areaTextController.text != '0' &&
        ownwership != null) {
      isValidated = true;
    }
    print('lot validation is: $isValidated');
    return isValidated;
  }

  bool farmLotValidationPage2() {
    bool isValidated = false;

    numOfBedroomController.text = '';
    numOfBathroomsController.text = '';
    floorAreaTextController.text = '';
    numberOfParking = null;
    isYourProperty = null;

    if (areaTextController.text.isNotEmpty &&
        areaTextController.text != '0' &&
        ownwership != null) {
      isValidated = true;
    }
    print('farm lot validation is: $isValidated');
    return isValidated;
  }

  bool beachValidationPage2() {
    bool isValidated = false;

    numOfBedroomController.text = '';
    numOfBathroomsController.text = '';
    floorAreaTextController.text = '';
    numberOfParking = null;
    isYourProperty = null;

    if (areaTextController.text.isNotEmpty &&
        areaTextController.text != '0' &&
        ownwership != null) {
      isValidated = true;
    }
    print('beach validation is: $isValidated');
    return isValidated;
  }

  validatePage3() {
    bool isValidated = false;
    List<String> fieldsMissing = [];
    String errorFields;
    String errorMsg = '';

    if (selectedProvinceCode != null &&
        selectedCityCode != null &&
        selectedBarangayCode != null) {
      if (propertyType == 'Condo') {
        subdivisionTextController.text = '';
        showSubdivision = false;
      } else if (propertyType == 'Commercial Building' ||
          propertyType == 'Farm Lot' ||
          propertyType == 'Beach') {
        showHouseNumber = false;
        houseNumberTextController.text = '';
        showBuildingName = false;
        buildingNameTextController.text = '';
        showFloorNumber = false;
        floorTextController.text = '';
      } else if (propertyType == 'Commercial Lot' || propertyType == 'Lot') {
        showBuildingName = false;
        buildingNameTextController.text = '';
        showFloorNumber = false;
        floorTextController.text = '';
      }

      isValidated = true;
    } else {
      if (selectedProvinceCode == null) {
        fieldsMissing.add('Province');
      }
      if (selectedCityCode == null) {
        fieldsMissing.add('City');
      }
      if (selectedBarangayCode == null) {
        fieldsMissing.add('Barangay');
      }
      if (fieldsMissing.length != 0) {
        errorFields = fieldsMissing.join(", ");
        errorMsg = "$errorFields are required.";
      }

      // if (subdivisionTextController.text.isEmpty ||
      //     streetNameTextController.text.isEmpty ||
      //     houseNumberTextController.text.isEmpty ||
      //     buildingNameTextController.text.isEmpty ||
      //     floorTextController.text.isEmpty) {
      //   errorMsg =
      //       '$errorMsg Please provide at least one of the following: Subdivision, Street Name, Lot/Block/Phase/House Number, Building Name and Unit/Room No./Floor.';
      // }
    }

    if (isValidated == false) {
      errorFields = fieldsMissing.join(", ");

      AppConstant.statusDialog(
          context: getContext(), text: errorMsg, title: "Values missing.");
    }
    return isValidated;
  }

  validatePage4() {
    bool isValidated = true;

    // if (amenities!.length >= 1) {
    //   isValidated = true;
    // } else
    //   AppConstant.statusDialog(
    //       context: getContext(),
    //       text: "Choose at least 1 amenities.",
    //       title: "Choose more amenities.");

    return isValidated;
  }

  validatePage5() async {
    print('INSIDE PAGE 5 VALIDATION');
    bool isValidated = false;
    print('isupdating $isUpdating');
    print('Assets length: ${assets.length}');

    // === Create listing Photo Validation
    if (isUpdating == false) {
      if (assets.length >= 1) {
        isValidated = true;
      } else {
        await AppConstant.statusDialog(
            context: getContext(),
            text: "Please Upload atlease 1 photo",
            title: "Upload Photos.");
        return false;
      }

      final confirmViewType =
          await _viewType(getContext()); //select porperty view type
      print('AFTER VIEW TYPE');

      if (confirmViewType == null) {
        AppConstant.statusDialog(
            context: getContext(),
            text: "Please confirm the view type of your list.",
            title: "Confirm");
        return false;
      }

      await AppConstant.statusDialog(
          context: getContext(),
          text: "Your listing will view as $confirmViewType",
          title: "View Type");
    } else {
      // === Updating list Photo validation
      int? totalPhotos = assets.length + currentPhotosCount;
      if (totalPhotos >= 1) {
        isValidated = true;
      } else {
        await AppConstant.statusDialog(
            context: getContext(),
            text: "Upload at least 1 photo.",
            title: "Upload Photos.");
        return false;
      }
    }

    return isValidated;
  }

  void updateListing() async {
    final confirmViewType = await _viewType(getContext());
    if (confirmViewType == null) {
      await AppConstant.statusDialog(
          context: getContext(),
          text: "Please confirm the view type of your list.",
          title: "Confirm");
      return;
    }

    AppConstant.showLoader(getContext(), true);

    // Converts price and area to double
    double price = double.parse(priceTextController.text.replaceAll(',', ''));
    double area = double.parse(areaTextController.text.replaceAll(',', ''));
    double? frontageArea;
    double? floorArea;
    if (frontageTextController.text != '') {
      frontageArea =
          double.parse(frontageTextController.text.replaceAll(',', ''));
    } else {
      frontageArea = 0;
    }
    if (floorAreaTextController.text != '') {
      floorArea =
          double.parse(floorAreaTextController.text.replaceAll(',', ''));
    } else {
      floorArea = 0;
    }

    final assetsBased64;
    if (assets.length > 0) {
      assetsBased64 = await AppConstant.initializeAssetImages(images: assets);
    } else {
      assetsBased64 = null;
    }

    location["ProvinceCode"] = selectedProvinceCode;
    location["ProvinceName"] =
        provinceNames[provinceCodes.indexOf(selectedProvinceCode)];
    location["CityName"] = cityNames![cityCodes.indexOf(selectedCityCode)];
    location["BrgyName"] = selectedBarangayName;
    location["CityCode"] = selectedCityCode;
    location["BrgyCode"] = selectedBarangayCode;
    location["Subdivision"] = subdivisionTextController.text;
    location["Street"] = streetNameTextController.text;
    location["HouseNo"] = houseNumberTextController.text;
    location["BuildingName"] = buildingNameTextController.text;
    location["RoomNo"] = floorTextController.text;

    /// visisbility
    location["ShowProvince"] = showProvince;
    location["ShowCity"] = showCity;
    location["ShowBarangay"] = showBarangay;
    location["ShowSubdivision"] = showSubdivision;
    location["ShowStreet"] = showStreet;
    location["ShowHouseNumber"] = showHouseNumber;
    location["ShowBuildingName"] = showBuildingName;
    location["ShowFloorNumber"] = showFloorNumber;

    Map data = {
      "id": this.property!.id,
      "cover_photo": 'https://picsum.photos/id/73/200/300',
      "photos": currentPhotos,
      "property_type": propertyType,
      "property_for": propertyFor,
      "time_period": timePeriod,
      "price": price,
      "number_of_bedrooms":
          numOfBedroomController.text == '' ? 0 : numOfBedroomController.text,
      "number_of_bathrooms": numOfBathroomsController.text == ''
          ? 0
          : numOfBathroomsController.text,
      "number_of_parking_space":
          numberOfParking == null ? '0' : numberOfParking,
      "total_area": area,
      "is_your_property": isYourProperty,
      "description": descriptionTextController.text,
      "street": streetTextController.text,
      "landmark": landmarkTextController.text,
      "city": cityTextController.text,
      "amenities": amenities,
      "view_type": viewType,
      "coordinates": propertyCoordinates,
      "assets": assetsBased64,
      "floor_area": floorArea,
      "frontage_area": frontageArea,
      "ownership": ownwership,
      "pricing": pricing,
      "location": location,
      "title": titleTextController.text
    };

    createListingPresenter.updateListing(data);
  }

  void createListing() async {
    AppConstant.showLoader(getContext(), true);

    final assetsBased64 =
        await AppConstant.initializeAssetImages(images: assets);

    //=== Converting price and area to double
    double price = double.parse(priceTextController.text.replaceAll(',', ''));
    double area = double.parse(areaTextController.text.replaceAll(',', ''));
    double? frontageArea;
    double? floorArea;
    int? bedrooms = 0;
    int? bathrooms = 0;
    if (frontageTextController.text != '') {
      frontageArea =
          double.parse(frontageTextController.text.replaceAll(',', ''));
    }
    if (floorAreaTextController.text != '') {
      floorArea =
          double.parse(floorAreaTextController.text.replaceAll(',', ''));
    }

    if (numOfBedroomController.text != '') {
      bedrooms = int.parse(numOfBedroomController.text);
    }

    if (numOfBedroomController.text != '') {
      bathrooms = int.parse(numOfBathroomsController.text);
    }

    location["ProvinceCode"] = selectedProvinceCode;
    location["ProvinceName"] = selectedProvinceName;
    location["CityName"] = selectedCityName;
    location["BrgyName"] = selectedBarangayName;
    location["CityCode"] = selectedCityCode;
    location["BrgyCode"] = selectedBarangayCode;
    location["Subdivision"] = subdivisionTextController.text;
    location["Street"] = streetNameTextController.text;
    location["HouseNo"] = houseNumberTextController.text;
    location["BuildingName"] = buildingNameTextController.text;
    location["RoomNo"] = floorTextController.text;

    /// visisbility
    location["ShowProvince"] = showProvince;
    location["ShowCity"] = showCity;
    location["ShowBarangay"] = showBarangay;
    location["ShowSubdivision"] = showSubdivision;
    location["ShowStreet"] = showStreet;
    location["ShowHouseNumber"] = showHouseNumber;
    location["ShowBuildingName"] = showBuildingName;
    location["ShowFloorNumber"] = showFloorNumber;

    var listing = {
      "cover_photo": 'https://picsum.photos/id/73/200/300',
      "photos": [],
      "property_type": propertyType,
      "property_for": propertyFor,
      "time_period": timePeriod,
      "price": price,

      "number_of_bedrooms": bedrooms,
      "number_of_bathrooms": bathrooms,
      "number_of_parking_space": numberOfParking,
      "total_area": area,
      "is_your_property": isYourProperty,
      "description": descriptionTextController.text,

      "street": streetTextController.text,
      "landmark": landmarkTextController.text,
      "city": cityTextController.text,

      "amenities": amenities,

      "assets": assetsBased64, // for photos

      "coordinates": propertyCoordinates,

      "view_type": viewType,
      "floor_area": floorArea,
      "frontage_area": frontageArea,
      "ownership": ownwership,
      "pricing": pricing,
      "location": location,
      "title": titleTextController.text
    };
    mixpanelSendData();

    createListingPresenter.createListing(listing: listing);
  }

  Future _statusDialog(String title, String text,
      {bool? success, Function? onPressed}) async {
    return await AppConstant.statusDialog(
        context: getContext(),
        success: success ?? false,
        title: title,
        text: text,
        onPressed: onPressed);
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
                  borderRadius: BorderRadius.circular(10.0)),
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
                constraints:
                    BoxConstraints(maxHeight: double.infinity, maxWidth: 300),
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
                            radioPadding: 15,
                            radioWidth: 130,
                            buttonLables: [
                              "Public",
                              "Private",
                            ],
                            buttonValues: [
                              "public",
                              "private",
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
                        text:
                            """If you choose Public, your connections will be able to see you listings.

While choosing Private means that you are the only one who can see your listings. But you can change it to public anytime. 
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
    amenities = [];

    createListingPresenter
        .dispose(); // don't forget to dispose of the presenter
    Loader.hide();
    super.onDisposed();
  }
}
