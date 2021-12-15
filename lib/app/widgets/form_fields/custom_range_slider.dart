import 'package:dazle/app/utils/app.dart';
import 'package:dazle/app/widgets/custom_text.dart';
import 'package:dazle/app/widgets/form_fields/custom_field_layout.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class CustomRangeSlider extends StatefulWidget {
  final ValueChanged<RangeValues> onChange;

  const CustomRangeSlider({ 
    Key key,
    @required this.onChange
  }) : super(key: key);

  @override
  _CustomRangeSliderState createState() => _CustomRangeSliderState();
}

class _CustomRangeSliderState extends State<CustomRangeSlider> {
  var selectedRangeValues = RangeValues(100000, 700000);
  var numberFormat = NumberFormat("###,###");

  @override
  Widget build(BuildContext context) {
    return CustomFieldLayout(
      child: Column(
        children: [
          Container(
            height: 50,
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              border: Border.all(
                color: App.hintColor
              )
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomText(
                  text: 'PHP ${numberFormat.format(selectedRangeValues.start)}',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    VerticalDivider(
                      color: App.hintColor,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: App.hintColor
                        ),
                        shape: BoxShape.circle,
                        color: Colors.white
                      ),
                      width: 25,
                      height: 25,
                      alignment: Alignment.center,
                      child: CustomText(
                        text: 'TO',
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      )
                    )
                  ],
                ),
                CustomText(
                  text: 'PHP ${numberFormat.format(selectedRangeValues.end)}',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ),
          RangeSlider(
            values: selectedRangeValues,
            activeColor: App.mainColor,
            inactiveColor: Color.fromRGBO(229, 229, 229, 1.0),
            divisions: 100,
            max: 1000000,
            onChanged: (RangeValues values) {
              widget.onChange(values);

              setState(() {
                selectedRangeValues = values;
              });
            }
          ),
        ],
      )
    );
  }
}