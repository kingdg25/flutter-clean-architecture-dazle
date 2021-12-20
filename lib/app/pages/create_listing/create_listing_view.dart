import 'package:dazle/app/pages/create_listing/create_listing_controller.dart';
import 'package:dazle/app/utils/app.dart';
import 'package:dazle/app/utils/app_constant.dart';
import 'package:dazle/app/widgets/custom_appbar.dart';
import 'package:dazle/app/widgets/form_fields/amenities_check_box_group.dart';
import 'package:dazle/app/widgets/form_fields/custom_icon_button.dart';
import 'package:dazle/app/widgets/form_fields/custom_radio_group_button.dart';
import 'package:dazle/app/widgets/form_fields/custom_text_field.dart';
import 'package:dazle/app/widgets/form_fields/custom_upload_field.dart';
import 'package:dazle/data/repositories/data_listing_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';



class CreateListingPage extends View {
  CreateListingPage({Key key}) : super(key: key);

  @override
  _CreateListingPageState createState() => _CreateListingPageState();
}


class _CreateListingPageState extends ViewState<CreateListingPage, CreateListingController> {
  _CreateListingPageState() : super(CreateListingController(DataListingRepository()));
  String appBarTitle = 'Create Listing';
  List<Widget> createListingList = [];
  int currentPage = 1;
  int totalPage = 0;

