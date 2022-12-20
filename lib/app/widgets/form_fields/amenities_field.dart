import 'package:dazle/app/utils/app.dart';
// import 'package:dazle/app/widgets/custom_text.dart';
import 'package:dazle/app/widgets/form_fields/custom_field_layout.dart';
import 'package:dazle/domain/entities/amenity.dart';
import 'package:flutter/material.dart';

class AmenitiesField<T> extends StatefulWidget {
  final String? hintText;
  final Color hintColor;
  final double fontSize;
  final ValueChanged onChanged;
  final Function onPressed;

  ///Default Selected button
  final T defaultSelected;

  const AmenitiesField(
      {Key? key,
      this.hintText,
      this.hintColor = App.hintColor,
      this.fontSize = 16.0,
      required this.onChanged,
      required this.defaultSelected,
      required this.onPressed})
      : super(key: key);

  @override
  _AmenitiesFieldState createState() => _AmenitiesFieldState();
}

class _AmenitiesFieldState extends State<AmenitiesField> {
  List<dynamic> selectedLables = [];

  final TextEditingController amenityTextController = TextEditingController();
  List<Amenity> amenities = [
    Amenity(text: "Kitchen"),
    Amenity(text: "Wifi"),
    Amenity(text: "Eco Friendly"),
    Amenity(text: "Sharing Gym"),
    Amenity(text: "Sharing Pool"),
    Amenity(text: "Security"),
    Amenity(text: "Covered Parking"),
    Amenity(text: "Central A.C."),
    Amenity(text: "Balcony"),
    Amenity(text: "Tile Flooring"),
  ];

  addAmenity(value) {
    if (value.isNotEmpty) {
      setState(() {
        amenities.add(Amenity(text: value, added: true));
      });

      amenityTextController.clear();

      amenitiesOnChanged();
    }
  }

  amenitiesOnChanged() {
    // filter amenities, get only where added is true
    selectedLables =
        amenities.where((amenity) => amenity.added == true).toList();

    widget.onChanged(selectedLables);
  }

  @override
  void initState() {
    super.initState();
    widget.defaultSelected?.where((e) {
      return amenities.contains(e);
    })?.forEach((e) {
      selectedLables.add(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomFieldLayout(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
              controller: amenityTextController,
              onFieldSubmitted: (value) {
                addAmenity(amenityTextController.text);
              },
              keyboardType: TextInputType.text,
              style: TextStyle(
                  decorationStyle: TextDecorationStyle.dotted,
                  color: App.fieldTextColor,
                  fontFamily: "Poppins",
                  fontSize: widget.fontSize),
              decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.all(14.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: widget.hintColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: widget.hintColor),
                  ),
                  hintText: widget.hintText,
                  hintStyle: TextStyle(
                      color: widget.hintColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                  suffixIcon: IconButton(
                      icon: Icon(
                        Icons.library_add,
                        color: widget.hintColor,
                      ),
                      onPressed: () {
                        widget.onPressed(amenityTextController.text);
                      })),
            ),
          ),
          // true ? Container() : Container(
          //   margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          //   alignment: Alignment.centerLeft,
          //   child: Wrap(
          //     runSpacing: 8,
          //     spacing: 10,
          //     direction: Axis.horizontal,

          //     children: List.generate(amenities.length, (index) {

          //       return InkWell(
          //         onTap: () {
          //           setState(() {
          //             amenities[index].added =  ! amenities[index].added! ;
          //           });

          //           amenitiesOnChanged();
          //         },
          //         child: Container(
          //           padding: EdgeInsets.symmetric(vertical: 10),
          //           decoration: BoxDecoration(
          //             border: Border(
          //               bottom: BorderSide(
          //                 color: App.hintColor
          //               )
          //             ),
          //           ),
          //           child: Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //             children: [
          //               CustomText(
          //                 text: amenities[index].text,
          //                 fontSize: 13,
          //                 fontWeight: FontWeight.w600,
          //               ),
          //               Icon(
          //                 amenities[index].added! ? Icons.check_circle : Icons.add_circle_outline_rounded,
          //                 color: amenities[index].added! ? App.mainColor : App.hintColor,
          //               )
          //             ],
          //           )
          //         )
          //       );

          //     }),
          //   ),
          // )
        ],
      ),
    );
  }
}
