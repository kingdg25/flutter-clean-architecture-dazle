import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/property.dart';
import '../../pages/listing_details/listing_details_view.dart';
import '../../utils/app.dart';
import '../../utils/app_constant.dart';
import '../custom_text.dart';
import '../property_text_info.dart';

class ListingPropertyListTileDetails extends StatelessWidget {
  final List<Property>? items;
  final double height;
  final double width;
  final int index;
  final EdgeInsetsGeometry padding;
  ListingPropertyListTileDetails(
      {required this.items,
      this.height = 255.0,
      this.width = 322.0,
      this.index = 0,
      this.padding = const EdgeInsets.all(0.0),
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: [AppConstant.boxShadow]),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  print('Inside listing tile');
                  print(items![index].id);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (buildContext) => ListingDetailsPage(
                                listingId: items![index].id,
                              )));
                },
                child: CarouselSlider.builder(
                    itemCount: items![index].photos?.length ?? 0,
                    options: CarouselOptions(
                      aspectRatio: 1,
                      viewportFraction: 0.84,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: false,
                      autoPlayInterval: Duration(seconds: 5),
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: true,
                      scrollDirection: Axis.horizontal,
                      // onPageChanged: callbackFunction,
                      height: height * 0.51,
                    ),
                    itemBuilder: (BuildContext context, int itemIndex,
                        int pageViewIndex) {
                      // print("POTOTOTOTs");

                      print(items![index].photos);

                      return CachedNetworkImage(
                        // height: height*0.51,
                        imageUrl: items![index].photos![itemIndex].toString(),
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10)),
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover),
                          ),
                        ),
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
                      );
                    }),
              ),
              Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // CustomText(
                      //   text: items![index].keywordsToString ?? '',
                      //   fontSize: 9,
                      //   color: App.hintColor,
                      //   fontWeight: FontWeight.w500,
                      // ),
                      CustomText(
                        text: items![index].title == null
                            ? '(No Listing Title)'
                            : items![index].title,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                      SizedBox(height: 2),
                      CustomText(
                        text: items![index].propertyFor == 'Rent'
                            ? '${items![index].formatPrice} PHP/${items![index].timePeriod?.replaceAll('ly', '')}'
                            : '${items![index].formatPrice} PHP',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      CustomText(
                        text: items![index].completeAddress,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: App.hintColor,
                      ),
                      //TODO: Place full location here
                      // CustomText(
                      //   text:
                      //       '${items![index].district ?? "No disctrict specified"}',
                      //   fontSize: 10,
                      //   fontWeight: FontWeight.w500,
                      // ),
                      // CustomText(
                      //   text: '${items![index].city}',
                      //   fontSize: 10,
                      //   color: App.hintColor,
                      //   fontWeight: FontWeight.w500,
                      // ),
                      SizedBox(height: 5),
                      Container(
                        height: 20,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            PropertyTextInfo(
                              asset: 'assets/icons/bed.png',
                              text: '${items![index].totalBedRoom}',
                            ),
                            SizedBox(width: 4),
                            PropertyTextInfo(
                              asset: 'assets/icons/bath.png',
                              text: '${items![index].totalBathRoom}',
                            ),
                            SizedBox(width: 4),
                            PropertyTextInfo(
                              asset: 'assets/icons/car.png',
                              text: items![index].totalParkingSpace,
                            ),
                            SizedBox(width: 4),
                            PropertyTextInfo(
                              asset: '',
                              text: items![index].formatArea,
                            ),
                          ],
                        ),
                      )
                    ],
                  ))
            ],
          )),
    );
  }
}
