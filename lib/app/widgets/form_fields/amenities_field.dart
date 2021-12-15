import 'package:dazle/app/utils/app.dart';
import 'package:dazle/app/widgets/custom_text.dart';
import 'package:dazle/app/widgets/form_fields/custom_field_layout.dart';
import 'package:dazle/domain/entities/amenity.dart';
import 'package:flutter/material.dart';


class AmenitiesField extends StatefulWidget {
  final String hintText;
  final Color hintColor;
  final double fontSize;
  
  const AmenitiesField({
    Key key,
    this.hintText,
    this.hintColor = App.hintColor,
    this.fontSize = 16.0,
  }) : super(key: key);

  @override
  _AmenitiesFieldState createState() => _AmenitiesFieldState();
}

class _AmenitiesFieldState extends State<AmenitiesField> {
  final TextEditingController amenityTextController = TextEditingController();
  List<Amenity> amenities = [
    Amenity(text: "Kitchen", added: true),
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
                if ( amenityTextController.text.isNotEmpty ) {
                  setState(() {
                    amenities.add(
                      Amenity(text: amenityTextController.text, added: true)
                    );
                  });
                  
                  amenityTextController.clear();
                }
              },
              keyboardType: TextInputType.text,
              style: TextStyle(
                decorationStyle: TextDecorationStyle.dotted,
                color: App.fieldTextColor,
                fontFamily: "Poppins",
                fontSize: widget.fontSize
              ),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.all(14.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0)
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:  BorderSide(
                    color: widget.hintColor
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:  BorderSide(
                    color: widget.hintColor
                  ),
                ),
                hintText: widget.hintText,
                hintStyle: TextStyle(
                  color: widget.hintColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.library_add,
                    color: widget.hintColor,
                  ), 
                  onPressed: () {
                    if ( amenityTextController.text.isNotEmpty ) {
                      setState(() {
                        amenities.add(
                          Amenity(text: amenityTextController.text, added: true)
                        );
                      });
                      
                      amenityTextController.clear();
                    }
                  }
                )
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            alignment: Alignment.centerLeft,
            child: Wrap(
              runSpacing: 8,
              spacing: 10,
              direction: Axis.horizontal,

              children: List.generate(amenities.length, (index) {

                return Container(
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
                        text: amenities[index].text,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Material(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                amenities[index].added =  !( amenities[index].added );
                              });
                            },
                            child: Icon(
                              amenities[index].added ? Icons.check_circle : Icons.add_circle_outline_rounded,
                              color: amenities[index].added ? App.mainColor : App.hintColor,
                            )
                          ),
                        ),
                      )
                    ],
                  ),
                );
                
              }),
            ),
          )
        ],
      ),
    );
  }
}