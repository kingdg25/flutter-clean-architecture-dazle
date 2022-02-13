// import 'package:custom_radio_grouped_button/CustomButtons/CustomListViewSpacing.dart';
import 'package:dazle/app/utils/app.dart';
import 'package:dazle/app/widgets/custom_text.dart';
import 'package:flutter/material.dart';


// ignore: must_be_immutable
class AmenitiesCheckBoxGroup<T> extends StatefulWidget {
  const AmenitiesCheckBoxGroup({
    Key? key,
    this.hintText,
    this.hintColor = App.hintColor,
    this.fontSize = 16.0,
    this.height = 35,
    this.padding = 3,
    this.spacing = 0.0,
    this.defaultSelected,
    this.buttonValuesList,
    this.buttonLables,
    this.checkBoxButtonValues,
  }) : super(key: key);

  final String? hintText;
  final Color hintColor;
  final double fontSize;

  ///Default value is 35
  final double height;
  final double padding;

  ///Default Selected button
  final T? defaultSelected;

  ///Spacing between buttons
  final double spacing;

  ///Values of button
  final List<T>? buttonValuesList;

  final List<String>? buttonLables;

  final void Function(List<T>)? checkBoxButtonValues;

  @override
  _AmenitiesCheckBoxGroupState createState() => _AmenitiesCheckBoxGroupState();
}

class _AmenitiesCheckBoxGroupState extends State<AmenitiesCheckBoxGroup> {
  List<dynamic> selectedLables = [];
  final TextEditingController amenityTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.defaultSelected?.where((e) {
      return widget.buttonValuesList!.contains(e);
    })?.forEach((e) {
      selectedLables.add(e);
    });
  }

  List<Widget> _buildButtonsColumn() {
    return widget.buttonValuesList!.map((e) {
      int index = widget.buttonValuesList!.indexOf(e);
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: InkWell(
          onTap: () {
            if (selectedLables.contains(e)) {
              selectedLables.remove(e);
            } else {
              selectedLables.add(e);
            }
            setState(() {});
            widget.checkBoxButtonValues!(selectedLables);
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: App.hintColor
                )
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: widget.buttonLables![index],
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
                Icon(
                  selectedLables.contains(e) ? Icons.check_circle : Icons.add_circle_outline_rounded,
                  color: selectedLables.contains(e) ? App.mainColor : App.hintColor,
                )
              ],
            )
          )
        )
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height * (widget.buttonLables!.length * 1.5) +
          widget.padding * 2 * widget.buttonLables!.length,
      child: Center(
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          children: _buildButtonsColumn()
            .map((c) => Container(
                  padding: EdgeInsets.all(widget.spacing),
                  child: c,
                ))
            .toList(),
        ),
      ),
    );
  }
}