  @override
  Widget get view {
    return Scaffold(
      key: globalKey,
      appBar: CustomAppBar(
        title: appBarTitle,
        actions: [
          ControlledWidgetBuilder<CreateListingController>(
            builder: (context, controller) {
              return Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(right: 10.0),
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Step $currentPage "
                      ),
                      TextSpan(
                        text: "of $totalPage",
                        style: App.textStyle(
                          fontSize: 12,
                          color: App.hintColor,
                          fontWeight: FontWeight.w600
                        )
                      ),
                    ]
                  ),
                  style: App.textStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600
                  )
                ),
              );
            }
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: ControlledWidgetBuilder<CreateListingController>(
        builder: (context, controller) {
          var _pageController = controller.createListingPageController;

          createListingList = [
            // page 1
            ListView(
              padding: EdgeInsets.only(bottom: 20),
              children: [
                AppConstant.customTitleField(
                  padding: EdgeInsets.only(left: 18),
                  title: 'Property Type'
                ),
                CustomRadioGroupButton(
                  radioWidth: 120,
                  radioList: [
                    "Apartment",
                    "Villa",
                    "Townhouse",
                    "Commercial",
                    "Warehouse",
                    "Lot",
                    "Farm Lot",
                    "Residential House",
                    "Beach",
                  ],
                  radioButtonValue: (value) {
                    controller.propertyType = value;
                  },
                  defaultSelected: controller.propertyType,
                ),
                AppConstant.customTitleField(
                  title: 'Property For'
                ),
                CustomRadioGroupButton(
                  radioPadding: 15,
                  radioList: [
                    "Sell",
                    "Rent",
                  ],
                  radioButtonValue: (value) {
                    controller.propertyFor = value;
                  },
                  defaultSelected: controller.propertyFor,
                ),
                AppConstant.customTitleField(
                  title: 'Time Period'
                ),
                CustomRadioGroupButton(
                  radioPadding: 15,
                  radioList: [
                    "Yearly",
                    "Monthly"
                  ],
                  radioButtonValue: (value) {
                    controller.timePeriod = value;
                  },
                  defaultSelected: controller.timePeriod,
                ),
                AppConstant.customTitleField(
                  title: 'Price'
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: CustomTextField(
                    controller: controller.priceTextController,
                    keyboardType: const TextInputType.numberWithOptions(),
                    hintText: 'Price (PHP)',
                  ),
                ),
                SizedBox(height: 20.0),
                Container(
                  padding: EdgeInsets.only(right: 20),
                  child: CustomIconButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();

                      if ( controller.validatePage1() ) {
                        _pageController.nextPage(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.ease
                        );
                      }
                    },
                  ),
                )
              ],
            ),
            // page 2
            ListView(
              padding: EdgeInsets.only(bottom: 20),
              children: [
                AppConstant.customTitleField(
                  padding: EdgeInsets.only(left: 18),
                  title: 'Number of Bedrooms'
                ),
                CustomRadioGroupButton(
                  radioWidth: 70,
                  radioList: [
                    "Any",
                    "Studio",
                    "1BR",
                    "2BR",
                    "3BR",
                  ],
                  radioButtonValue: (value) {
                    controller.numberOfBedRooms = value;
                  },
                  defaultSelected: controller.numberOfBedRooms,
                ),
                AppConstant.customTitleField(
                  title: 'Number of Bathrooms'
                ),
                CustomRadioGroupButton(
                  radioWidth: 55,
                  radioList: [
                    "1",
                    "2",
                    "3",
                    "4",
                    "5",
                    "6",
                    "7",
                    "8",
                    "9",
                    "10",
                  ],
                  radioButtonValue: (value) {
                    controller.numberOfBathRooms = value;
                  },
                  defaultSelected: controller.numberOfBathRooms,
                ),
                AppConstant.customTitleField(
                  title: 'Number of Parking'
                ),
                CustomRadioGroupButton(
                  radioWidth: 55,
                  radioList: [
                    "1",
                    "2",
                    "3",
                    "4",
                    "5",
                    "6",
                    "7",
                    "8",
                    "9",
                    "10",
                  ],
                  radioButtonValue: (value) {
                    controller.numberOfParking = value;
                  },
                  defaultSelected: controller.numberOfParking,
                ),
                AppConstant.customTitleField(
                  title: 'Area'
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: CustomTextField(
                    controller: controller.areaTextController,
                    keyboardType: const TextInputType.numberWithOptions(),
                    hintText: 'Area (sqft)',
                  ),
                ),
                AppConstant.customTitleField(
                  padding: EdgeInsets.only(left: 18),
                  title: 'Is your Property'
                ),
                CustomRadioGroupButton(
                  radioWidth: 120,
                  radioList: [
                    "Furnished",
                    "Unfurnished",
                  ],
                  radioButtonValue: (value) {
                    controller.isYourProperty = value;
                  },
                  defaultSelected: controller.isYourProperty,
                ),
                SizedBox(height: 20.0),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomIconButton(
                        alignment: null,
                        main: false,
                        onPressed: () {
                          FocusScope.of(context).unfocus();

                          _pageController.previousPage(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.ease
                          );
                        },
                      ),
                      CustomIconButton(
                        alignment: null,
                        onPressed: () {
                          FocusScope.of(context).unfocus();

                          if ( controller.validatePage2() ) {
                            _pageController.nextPage(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.ease
                            );
                          }
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
            // page 3
            ListView(
              padding: EdgeInsets.only(bottom: 20),
              children: [
                AppConstant.customTitleField(
                  title: 'Street Address'
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: CustomTextField(
                    controller: controller.streetTextController,
                    hintText: 'Street Address',
                  ),
                ),
                AppConstant.customTitleField(
                  title: 'Landmark'
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: CustomTextField(
                    controller: controller.landmarkTextController,
                    hintText: 'Landmark',
                  ),
                ),
                AppConstant.customTitleField(
                  title: 'City'
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: CustomTextField(
                    controller: controller.cityTextController,
                    hintText: 'City',
                  ),
                ),
                SizedBox(height: 20.0),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomIconButton(
                        alignment: null,
                        main: false,
                        onPressed: () {
                          FocusScope.of(context).unfocus();

                          _pageController.previousPage(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.ease
                          );
                        },
                      ),
                      CustomIconButton(
                        alignment: null,
                        onPressed: () {
                          FocusScope.of(context).unfocus();

                          if ( controller.validatePage3() ) {
                            _pageController.nextPage(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.ease
                            );
                          }
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
            //page 4
            ListView(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.only(bottom: 20, top: 20),
              children: [
                // AmenitiesField(
                //   hintText: 'Add Amenity',
                //   onChanged: (values) {
                //     print('add amenities $values');
                //     controller.amenities = values;
                //   },
                //   defaultSelected: controller.amenities,
                // ),
                AmenitiesCheckBoxGroup(
                  buttonLables: [
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
                  buttonValuesList: [
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
                  defaultSelected: controller.amenities,
                  checkBoxButtonValues: (values) {
                    controller.amenities = values;
                  } ,
                ),
                SizedBox(height: 20.0),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomIconButton(
                        alignment: null,
                        main: false,
                        onPressed: () {
                          FocusScope.of(context).unfocus();

                          _pageController.previousPage(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.ease
                          );
                        },
                      ),
                      CustomIconButton(
                        alignment: null,
                        onPressed: () {
                          FocusScope.of(context).unfocus();

                          if ( controller.validatePage4() ) {
                            _pageController.nextPage(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.ease
                            );
                          }
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
            // page 5
            ListView(
              padding: EdgeInsets.only(bottom: 20),
              children: [
                CustomUploadField(
                  text: 'Upload Image',
                  onAssetValue: (result) {
                    controller.assets = result;
                  },
                  defaultSelected: controller.assets,
                ),
                SizedBox(height: 20.0),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomIconButton(
                        alignment: null,
                        main: false,
                        onPressed: () {
                          FocusScope.of(context).unfocus();

                          _pageController.previousPage(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.ease
                          );
                        },
                      ),
                      CustomIconButton(
                        alignment: null,
                        onPressed: () {
                          FocusScope.of(context).unfocus();

                          if ( controller.validatePage5() ) {
                            _pageController.nextPage(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.ease
                            );
                          }
                        },
                      )
                    ],
                  ),
                )
              ],
            )
          ];

          // total pages
          totalPage = createListingList.length;

          return PageView(
            // physics: NeverScrollableScrollPhysics(),
            controller: _pageController,
            onPageChanged: (i) {
              setState(() {
                currentPage = i+1;
              });

              if ( i == 0 || i == 1 ) {
                setState(() {
                  appBarTitle = 'Create Listing';
                });
              }
              else if ( i == 2 ) {
                setState(() {
                  appBarTitle = 'Location';
                });
              }
              else if ( i == 3 ) {
                setState(() {
                  appBarTitle = 'Amenities';
                });
              }
              else if ( i == 4 ) {
                setState(() {
                  appBarTitle = 'Photos';
                });
              }
            },
            children: createListingList
          );
        }
      )
    );
  }
}