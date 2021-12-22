import 'package:dazle/app/pages/listing_details/components/listing_details_container_box.dart';
import 'package:dazle/app/pages/listing_details/components/listing_details_icon_button.dart';
import 'package:dazle/app/pages/listing_details/listing_details_controller.dart';
import 'package:dazle/app/utils/app.dart';
import 'package:dazle/app/widgets/custom_text.dart';
import 'package:dazle/data/repositories/data_listing_repository.dart';
import 'package:dazle/domain/entities/property.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';



class ListingDetailsPage extends View {
  ListingDetailsPage({
    Key key,
    @required this.property
  }) : super(key: key);

  final Property property;

  @override
  _ListingDetailsPageState createState() => _ListingDetailsPageState();
}


class _ListingDetailsPageState extends ViewState<ListingDetailsPage, ListingDetailsController> {
  _ListingDetailsPageState() : super(ListingDetailsController(DataListingRepository()));

  @override
  Widget get view {
    return Scaffold(
      key: globalKey,
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            actions: <Widget>[
              ListingDetailsIconButton(
                iconData: Icons.file_download,
                tooltip: "download",
                onPressed: () {},
              ),
              ListingDetailsIconButton(
                iconData: Icons.bookmark_border,
                tooltip: "preview",
                onPressed: () {},
              ),
              ListingDetailsIconButton(
                iconData: Icons.open_in_new_outlined,
                tooltip: "bookmark",
                onPressed: () {},
              )
            ],
            leading: ListingDetailsIconButton(
              margin: EdgeInsets.only(left: 8),
              iconData: Icons.arrow_back_ios_rounded,
              tooltip: MaterialLocalizations.of(context).backButtonTooltip,
              onPressed: () => Navigator.of(context).pop(),
            ),
            leadingWidth: 51,
            backgroundColor: App.mainColor,  
            expandedHeight: 271,
            floating: true,  
            pinned: true  
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              ListView(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "${widget.property.amount}",
                          style: App.textStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800
                          )
                        ),
                        TextSpan(
                          text: "/${widget.property.timePeriod}",
                          style: App.textStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700
                          )
                        ),
                      ]
                    ),
                  ),
                  CustomText(
                    text: '${widget.property.city}',
                    color: App.hintColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(height: 20),
                  ListingDetailsContainerBox(
                    asset: 'assets/icons/bed.png',
                    text: '${widget.property.totalBedRoom} Bedroom(s)',
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Flexible(
                        child: ListingDetailsContainerBox(
                          asset: 'assets/icons/bath.png',
                          text: '${widget.property.totalBathRoom} Bathroom(s)',
                        ),
                      ),
                      SizedBox(width: 8),
                      Flexible(
                        child: ListingDetailsContainerBox(
                          asset: 'assets/icons/area.png',
                          text: '${widget.property.totalArea} sqft',
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Flexible(
                        child: ListingDetailsContainerBox(
                          asset: 'assets/icons/car.png',
                          text: '${widget.property.totalParkingSpace} parking spot(s)',
                        ),
                      ),
                      SizedBox(width: 8),
                      Flexible(
                        child: ListingDetailsContainerBox(
                          asset: 'assets/icons/furnished.png',
                          text: '${widget.property.isYourProperty}',
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                  Divider(
                    color: App.hintColor,
                    height: 1.5,
                  ),
                  SizedBox(height: 20),
                  CustomText(
                    text: 'Location',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 40,
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromRGBO(168, 238, 252, 1.0)
                          ),
                          child: Image.asset(
                            'assets/icons/location.png',
                          ),
                        ),
                        SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: '${widget.property.district}',
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                            CustomText(
                              text: '${widget.property.city}',
                              color: App.hintColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Divider(
                    color: App.hintColor,
                    height: 1.5,
                  ),
                  SizedBox(height: 20),
                  CustomText(
                    text: 'Features and Amenities',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                  SizedBox(height: 8),
                  GridView.builder(
                    padding: EdgeInsets.zero,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: widget.property.amenities.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: MediaQuery.of(context).orientation == Orientation.landscape ? 3 : 2,
                      childAspectRatio: 5
                    ),
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          Icon(
                            Icons.check,
                            color: App.hintColor,
                          ),
                          SizedBox(width: 8),
                          CustomText(
                            text: widget.property.amenities[index],
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  CustomText(
                    text: 'Description',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                  SizedBox(height: 10),
                  CustomText(
                    text: "${widget.property.description}",
                    color: App.hintColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  SizedBox(height: 20),
                ],
              )
            ]),
          )
        ],
      )
    );
  }
}