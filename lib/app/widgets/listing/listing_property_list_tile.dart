import 'package:cached_network_image/cached_network_image.dart';
import 'package:dazle/app/pages/listing_details/listing_details_view.dart';
import 'package:dazle/app/utils/app.dart';
import 'package:dazle/app/utils/app_constant.dart';
import 'package:dazle/app/widgets/custom_text.dart';
import 'package:dazle/app/widgets/property_text_info.dart';
import 'package:dazle/domain/entities/property.dart';
import 'package:flutter/material.dart';

class ListingPropertyListTile extends StatelessWidget {
  final List<Property> items;
  final double height;
  final double width;
  final EdgeInsetsGeometry padding;

  ListingPropertyListTile({
    @required this.items,
    this.height = 255.0,
    this.width = 322.0,
    this.padding = const EdgeInsets.all(0.0)
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: items?.length ?? 0,
      itemBuilder: (BuildContext context, int index){
        return Padding(
          padding: padding,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: [
                AppConstant.boxShadow
              ]
            ),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (buildContext) => ListingDetailsPage(
                          property: items[index],
                        )
                      )
                    );
                  },
                  child: CachedNetworkImage(
                    height: height*0.51,
                    imageUrl: items[index].coverPhoto.toString(),
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover
                        ),
                      ),
                    ),
                    progressIndicatorBuilder: (context, url, progress) => Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.indigo[900]),
                        value: progress.progress,
                      ),
                    ),
                    errorWidget: (context, url, error) => Image.asset(
                      'assets/brooky_logo.png',
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: items[index].keywordsToString ?? '',
                        fontSize: 9,
                        color: App.hintColor,
                        fontWeight: FontWeight.w500,
                      ),
                      CustomText(
                        text: '${items[index].price} PHP',
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                      CustomText(
                        text: '${items[index].district ?? "No disctrict specified"}',
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                      CustomText(
                        text: '${items[index].city}',
                        fontSize: 10,
                        color: App.hintColor,
                        fontWeight: FontWeight.w500,
                      ),
                      SizedBox(height: 5),
                      Container(
                        height: 20,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            PropertyTextInfo(
                              asset: 'assets/icons/bed.png',
                              text: items[index].totalBedRoom,
                            ),
                            SizedBox(width: 4),
                            PropertyTextInfo(
                              asset: 'assets/icons/bath.png',
                              text: items[index].totalBathRoom,
                            ),
                            SizedBox(width: 4),
                            PropertyTextInfo(
                              asset: 'assets/icons/car.png',
                              text: items[index].totalParkingSpace,
                            ),
                            SizedBox(width: 4),
                            PropertyTextInfo(
                              asset: '',
                              text: items[index].totalArea,
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                )
              ],
            )
          ),
        );
      },
    );
  }
}