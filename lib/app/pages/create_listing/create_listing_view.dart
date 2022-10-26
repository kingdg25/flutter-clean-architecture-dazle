import 'package:cached_network_image/cached_network_image.dart';
import 'package:dazle/app/pages/create_listing/create_listing_controller.dart';
import 'package:dazle/app/utils/app.dart';
import 'package:dazle/app/utils/app_constant.dart';
import 'package:dazle/app/widgets/custom_appbar.dart';
import 'package:dazle/app/widgets/form_fields/amenities_check_box_group.dart';
import 'package:dazle/app/widgets/form_fields/custom_dropdown_search.dart';
import 'package:dazle/app/widgets/form_fields/custom_icon_button.dart';
import 'package:dazle/app/widgets/form_fields/custom_radio_group_button.dart';
import 'package:dazle/app/widgets/form_fields/custom_text_field.dart';
import 'package:dazle/app/widgets/form_fields/custom_upload_field.dart';
import 'package:dazle/app/widgets/form_fields/custom_dropdown.dart';
import 'package:dazle/app/widgets/profile/box_container.dart';
import 'package:dazle/data/repositories/data_listing_repository.dart';
import 'package:dazle/domain/entities/property.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:pattern_formatter/pattern_formatter.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../../widgets/custom_text.dart';
import '../../widgets/form_fields/amenities_field.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../widgets/form_fields/custom_button.dart';
import '../../widgets/form_fields/custom_button_reverse.dart';
import '../map_location_picker/map_location_picker_view.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_switch/flutter_switch.dart';

class CreateListingPage extends View {
  final Property? property;
  CreateListingPage({Key? key, this.property}) : super(key: key);

  @override
  _CreateListingPageState createState() => _CreateListingPageState(property);
}

