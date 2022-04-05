import 'package:dazle/app/pages/filter/filter_controller.dart';
import 'package:dazle/app/utils/app.dart';
import 'package:dazle/app/utils/app_constant.dart';
import 'package:dazle/app/widgets/custom_appbar.dart';
import 'package:dazle/app/widgets/form_fields/custom_button.dart';
import 'package:dazle/app/widgets/form_fields/custom_check_box_group_button.dart';
import 'package:dazle/app/widgets/form_fields/custom_flat_button.dart';
import 'package:dazle/app/widgets/form_fields/custom_range_slider.dart';
import 'package:dazle/app/widgets/form_fields/custom_search_field.dart';
import 'package:dazle/app/widgets/form_fields/keywords_field.dart';
import 'package:dazle/data/repositories/data_home_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';



class FilterPage extends View {
  FilterPage({Key? key}) : super(key: key);

  @override
  _FilterPageState createState() => _FilterPageState();
}


class _FilterPageState extends ViewState<FilterPage, FilterController> {
  _FilterPageState() : super(FilterController(DataHomeRepository()));

  @override
  Widget get view {
    return Scaffold(
      key: globalKey,
      appBar: CustomAppBar(
        title: 'Filters',
        actions: [
          Container(
            padding: EdgeInsets.only(right: 10.0),
            child: CustomFlatButton(
              text: 'Clear All',
              color: App.mainColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              onPressed: () {}
            ),
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: ControlledWidgetBuilder<FilterController>(
        builder: (context, controller) {

          return ListView(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 20, bottom: 20),
            children: [
              CustomSearchField(
                borderRadius: 10,
                padding: EdgeInsets.only(bottom: 20, right: 20, left: 20),
                hintText: 'building, Neighboorhood, City',
                onChanged: (value) {
                  print('onChanged onChanged $value');
                },
                suggestionsCallback: (pattern) async {
                  print('suggestionsCallback $pattern');

                  return [];
                },
                onSuggestionSelected: (suggestion) {
                },
                onSubmitted: (value) {
                },
                onPressedButton: () {
                },
              ),
              CustomCheckBoxGroupButton(
                checkBoxPadding: 15,
                buttonLables: [
                  "Buy",
                  "Rent",
                ],
                buttonValuesList: [
                  "Buy",
                  "Rent",
                ],
                checkBoxButtonValues: (values) {
                  print(values);
                }
              ),
              AppConstant.customTitleField(
                title: 'Home Type'
              ),
              CustomCheckBoxGroupButton(
                checkBoxWidth: 120,
                buttonLables: [
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
                title: 'Price'
              ),
              CustomRangeSlider(
                onChange: (RangeValues values) {
                  print('onChange RangeValues $values');
                },
              ),
              AppConstant.customTitleField(
                padding: EdgeInsets.only(left: 18),
                title: 'Number of Bedrooms'
              ),
              CustomCheckBoxGroupButton(
                checkBoxWidth: 70,
                buttonLables: [
                  "Studio",
                  "1BR",
                  "2BR",
                  "3BR",
                  "4BR",
                  "5BR",
                ],
                buttonValuesList: [
                  "Studio",
                  "1BR",
                  "2BR",
                  "3BR",
                  "4BR",
                  "5BR",
                ],
                checkBoxButtonValues: (values) {
                  print(values);
                }
              ),
              AppConstant.customTitleField(
                title: 'Number of Bathrooms'
              ),
              CustomCheckBoxGroupButton(
                checkBoxWidth: 55,
                buttonLables: [
                  "1+",
                  "2+",
                  "3+",
                  "4+",
                  "5+",
                ],
                buttonValuesList: [
                  "1+",
                  "2+",
                  "3+",
                  "4+",
                  "5+",
                ],
                checkBoxButtonValues: (values) {
                  print(values);
                }
              ),
              AppConstant.customTitleField(
                title: 'Keywords'
              ),
              KeywordsField(
                hintText: 'Enter relevant keywords',
                onChanged: (values) {
                  print('keyword on change $values');
                },
              ),
              SizedBox(height: 30),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: CustomButton(
                  text: 'Apply',
                  expanded: true,
                  onPressed: () {
                  }
                ),
              )
            ]
          );
        
        }
      )
    );
  }
}