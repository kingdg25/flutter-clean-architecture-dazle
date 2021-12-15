import 'package:dazle/app/pages/create_listing/create_listing_controller.dart';
import 'package:dazle/app/utils/app_constant.dart';
import 'package:dazle/app/widgets/custom_appbar.dart';
import 'package:dazle/app/widgets/form_fields/amenities_field.dart';
import 'package:dazle/app/widgets/form_fields/custom_check_box_group_button.dart';
import 'package:dazle/app/widgets/form_fields/custom_icon_button.dart';
import 'package:dazle/app/widgets/form_fields/custom_radio_group_button.dart';
import 'package:dazle/app/widgets/form_fields/custom_text_field.dart';
import 'package:dazle/app/widgets/form_fields/keywords_field.dart';
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

  @override
  Widget get view {
    return Scaffold(
      key: globalKey,
      appBar: CustomAppBar(
        title: appBarTitle,
      ),
      backgroundColor: Colors.white,
      body: ControlledWidgetBuilder<CreateListingController>(
        builder: (context, controller) {
          var _pageController = controller.createListingPageController;

          var page1 = ListView(
            padding: EdgeInsets.only(bottom: 20),
            children: [
              AppConstant.customTitleField(
                padding: EdgeInsets.only(left: 18),
                title: 'Property Type'
              ),
              CustomCheckBoxGroupButton(
                checkBoxWidth: 120,
                buttonValuesList: [
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
                checkBoxButtonValues: (values) {
                  print(values);
                }
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
                radioButtonValues: (values) {
                  print(values);
                }
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
                radioButtonValues: (value) {
                  print(value);
                },
              ),
              AppConstant.customTitleField(
                title: 'Price'
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: CustomTextField(
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

                    _pageController.nextPage(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.ease
                    );
                  },
                ),
              )
            ],
          );

          var page2 = ListView(
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
                radioButtonValues: (values) {
                  print(values);
                }
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
                radioButtonValues: (values) {
                  print(values);
                }
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
                radioButtonValues: (values) {
                  print(values);
                }
              ),
              AppConstant.customTitleField(
                title: 'Area'
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: CustomTextField(
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
                radioButtonValues: (values) {
                  print(values);
                }
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

                        _pageController.nextPage(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.ease
                        );
                      },
                    )
                  ],
                ),
              )
            ],
          );

          var page3 = ListView(
            padding: EdgeInsets.only(bottom: 20),
            children: [
              AppConstant.customTitleField(
                title: 'Street Address'
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: CustomTextField(
                  hintText: 'Street Address',
                ),
              ),
              AppConstant.customTitleField(
                title: 'Landmark'
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: CustomTextField(
                  hintText: 'Landmark',
                ),
              ),
              AppConstant.customTitleField(
                title: 'City'
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: CustomTextField(
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

                        _pageController.nextPage(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.ease
                        );
                      },
                    )
                  ],
                ),
              )
            ],
          );

          var page4 = ListView(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.only(bottom: 20, top: 20),
            children: [
              AmenitiesField(
                hintText: 'Add Amenity',
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

                        _pageController.nextPage(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.ease
                        );
                      },
                    )
                  ],
                ),
              )
            ],
          );

          var page5 = ListView(
            padding: EdgeInsets.only(bottom: 20),
            children: [
              KeywordsField(
                hintText: 'asd',
              ),
              SizedBox(height: 20.0),
              Row(
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

                      _pageController.nextPage(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.ease
                      );
                    },
                  )
                ],
              )
            ],
          );

          return PageView(
            physics: NeverScrollableScrollPhysics(),
            controller: _pageController,
            onPageChanged: (i) {
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
            children: [
              page1,
              page2,
              page3,
              page4,
              page5
            ],
          );
        }
      )
    );
  }
}