class _CreateListingPageState
    extends ViewState<CreateListingPage, CreateListingController> {
  _CreateListingPageState(property)
      : appBarTitle = (property != null && property.id != null)
            ? "Update Listing"
            : 'Create Listing',
        super(CreateListingController(DataListingRepository(), property));
  String appBarTitle = 'Create Listing';
  List<Widget> createListingList = [];
  int currentPage = 1;
  int totalPage = 0;

  final CarouselController _carouselController = CarouselController();
  int _currentImage = 0;
  bool status1 = false;

  @override
  Widget get view {
    String photoCounter = (_currentImage + 1).toString().padLeft(2, '0');
    String? totalPhoto =
        widget.property?.photos?.length.toString().padLeft(2, '0');
    List _currentPhotos = widget.property?.photos ?? [];

    /// Converts the list property.photos to a list of widgets to be used
    /// by the CarouselSlider widget
    final List<Widget>? imageSliders = _currentPhotos
        .map((item) => Container(
              child: Container(
                // margin: EdgeInsets.all(5.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    child: Stack(
                      children: <Widget>[
                        Image.network(item, fit: BoxFit.cover, width: 1000.0),
                      ],
                    )),
              ),
            ))
        .toList();

    /// FOR HIDING NON-GENERAL FIELDS IN PAGE 2
    List<String> furnishedAndFloorAreaProperties = [
      'Apartment',
      'Condo',
      'Villa',
      'Townhouse',
      'Commercial Building',
      'Warehouse',
      'Residential House'
    ];
    List<String> bedroomAndBathroomProperties = [
      'Apartment',
      'Condo',
      'Villa',
      'Townhouse',
      'Residential House'
    ];
    List<String> frontageAreaProperties = [
      'Villa',
      'Townhouse',
      'Residential House'
    ];
    return Scaffold(
      key: globalKey,
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        title: appBarTitle,
        automaticallyImplyLeading: false,
        customLeading: ControlledWidgetBuilder<CreateListingController>(
          builder: (context, controller) {
            return IconButton(
              icon: Icon(Icons.close_rounded, color: Colors.black),
              tooltip: MaterialLocalizations.of(context).backButtonTooltip,
              onPressed: () {
                AppConstant.deleteDialog(
                    context: context,
                    title: 'Confim',
                    text: (widget.property != null &&
                            widget.property?.id != null)
                        ? 'Are you sure you want to cancel Update Listing?'
                        : 'Are you sure you want to close Create Listing Form?',
                    onConfirm: () {
                      if (widget.property == null) {
                        AppConstant.mixPanelInstance!.track(
                            'Exit Create Listing',
                            properties: {'Exited in': 'Step $currentPage'});
                      }
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    });
              },
            );
          },
        ),
        actions: [
          ControlledWidgetBuilder<CreateListingController>(
              builder: (context, controller) {
            // Check if its updating
            if (widget.property != null) {
              controller.isUpdating = true;
              controller.currentPhotosCount = widget.property!.photos!.length;
            }
            return Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(right: 10.0),
              child: Text.rich(
                  TextSpan(children: [
                    TextSpan(text: "Step $currentPage "),
                    TextSpan(
                        text: "of $totalPage",
                        style: App.textStyle(
                            fontSize: 12,
                            color: App.hintColor,
                            fontWeight: FontWeight.w600)),
                  ]),
                  style:
                      App.textStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            );
          })
        ],
      ),
      backgroundColor: Colors.white,
      body: ControlledWidgetBuilder<CreateListingController>(
          builder: (context, controller) {
        var _pageController = controller.createListingPageController;

        // Page 2 required properties
        List<String> floorAreaRequiredProperties = [
          'Residential House',
          'Apartment',
          'Condo',
          'Villa',
          'Townhouse',
          'Commercial Building',
          'Warehouse'
        ];

        List<String> furnishedRequiredProperties = [
          'Residential House',
          'Apartment',
          'Condo',
          'Villa',
          'Townhouse',
          'Commercial Building',
          'Warehouse'
        ];

        createListingList = [
          // page 1
          ListView(
            padding: EdgeInsets.only(bottom: 20),
            children: [
              AppConstant.customTitleFieldWithSubtext(
                padding: EdgeInsets.only(left: 18),
                title: 'Property Type',
                optionalText: 'required',
                optionalTextColor: Colors.red,
              ),
              CustomRadioGroupButton(
                autowidth: true,
                radioWidth: 120,
                buttonLables: [
                  "Residential House",
                  "Apartment",
                  "Condo",
                  "Villa",
                  "Townhouse",
                  "Commercial Lot",
                  "Commercial Building",
                  "Warehouse",
                  "Lot",
                  "Farm Lot",
                  "Beach",
                ],
                buttonValues: [
                  "Residential House",
                  "Apartment",
                  "Condo",
                  "Villa",
                  "Townhouse",
                  "Commercial Lot",
                  "Commercial Building",
                  "Warehouse",
                  "Lot",
                  "Farm Lot",
                  "Beach",
                ],
                radioButtonValue: (value) {
                  controller.propertyType = value;
                  if (value == "Commercial Building" ||
                      value == "Commercial Lot") {
                  } else {
                    controller.pricing = '';
                  }
                  setState(() {});
                },
                defaultSelected: controller.propertyType,
              ),
              AppConstant.customTitleFieldWithSubtext(
                title: 'Property For',
                optionalText: 'required',
                optionalTextColor: Colors.red,
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: CustomRadioGroupButton(
                  radioPadding: 15,
                  buttonLables: [
                    "Sell",
                    "Rent",
                  ],
                  buttonValues: [
                    "Sell",
                    "Rent",
                  ],
                  radioButtonValue: (value) {
                    controller.propertyFor = value;
                    setState(() {});
                  },
                  defaultSelected: controller.propertyFor,
                ),
              ),
              controller.propertyFor == 'Rent'
                  ? AppConstant.customTitleFieldWithSubtext(
                      title: 'Time Period',
                      optionalText: 'required',
                      optionalTextColor: Colors.red,
                    )
                  : Container(),
              controller.propertyFor == 'Rent'
                  ? CustomRadioGroupButton(
                      radioPadding: 15,
                      buttonLables: ["Yearly", "Monthly"],
                      buttonValues: ["Year", "Month"],
                      radioButtonValue: (value) {
                        controller.timePeriod = value;
                      },
                      defaultSelected: controller.timePeriod == ''
                          ? null
                          : controller.timePeriod)
                  : Container(),
              controller.propertyType == "Commercial" ||
                      controller.propertyType == "Commercial Lot" ||
                      controller.propertyType == "Commercial Building"
                  ? AppConstant.customTitleFieldWithSubtext(
                      title: 'Pricing',
                      optionalText: 'required',
                      optionalTextColor: Colors.red,
                    )
                  : Container(),
              controller.propertyType == "Commercial" ||
                      controller.propertyType == "Commercial Lot" ||
                      controller.propertyType == "Commercial Building"
                  ? Container(
                      alignment: Alignment.centerLeft,
                      child: CustomRadioGroupButton(
                        radioPadding: 15,
                        buttonLables: ["Total Price", "Per sqm"],
                        buttonValues: ["Total Price", "Per sqm"],
                        radioButtonValue: (value) {
                          controller.pricing = value;
                          setState(() {});
                        },
                        defaultSelected: controller.pricing == ''
                            ? null
                            : controller.pricing,
                      ),
                    )
                  : Container(),
              AppConstant.customTitleFieldWithSubtext(
                title:
                    controller.pricing == 'Per sqm' ? 'Price per sqm' : 'Price',
                optionalText: 'required',
                optionalTextColor: Colors.red,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: CustomTextField(
                  controller: controller.priceTextController,
                  keyboardType: const TextInputType.numberWithOptions(),
                  hintText: 'Price (PHP)',
                  inputFormatters: [ThousandsFormatter(allowFraction: true)],
                ),
              ),
              SizedBox(
                height: 80.0,
              )
            ],
          ),
          // page 2
          ListView(
            padding: EdgeInsets.only(bottom: 20),
            children: [
              bedroomAndBathroomProperties.contains(controller.propertyType) ==
                      false
                  ? Container()
                  : AppConstant.customTitleFieldWithSubtext(
                      padding: EdgeInsets.only(left: 18),
                      title: 'Number of Bedrooms',
                      optionalText: 'required',
                      optionalTextColor: Colors.red,
                    ),
              bedroomAndBathroomProperties.contains(controller.propertyType) ==
                      false
                  ? Container()
                  : Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: CustomTextField(
                        controller: controller.numOfBedroomController,
                        keyboardType: const TextInputType.numberWithOptions(),
                        hintText: 'Number of Bedrooms',
                        inputFormatters: [
                          ThousandsFormatter(allowFraction: false)
                        ],
                      ),
                    ),
              bedroomAndBathroomProperties.contains(controller.propertyType) ==
                      false
                  ? Container()
                  : AppConstant.customTitleFieldWithSubtext(
                      title: 'Number of Bathrooms',
                      optionalText: 'required',
                      optionalTextColor: Colors.red,
                    ),
              bedroomAndBathroomProperties.contains(controller.propertyType) ==
                      false
                  ? Container()
                  : Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: CustomTextField(
                        controller: controller.numOfBathroomsController,
                        keyboardType: const TextInputType.numberWithOptions(),
                        hintText: 'Number of Bathrooms',
                        inputFormatters: [
                          ThousandsFormatter(allowFraction: true)
                        ],
                      ),
                    ),
              controller.propertyType == 'Commercial Lot' ||
                      controller.propertyType == 'Beach' ||
                      controller.propertyType == 'Lot' ||
                      controller.propertyType == 'Farm Lot'
                  ? Container()
                  : AppConstant.customTitleFieldWithSubtext(
                      title: 'Number of Parking',
                      optionalText: 'required',
                      optionalTextColor: Colors.red,
                    ),
              controller.propertyType == 'Commercial Lot' ||
                      controller.propertyType == 'Beach' ||
                      controller.propertyType == 'Lot' ||
                      controller.propertyType == 'Farm Lot'
                  ? Container()
                  : CustomRadioGroupButton(
                      radioWidth: 55,
                      buttonLables: [
                        "0",
                        "1",
                        "2",
                        "3",
                        "4",
                        "5",
                        "6",
                        "7",
                        "8",
                        "9",
                        "10"
                      ],
                      buttonValues: [
                        "0",
                        "1",
                        "2",
                        "3",
                        "4",
                        "5",
                        "6",
                        "7",
                        "8",
                        "9",
                        "10"
                      ],
                      radioButtonValue: (value) {
                        controller.numberOfParking = value;
                      },
                      defaultSelected: controller.numberOfParking,
                    ),
              controller.propertyType == 'Condo'
                  ? Container()
                  : AppConstant.customTitleFieldWithSubtext(
                      title: 'Lot Area',
                      optionalText: 'required',
                      optionalTextColor: Colors.red,
                    ),
              controller.propertyType == 'Condo'
                  ? Container()
                  : Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: CustomTextField(
                        controller: controller.areaTextController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        hintText: 'Area (sqm)',
                        inputFormatters: [
                          ThousandsFormatter(allowFraction: true)
                        ],
                      ),
                    ),
              floorAreaRequiredProperties.contains(controller.propertyType)
                  ? AppConstant.customTitleFieldWithSubtext(
                      title: 'Floor Area',
                      optionalText:
                          controller.propertyType != 'Commercial Building'
                              ? 'required'
                              : 'optional',
                      optionalTextColor:
                          controller.propertyType != 'Commercial Building'
                              ? Colors.red
                              : App.textColor)
                  : Container(),
              floorAreaRequiredProperties.contains(controller.propertyType)
                  ? Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: CustomTextField(
                        controller: controller.floorAreaTextController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        hintText: 'Floor Area (sqm)',
                        inputFormatters: [
                          ThousandsFormatter(allowFraction: true)
                        ],
                      ),
                    )
                  : Container(),
              AppConstant.customTitleFieldWithSubtext(
                title: 'Frontage',
                optionalText: 'optional',
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: CustomTextField(
                  controller: controller.frontageTextController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  hintText: 'Frontage (meters)',
                  inputFormatters: [ThousandsFormatter(allowFraction: true)],
                ),
              ),
              furnishedRequiredProperties.contains(controller.propertyType) ==
                      false
                  ? Container()
                  : AppConstant.customTitleFieldWithSubtext(
                      padding: EdgeInsets.only(left: 18),
                      title: 'Is your Property',
                      optionalText: 'required',
                      optionalTextColor: Colors.red),
              furnishedRequiredProperties.contains(controller.propertyType) ==
                      false
                  ? Container()
                  : CustomRadioGroupButton(
                      autowidth: true,
                      radioWidth: 120,
                      buttonLables: controller.propertyType == 'Warehouse' ||
                              controller.propertyType == 'Commercial Building'
                          ? [
                              "Furnished",
                              "Unfurnished",
                              "Partly Furnished",
                              "None",
                            ]
                          : [
                              "Furnished",
                              "Unfurnished",
                              "Partly Furnished",
                            ],
                      buttonValues: controller.propertyType == 'Warehouse' ||
                              controller.propertyType == 'Commercial Building'
                          ? [
                              "Furnished",
                              "Unfurnished",
                              "Partly Furnished",
                              "None",
                            ]
                          : [
                              "Furnished",
                              "Unfurnished",
                              "Partly Furnished",
                            ],
                      radioButtonValue: (value) {
                        controller.isYourProperty = value;
                      },
                      defaultSelected: controller.isYourProperty,
                    ),
              AppConstant.customTitleFieldWithSubtext(
                padding: EdgeInsets.only(left: 18),
                title: 'Ownership',
                optionalText: 'required',
                optionalTextColor: Colors.red,
              ),
              CustomRadioGroupButton(
                autowidth: true,
                radioWidth: 120,
                buttonLables: ["Freehold", "Leasehold", "None"],
                buttonValues: ["Freehold", "Leasehold", "None"],
                radioButtonValue: (value) {
                  controller.ownwership = value;
                },
                defaultSelected: controller.ownwership,
              ),
              AppConstant.customTitleFieldWithSubtext(
                title: 'Listing Title',
                optionalText: 'required',
                optionalTextColor: Colors.red,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: CustomTextField(
                  controller: controller.titleTextController,
                  hintText: 'Listing Title',
                ),
              ),
              AppConstant.customTitleFieldWithSubtext(
                title: 'Description',
                optionalText: 'required',
                optionalTextColor: Colors.red,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: CustomTextField(
                  controller: controller.descriptionTextController,
                  keyboardType: TextInputType.multiline,
                  minLines: 3,
                  maxLines: 3,
                  hintText: 'description',
                ),
              ),
              SizedBox(
                height: 80.0,
              )
            ],
          ),
          // page 3
          ListView(
            padding: EdgeInsets.symmetric(vertical: 20),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(51, 212, 157, 0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.all(20.0),
                  child: CustomText(
                    // fontSize: 16,
                    text:
                        'For Security Purposes, you can choose to either show or hide your listing location by tapping the button.',
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
              false
                  ? Container()
                  : AppConstant.customTitleField(title: 'Display Map:'),
              Container(
                padding: EdgeInsets.only(left: 18, bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    FlutterSwitch(
                      showOnOff: true,
                      activeColor: App.mainColor,
                      activeTextColor: App.textColor,
                      inactiveColor: App.textColor,
                      width: 60,
                      height: 30,
                      value: controller.mapSwitch,
                      onToggle: (val) async {
                        // setState(() {
                        controller.switchHandler();
                        // });
                        if (controller.mapSwitch == true) {
                          LatLng? mapCoordinates = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (buildContext) =>
                                      MapLocationPicker()));
                          // setting propertyCoordinates
                          if (mapCoordinates != null) {
                            controller.latitude = mapCoordinates.latitude;
                            controller.longitude = mapCoordinates.longitude;

                            controller.propertyCoordinates = {
                              'Latitude': mapCoordinates.latitude,
                              'Longitude': mapCoordinates.longitude
                            };
                          }
                        }
                        setState(() {});
                      },
                    ),
                    SizedBox(width: 10),
                    controller.mapSwitch
                        ? Text('(Tap map to update Property Location.)')
                        : Container(),
                  ],
                ),
              ),
              controller.mapSwitch
                  ? Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: GestureDetector(
                        child: CachedNetworkImage(
                          imageUrl:
                              // "https://maps.googleapis.com/maps/api/staticmap?center=8.482298546726664,%20124.64927255100129&zoom=19&size=400x400&key=AIzaSyCSacvsau8vEncNbORdwU0buakm7Mx2rbE",
                              // "https://maps.googleapis.com/maps/api/staticmap?center=${controller.latitude},%20${controller.longitude}&zoom=16&size=400x400&markers=color:0x33D49D|${controller.latitude},${controller.longitude}&key=AIzaSyCSacvsau8vEncNbORdwU0buakm7Mx2rbE",
                              "https://maps.googleapis.com/maps/api/staticmap?center=${controller.latitude},%20${controller.longitude}&zoom=17&size=400x400&markers=color:0x33D49D|${controller.latitude},${controller.longitude}&key=AIzaSyCSacvsau8vEncNbORdwU0buakm7Mx2rbE&maptype=hybrid",
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.cover),
                            ),
                          ),
                          height: 200.0,
                          progressIndicatorBuilder: (context, url, progress) =>
                              Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color?>(
                                  Colors.indigo[900]),
                              value: progress.progress,
                            ),
                          ),
                          errorWidget: (context, url, error) => Image.asset(
                            'assets/brooky_logo.png',
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                        onTap: () async {
                          final hasCoordinates = controller.latitude != null &&
                              controller.longitude != null;
                          CameraPosition? initialCamPos = hasCoordinates
                              ? CameraPosition(
                                  target: LatLng(controller.latitude!,
                                      controller.longitude!),
                                  tilt: 25.0,
                                  zoom: 19.151926040649414)
                              : null;
                          LatLng? mapCoordinates = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (buildContext) => MapLocationPicker(
                                        initialCameraPosition: initialCamPos,
                                      )));
                          // setting propertyCoordinates after picking in google map

                          print("mapCoordinates $mapCoordinates");
                          if (mapCoordinates != null) {
                            controller.latitude = mapCoordinates.latitude;
                            controller.longitude = mapCoordinates.longitude;

                            controller.propertyCoordinates = {
                              'Latitude': mapCoordinates.latitude,
                              'Longitude': mapCoordinates.longitude
                            };
                            setState(() {});
                          }
                        },
                      ),
                    )
                  : Container(),
              SizedBox(height: 12.0),
              AppConstant.customTitleFieldWithSwith(
                title: 'Province',
                optionalText: 'required',
                optionalTextColor: Colors.red,
                switchValue: controller.showProvince,
                switchHandler: (val) {
                  setState(() {
                    controller.showProvince = val;
                  });
                },
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: CustomDropdownSearch(
                  items: controller.sortedProvinceNames,
                  isEnabled: controller.provinces.isNotEmpty,
                  hintText: 'Select Province',
                  selctedItem: controller.selectedProvinceName,
                  onChangeEvent: (String? value) async {
                    print('Selected: $value');

                    setState(() {
                      controller.setSelectedProvinceCode(provinceName: value);
                      controller.setSelectedProvinceName(
                          provinceCode: controller.selectedProvinceCode);

                      controller.cities = [];
                      controller.selectedCityName = null;
                      controller.selectedCityCode = null;
                      controller.barangays = [];
                      controller.selectedBarangayName = null;
                      controller.selectedBarangayCode = null;
                      print('City lenght: ${controller.cities.length}');
                    });
                    print(controller.cities.length);
                    setState(() {});
                    if (controller.cities.length == 0) {
                      await controller
                          .getCities(controller.selectedProvinceCode);
                      print('City lenght: ${controller.cities.length}');
                    }
                  },
                ),
              ),
              SizedBox(height: 12.0),
              AppConstant.customTitleFieldWithSwith(
                title: 'City/Municipality',
                optionalText: 'required',
                optionalTextColor: Colors.red,
                switchValue: controller.showCity,
                switchHandler: (val) {
                  setState(() {
                    controller.showCity = val;
                  });
                },
              ),
              controller.cities.isEmpty
                  ? Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: CustomDropdownSearch(
                          hintText: 'Select City',
                          isEnabled: false,
                          items: [],
                          onChangeEvent: (String? value) {}))
                  : Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: CustomDropdownSearch(
                        items: controller.cityNames,
                        isEnabled: controller.cities.isNotEmpty,
                        hintText: 'Select City',
                        selctedItem: controller.selectedCityName,
                        onChangeEvent: (String? value) async {
                          setState(() {
                            controller.setSelectedCityCode(cityName: value);
                            controller.setSelectedCityName(
                                cityCode: controller.selectedCityCode);
                            controller.barangays = [];
                            controller.selectedBarangayCode = null;
                            controller.selectedBarangayName = null;
                            print(
                                'Brgy lenght: ${controller.barangays.length}');
                          });
                          if (controller.barangays.length == 0) {
                            await controller
                                .getBarangays(controller.selectedCityCode);
                            print(
                                'Brgy lenght: ${controller.barangays.length}');
                          }
                        },
                      ),
                    ),
              SizedBox(height: 12.0),
              AppConstant.customTitleFieldWithSwith(
                title: 'Barangay',
                optionalText: 'required',
                optionalTextColor: Colors.red,
                switchValue: controller.showBarangay,
                switchHandler: (val) {
                  setState(() {
                    controller.showBarangay = val;
                  });
                },
              ),
              controller.barangays.isEmpty
                  ? Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: CustomDropdownSearch(
                          hintText: 'Select Barangay',
                          isEnabled: false,
                          items: [],
                          onChangeEvent: (String? value) {}))
                  : Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: CustomDropdownSearch(
                        items: controller.brgyNames,
                        isEnabled: controller.barangays.isNotEmpty,
                        hintText: 'Select Barangay',
                        selctedItem: controller.selectedBarangayName,
                        onChangeEvent: (String? value) async {
                          setState(() {
                            controller.setSelectedBarangayCode(
                                barangayName: value);
                            controller.setSelectedBarangayName(
                                barangayCode: controller.selectedBarangayCode);
                          });
                        },
                      ),
                    ),
              controller.propertyType == 'Condo'
                  ? Container()
                  : AppConstant.customTitleFieldWithSwith(
                      title: 'Subdivision',
                      optionalText: 'optional',
                      switchValue: controller.showSubdivision,
                      switchHandler: (val) {
                        setState(() {
                          controller.showSubdivision = val;
                        });
                      },
                    ),
              controller.propertyType == 'Condo'
                  ? Container()
                  : Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: CustomTextField(
                        controller: controller.subdivisionTextController,
                        hintText: 'Subdivision',
                      ),
                    ),
              AppConstant.customTitleFieldWithSwith(
                title: 'Street Name',
                optionalText: 'optional',
                switchHandler: (val) {
                  setState(() {
                    controller.showStreet = val;
                  });
                },
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: CustomTextField(
                  controller: controller.streetNameTextController,
                  hintText: 'Street Name',
                ),
              ),
              controller.propertyType == 'Condo' ||
                      controller.propertyType == 'Commercial Building' ||
                      controller.propertyType == 'Farm Lot' ||
                      controller.propertyType == 'Beach'
                  ? Container()
                  : AppConstant.customTitleFieldWithSwith(
                      title: 'Lot/Block/Phase/House Number',
                      optionalText: 'optional',
                      switchValue: controller.showHouseNumber,
                      switchHandler: (val) {
                        setState(() {
                          controller.showHouseNumber = val;
                        });
                      },
                    ),
              controller.propertyType == 'Condo' ||
                      controller.propertyType == 'Commercial Building' ||
                      controller.propertyType == 'Farm Lot' ||
                      controller.propertyType == 'Beach'
                  ? Container()
                  : Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: CustomTextField(
                        controller: controller.houseNumberTextController,
                        hintText: 'Lot/Block/Phase/House Number',
                      ),
                    ),
              controller.propertyType == 'Condo' ||
                      controller.propertyType == 'Warehouse'
                  ? AppConstant.customTitleFieldWithSwith(
                      title: controller.propertyType == 'Warehouse'
                          ? 'Building/Compound Name'
                          : 'Building Name',
                      optionalText: 'optional',
                      switchValue: controller.showBuildingName,
                      switchHandler: (val) {
                        setState(() {
                          controller.showBuildingName = val;
                        });
                      },
                    )
                  : Container(),
              controller.propertyType == 'Condo' ||
                      controller.propertyType == 'Warehouse'
                  ? Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: CustomTextField(
                        controller: controller.buildingNameTextController,
                        hintText: 'Building Name',
                      ),
                    )
                  : Container(),
              controller.propertyType != 'Condo'
                  ? Container()
                  : AppConstant.customTitleFieldWithSwith(
                      title: 'Unit/Room No./Floor',
                      optionalText: 'optional',
                      switchValue: controller.showFloorNumber,
                      switchHandler: (val) {
                        setState(() {
                          controller.showFloorNumber = val;
                        });
                      },
                    ),
              controller.propertyType != 'Condo'
                  ? Container()
                  : Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: CustomTextField(
                        controller: controller.floorTextController,
                        hintText: 'Unit/Room No./Floor',
                      ),
                    ),
              SizedBox(
                height: 80.0,
              )

              // AppConstant.customTitleField(title: 'Street Address'),
              // Container(
              //   padding: EdgeInsets.symmetric(horizontal: 20),
              //   child: CustomTextField(
              //     controller: controller.streetTextController,
              //     hintText: 'Street Address',
              //   ),
              // ),
              // AppConstant.customTitleField(title: 'Landmark'),
              // Container(
              //   padding: EdgeInsets.symmetric(horizontal: 20),
              //   child: CustomTextField(
              //     controller: controller.landmarkTextController,
              //     hintText: 'Landmark',
              //   ),
              // ),
              // AppConstant.customTitleField(title: 'City'),
              // Container(
              //   padding: EdgeInsets.symmetric(horizontal: 20),
              //   child: CustomTextField(
              //     controller: controller.cityTextController,
              //     hintText: 'City',
              //   ),
              // ),
            ],
          ),
          //page 4
          ListView(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.only(bottom: 20, top: 20),
            children: [
              AmenitiesField(
                hintText: 'Add Amenity',
                onChanged: (values) {
                  print('add amenities $values');
                  // controller.amenities = values;
                },
                onPressed: (String? value) {
                  if (value != null && value.isNotEmpty)
                    controller.updateAmenitiesSelection(amenities: [value]);
                },
                defaultSelected: controller.amenities,
              ),
              AmenitiesCheckBoxGroup(
                buttonLables: controller.amenitiesSelection,
                buttonValuesList: controller.amenitiesSelection,
                defaultSelected: controller.amenities,
                checkBoxButtonValues: (values) {
                  controller.amenities = values;
                  print(values);
                },
              ),
              // SizedBox(height: 20.0),
              // Container(
              //   padding: EdgeInsets.symmetric(horizontal: 20),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       CustomIconButton(
              //         alignment: null,
              //         main: false,
              //         onPressed: () {
              //           FocusScope.of(context).unfocus();

              //           _pageController.previousPage(
              //               duration: Duration(milliseconds: 500),
              //               curve: Curves.ease);
              //         },
              //       ),
              //       CustomIconButton(
              //         alignment: null,
              //         onPressed: () {
              //           FocusScope.of(context).unfocus();

              //           if (controller.validatePage4()) {
              //             // if (widget.property != null &&
              //             //     widget.property!.id != null) {
              //             //   controller.updateListing();
              //             // } else
              //             _pageController.nextPage(
              //                 duration: Duration(milliseconds: 500),
              //                 curve: Curves.ease);
              //           }
              //         },
              //       )
              //     ],
              //   ),
              // )
            ],
          ),
          // page 5
          ListView(
            padding: EdgeInsets.symmetric(vertical: 20),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(51, 212, 157, 0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.all(20.0),
                  child: CustomText(
                    text:
                        'You can only upload up to 10 photos. The first photo that you will select will be the cover photo of the listing.',
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
              SizedBox(height: 20),
              widget.property != null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CarouselSlider(
                            items: imageSliders,
                            carouselController: _carouselController,
                            options: CarouselOptions(
                                autoPlay: false,
                                enableInfiniteScroll: false,
                                viewportFraction: 1,
                                aspectRatio: 2.0,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    _currentImage = index;
                                  });
                                }),
                          ),
                          //======================================= image paging
                          Positioned(
                            bottom: 5,
                            right: 10,
                            child: Container(
                              padding: EdgeInsets.all(7),
                              decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                  color: Colors.black.withOpacity(.6)),
                              child: Center(
                                child: Text(
                                  '$photoCounter/$totalPhoto',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          //======================================= Delete img
                          Positioned(
                              top: 5,
                              right: 10,
                              child: CircleAvatar(
                                backgroundColor: Colors.grey[200],
                                radius: 18,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: App.textColor,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    print(_currentImage);
                                    AppConstant.deleteDialog(
                                        context: context,
                                        title: 'Confim',
                                        text:
                                            'Are you sure you want to delete this photo?',
                                        onConfirm: () {
                                          setState(() {
                                            _currentPhotos
                                                .removeAt(_currentImage);
                                            controller.currentPhotosCount =
                                                _currentPhotos.length;
                                            Navigator.pop(context);
                                          });
                                        });

                                    print(
                                        'LENGTH of photos:${controller.currentPhotosCount}');
                                  },
                                ),
                              )),
                          //======================================= Img indicator
                          Positioned(
                            bottom: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:
                                  widget.property!.photos!.asMap().entries.map(
                                (entry) {
                                  return GestureDetector(
                                    onTap: () => _carouselController
                                        .animateToPage(entry.key),
                                    child: Container(
                                      width: _currentImage == entry.key
                                          ? 10.0
                                          : 5.0,
                                      height: _currentImage == entry.key
                                          ? 10.0
                                          : 5.0,
                                      margin: EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 4.0),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                      ),
                                    ),
                                  );
                                },
                              ).toList(),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(),
              CustomUploadField(
                text: widget.property == null
                    ? 'Upload Image'
                    : 'Add more Images',
                maxImages: widget.property == null
                    ? null
                    : (10 - _currentPhotos.length),
                onAssetValue: (result) {
                  controller.assets = result;
                },
                defaultSelected: controller.assets,
              ),
              // SizedBox(height: 20.0),
              // Container(
              //   padding: EdgeInsets.symmetric(horizontal: 20),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       CustomIconButton(
              //         alignment: null,
              //         main: false,
              //         onPressed: () {
              //           FocusScope.of(context).unfocus();

              //           _pageController.previousPage(
              //               duration: Duration(milliseconds: 500),
              //               curve: Curves.ease);
              //         },
              //       ),
              //       CustomIconButton(
              //         alignment: null,
              //         onPressed: () async {
              //           FocusScope.of(context).unfocus();

              //           if (await controller.validatePage5()) {
              //             if (widget.property == null) {
              //               controller.createListing();
              //             } else {
              //               controller.currentPhotos =
              //                   _currentPhotos.cast<String>();
              //               controller.updateListing();
              //             }
              //           }
              //         },
              //       )
              //     ],
              //   ),
              // )
            ],
          )
        ];

        // total pages
        totalPage = createListingList.length;
        String nextButtonLabel = '';
        if (widget.property == null) {
          nextButtonLabel = this.currentPage != 5 ? 'Next' : 'Create Listing';
        } else {
          nextButtonLabel = this.currentPage != 5 ? 'Next' : 'Save Changes';
        }

        return Stack(children: [
          PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: _pageController,
              onPageChanged: (i) {
                setState(() {
                  currentPage = i + 1;
                });

                if (i == 0 || i == 1) {
                  setState(() {
                    appBarTitle =
                        (widget.property != null && widget.property!.id != null)
                            ? "Update Listing"
                            : 'Create Listing';
                  });
                } else if (i == 2) {
                  setState(() {
                    appBarTitle =
                        (widget.property != null && widget.property!.id != null)
                            ? "Update Location"
                            : 'Location';
                  });
                } else if (i == 3) {
                  setState(() {
                    appBarTitle =
                        (widget.property != null && widget.property!.id != null)
                            ? "Update Amenities"
                            : 'Amenities';
                  });
                } else if (i == 4) {
                  setState(() {
                    appBarTitle =
                        (widget.property != null && widget.property!.id != null)
                            ? "Update Photos"
                            : 'Photos';
                  });
                }
              },
              children: createListingList),
          Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Divider(
                    height: 1,
                    thickness: 1,
                  ),
                  Container(
                    color: Colors.white,
                    constraints: BoxConstraints(
                        maxHeight: 200,
                        maxWidth: MediaQuery.of(context).size.width),
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                            child: CustomButtonReverse(
                              text: 'Previous',
                              height: 50,
                              onPressed: () async {
                                FocusScope.of(context).unfocus();

                                _pageController.previousPage(
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.ease);
                              },
                              backgroudColor: Colors.white,
                              textColor: App.mainColor,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Container(
                            child: CustomButton(
                              text: nextButtonLabel,
                              height: 50,
                              onPressed: () async {
                                var stepNumber = controller
                                        .createListingPageController.page!
                                        .toInt() +
                                    1;
                                print('PRINTING CURRENT PAGE: $stepNumber');

                                if (stepNumber == 1) {
                                  FocusScope.of(context).unfocus();
                                  if (controller.validatePage1()) {
                                    _pageController.nextPage(
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.ease);
                                  }
                                } else if (stepNumber == 2) {
                                  FocusScope.of(context).unfocus();
                                  if (controller.validatePage2()) {
                                    _pageController.nextPage(
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.ease);
                                    // if (widget.property != null) {
                                    //   print('------------------------------');
                                    //   if (controller.brgyNames?.length == 0) {
                                    //     print(
                                    //         '------------------------------>');
                                    //     //Todo: use progress bar
                                    //     AppConstant.showToast(
                                    //         msg:
                                    //             "Getting locaton details please wait...",
                                    //         timeInSecForIosWeb: 3);
                                    //     AppConstant.showLoader(context, true);
                                    //   }
                                    // }
                                  }
                                } else if (stepNumber == 3) {
                                  FocusScope.of(context).unfocus();
                                  if (controller.validatePage3()) {
                                    _pageController.nextPage(
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.ease);
                                  }
                                } else if (stepNumber == 4) {
                                  FocusScope.of(context).unfocus();
                                  if (controller.validatePage4()) {
                                    _pageController.nextPage(
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.ease);
                                  }
                                } else if (stepNumber == 5) {
                                  FocusScope.of(context).unfocus();
                                  if (await controller.validatePage5()) {
                                    if (widget.property == null) {
                                      // // *** Mixpanel Tracking [start]
                                      // controller.mixpanelSendData();
                                      // // *** Mixpanel Tracking [end]
                                      controller.createListing();
                                    } else {
                                      controller.currentPhotos =
                                          _currentPhotos.cast<String>();
                                      controller.updateListing();
                                    }
                                  }
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ))
        ]);
      }),
      bottomNavigationBar: true
          ? null
          : ControlledWidgetBuilder<CreateListingController>(
              builder: (context, controller) {
              var _pageController = controller.createListingPageController;
              String nextButtonLabel = '';
              if (widget.property == null) {
                nextButtonLabel =
                    this.currentPage != 5 ? 'Next' : 'Create Listing';
              } else {
                nextButtonLabel =
                    this.currentPage != 5 ? 'Next' : 'Save Changes';
              }
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Divider(
                    height: 1,
                    thickness: 1,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                            child: CustomButtonReverse(
                              text: 'Previous',
                              height: 50,
                              onPressed: () async {
                                FocusScope.of(context).unfocus();

                                _pageController.previousPage(
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.ease);
                              },
                              backgroudColor: Colors.white,
                              textColor: App.mainColor,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Container(
                            child: CustomButton(
                              text: nextButtonLabel,
                              height: 50,
                              onPressed: () async {
                                var stepNumber = controller
                                        .createListingPageController.page!
                                        .toInt() +
                                    1;
                                print('PRINTING CURRENT PAGE: $stepNumber');

                                if (stepNumber == 1) {
                                  FocusScope.of(context).unfocus();
                                  if (controller.validatePage1()) {
                                    _pageController.nextPage(
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.ease);
                                  }
                                } else if (stepNumber == 2) {
                                  FocusScope.of(context).unfocus();
                                  if (controller.validatePage2()) {
                                    _pageController.nextPage(
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.ease);
                                  }
                                } else if (stepNumber == 3) {
                                  FocusScope.of(context).unfocus();
                                  if (controller.validatePage3()) {
                                    _pageController.nextPage(
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.ease);
                                  }
                                } else if (stepNumber == 4) {
                                  FocusScope.of(context).unfocus();
                                  if (controller.validatePage4()) {
                                    _pageController.nextPage(
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.ease);
                                  }
                                } else if (stepNumber == 5) {
                                  FocusScope.of(context).unfocus();
                                  if (await controller.validatePage5()) {
                                    if (widget.property == null) {
                                      // // *** Mixpanel Tracking [start]
                                      // controller.mixpanelSendData();
                                      // // *** Mixpanel Tracking [end]
                                      controller.createListing();
                                    } else {
                                      controller.currentPhotos =
                                          _currentPhotos.cast<String>();
                                      controller.updateListing();
                                    }
                                  }
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
    );
  }
}
