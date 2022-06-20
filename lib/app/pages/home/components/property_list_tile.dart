import 'package:cached_network_image/cached_network_image.dart';
import 'package:dazle/app/pages/listing_details/listing_details_view.dart';
import 'package:dazle/app/widgets/property_text_info.dart';
import 'package:dazle/app/utils/app.dart';
import 'package:dazle/app/utils/app_constant.dart';
import 'package:dazle/app/widgets/custom_text.dart';
import 'package:dazle/domain/entities/property.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:open_file/open_file.dart';
import 'package:share_plus/share_plus.dart';

import '../../listing_details/components/listing_details_icon_button.dart';
import 'package:dazle/app/pages/home/components/pdf_generator.dart';

class PropertyListTile extends StatelessWidget {
  final List<Property> items;
  final double height;
  final double width;

  PropertyListTile(
      {required this.items, this.height = 350.0, this.width = 285.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: items.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: EdgeInsets.only(top: 8, bottom: 8, right: 10),
            child: GestureDetector(
              onTap: () {
                print('click property $index');
                print(items[index].id);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (buildContext) => ListingDetailsPage(
                        listingId: items[index].id,
                      ),
                    ));
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                      width: width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [AppConstant.boxShadow]),
                      child: Column(
                        children: [
                          CachedNetworkImage(
                            height: height * 0.56,
                            imageUrl: items[index].photos![0].toString() == null
                                ? items[index].coverPhoto.toString()
                                : items[index].photos![0].toString(),
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10)),
                                image: DecorationImage(
                                    image: imageProvider, fit: BoxFit.cover),
                              ),
                            ),
                            progressIndicatorBuilder:
                                (context, url, progress) => Center(
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
                          ),
                          Padding(
                              padding: EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // CustomText(
                                  //   text: items[index].keywordsToString ?? '',
                                  //   fontSize: 9,
                                  //   color: App.hintColor,
                                  //   fontWeight: FontWeight.w500,
                                  // ),
                                  CustomText(
                                    text: items[index].title == null
                                        ? '(No Listing Title)'
                                        : items[index].title,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w900,
                                  ),
                                  SizedBox(height: 2),
                                  CustomText(
                                    text: items[index].propertyFor == 'Rent'
                                        ? '${items[index].formatPrice}PHP/${items[index].timePeriod?.replaceAll('ly', '')}'
                                        : '${items[index].formatPrice} PHP',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  CustomText(
                                      text: items[index].completeAddress,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: App.hintColor),
                                  SizedBox(height: 6),
                                  Container(
                                    height: 20,
                                    child: ListView(
                                      scrollDirection: Axis.horizontal,
                                      children: [
                                        PropertyTextInfo(
                                          asset: 'assets/icons/bed.png',
                                          text: '${items[index].totalBedRoom}',
                                        ),
                                        SizedBox(width: 4),
                                        PropertyTextInfo(
                                          asset: 'assets/icons/bath.png',
                                          text: '${items[index].totalBathRoom}',
                                        ),
                                        SizedBox(width: 4),
                                        PropertyTextInfo(
                                          asset: 'assets/icons/car.png',
                                          text: items[index].totalParkingSpace,
                                        ),
                                        SizedBox(width: 4),
                                        PropertyTextInfo(
                                          asset: '',
                                          text:
                                              '${items[index].formatArea} sqm',
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ))
                        ],
                      )),
                  Positioned(
                    top: 5,
                    right: 10,
                    child: Row(
                      children: [
                        ListingDetailsIconButton(
                          iconPadding: 6,
                          iconSize: 19,
                          iconData: Icons.file_download_outlined,
                          tooltip: "Download",
                          onPressed: () async {
                            //? Changed to open pdf
                            print('ashjkfdjasdhfkljashdfljkhasf');
                            Loader.show(context);
                            String? pdfFilePath = await PdfGenerator()
                                .downloadPdf(property: items[index]);
                            Loader.hide();
                            await OpenFile.open(pdfFilePath);
                          },
                        ),
                        ListingDetailsIconButton(
                          iconPadding: 6,
                          iconSize: 19,
                          iconData: Icons.share,
                          tooltip: "Share",
                          onPressed: () async {
                            //     ));
                            String? pdfFilePath = await PdfGenerator()
                                .sharePdf(property: items[index]);
                            Loader.hide();
                            List<String> filePaths = [];
                            filePaths.add(pdfFilePath!);
                            await Share.shareFiles(
                              filePaths,
                              mimeTypes: ["image/jpg"],
                              subject:
                                  'Dazle Property Listing-${items[index].id}',
                              text: 'Dazle Property Listing-${items[index].id}',
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
