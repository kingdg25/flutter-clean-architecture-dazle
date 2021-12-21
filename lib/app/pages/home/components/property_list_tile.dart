import 'package:cached_network_image/cached_network_image.dart';
import 'package:dazle/app/widgets/property_text_info.dart';
import 'package:dazle/app/utils/app.dart';
import 'package:dazle/app/utils/app_constant.dart';
import 'package:dazle/app/widgets/custom_text.dart';
import 'package:dazle/domain/entities/property.dart';
import 'package:flutter/material.dart';

class PropertyListTile extends StatelessWidget {
  final List<Property> items;
  final double height;
  final double width;

  PropertyListTile({
    @required this.items,
    this.height = 215.0,
    this.width = 285.0
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: items?.length ?? 0,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index){
          return Padding(
            padding: EdgeInsets.only(top: 8, bottom: 8, right: 10),
            child: GestureDetector(
              onTap: () {
                print('click property $index');
              },
              child: Container(
                width: width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: [
                    AppConstant.boxShadow
                  ]
                ),
                child: Column(
                  children: [
                    CachedNetworkImage(
                      height: height*0.56,
                      imageUrl: items[index].photoURL.toString(),
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
                          SizedBox(height: 2),
                          CustomText(
                            text: '${items[index].amount} PHP',
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                          SizedBox(height: 6),
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
            ),
          );
        },
      ),
    );
  }
}