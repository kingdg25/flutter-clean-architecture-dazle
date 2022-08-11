import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dazle/app/pages/download_list/download_list_controller.dart';
import 'package:dazle/app/utils/app.dart';
import 'package:dazle/app/utils/app_constant.dart';
import 'package:dazle/app/widgets/custom_appbar.dart';
import 'package:dazle/app/widgets/custom_progress_bar.dart';
import 'package:dazle/app/widgets/custom_richtext.dart';
import 'package:dazle/app/widgets/custom_text.dart';
import 'package:dazle/app/widgets/form_fields/custom_button.dart';
import 'package:dazle/app/widgets/form_fields/custom_button_reverse.dart';
import 'package:dazle/data/repositories/data_listing_repository.dart';
import 'package:dazle/domain/entities/property.dart';
import 'package:dazle/domain/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_file/open_file.dart';
import 'package:dazle/app/widgets/pdf/pdf_generator.dart';
import 'package:share_plus/share_plus.dart';

class DownloadListPage extends View {
  DownloadListPage({Key? key, required this.property}) : super(key: key);
  final Property property;
  @override
  _DownloadListPageState createState() => _DownloadListPageState();
}

class _DownloadListPageState
    extends ViewState<DownloadListPage, DownloadListController> {
  _DownloadListPageState()
      : super(DownloadListController(DataListingRepository()));

  final CarouselController _controller = CarouselController();
  int _current = 0;

  @override
  Widget get view {
    String photoCounter = (_current + 1).toString().padLeft(2, '0');
    String totalPhoto =
        widget.property.photos!.length.toString().padLeft(2, '0');

    /// Converts the list property.photos to a list of widgets to be used
    /// by the CarouselSlider widget
    final List<Widget> imageSliders = widget.property.photos!
        .map((item) => Container(
              child: Container(
                // margin: EdgeInsets.all(5.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    child: Stack(
                      children: <Widget>[
                        Image.network(item, fit: BoxFit.cover, width: 1000.0),
                      ],
                    )),
              ),
            ))
        .toList();

    return Stack(
      children: [
        Scaffold(
          key: globalKey,
          appBar: CustomAppBar(
            title: 'Preview List',
          ),
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Image(
                          image: AssetImage('assets/dazle_sample_logo.png'),
                          height: 40,
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      CarouselSlider(
                        items: imageSliders,
                        carouselController: _controller,
                        options: CarouselOptions(
                            autoPlay: true,
                            enableInfiniteScroll: false,
                            viewportFraction: 1,
                            aspectRatio: 2.0,
                            onPageChanged: (index, reason) {
                              setState(() {
                                _current = index;
                              });
                            }),
                      ),
                      Positioned(
                        bottom: 5,
                        right: 10,
                        child: Container(
                          padding: EdgeInsets.all(7),
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              color: Colors.black.withOpacity(.6)),
                          child: Center(
                            child: Text(
                              '$photoCounter/$totalPhoto',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: widget.property.photos!.asMap().entries.map(
                            (entry) {
                              return GestureDetector(
                                onTap: () =>
                                    _controller.animateToPage(entry.key),
                                child: Container(
                                  width: _current == entry.key ? 10.0 : 5.0,
                                  height: _current == entry.key ? 10.0 : 5.0,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 4.0),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            },
                          ).toList(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomRichText(
                    mainText: 'Property Type: ',
                    valueText: widget.property.propertyType,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomRichText(
                    mainText: 'Property for: ',
                    valueText: widget.property.propertyFor,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomRichText(
                    mainText: 'Price: ',
                    valueText: widget.property.pricing == 'Per sqm'
                        ? '${widget.property.formatPrice} PHP/sqm - ${widget.property.timePeriod}ly'
                        : '${widget.property.formatPrice} PHP',
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomRichText(
                    mainText: 'Lot area(sqm): ',
                    valueText: widget.property.formatArea,
                  ),
                  widget.property.frontageArea == 0
                      ? Container()
                      : SizedBox(
                          height: 10,
                        ),
                  widget.property.frontageArea == 0
                      ? Container()
                      : CustomRichText(
                          mainText: 'Frontage (meters): ',
                          valueText: '${widget.property.formatFrontageArea}',
                        ),
                  widget.property.floorArea == 0
                      ? Container()
                      : SizedBox(
                          height: 10,
                        ),
                  widget.property.floorArea == 0
                      ? Container()
                      : CustomRichText(
                          mainText: 'Floor are(sqm): ',
                          valueText: '${widget.property.formatFloorArea}',
                        ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomRichText(
                      mainText: 'Location: ',
                      valueText: '${widget.property.completeAddress}'),
                  SizedBox(
                    height: 10,
                  ),
                  CustomRichText(
                    mainText: 'Property Description: ',
                    valueText: widget.property.description,
                  ),
                  widget.property.isYourProperty == null ||
                          widget.property.isYourProperty == ''
                      ? Container()
                      : SizedBox(
                          height: 10,
                        ),
                  widget.property.isYourProperty == null ||
                          widget.property.isYourProperty == ''
                      ? Container()
                      : CustomRichText(
                          mainText: 'Property: ',
                          valueText: widget.property.isYourProperty,
                        ),
                  widget.property.propertyType!.contains('Lot') ||
                          widget.property.propertyType!.contains('Building')
                      ? Container()
                      : SizedBox(
                          height: 10,
                        ),
                  widget.property.propertyType!.contains('Lot') ||
                          widget.property.propertyType!.contains('Building')
                      ? Container()
                      : CustomRichText(
                          mainText: 'No. of bedrooms: ',
                          valueText: '${widget.property.totalBedRoom}',
                        ),
                  widget.property.propertyType!.contains('Lot') ||
                          widget.property.propertyType!.contains('Building')
                      ? Container()
                      : SizedBox(
                          height: 10,
                        ),
                  widget.property.propertyType!.contains('Lot') ||
                          widget.property.propertyType!.contains('Building')
                      ? Container()
                      : CustomRichText(
                          mainText: 'No. of bathrooms: ',
                          valueText: '${widget.property.totalBathRoom}',
                        ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomRichText(
                    mainText: 'No. of parknig spots: ',
                    valueText: widget.property.totalParkingSpace,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                    children: widget.property.amenities!.map((item) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check,
                              color: App.textColor,
                            ),
                            SizedBox(width: 8),
                            CustomText(
                                text: item,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: App.textColor),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: ControlledWidgetBuilder<DownloadListController>(
              builder: (context, controller) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Divider(
                  height: 1,
                  thickness: 1,
                ),
                Container(
                  padding: EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          child: CustomButton(
                            text: 'Download',
                            onPressed: () async {
                              User currentUser = await App.getUser();
                              if (currentUser.accountStatus != 'Deactivated') {
                                //? Changed to open pdf
                                controller.mixpanel?.track('Download Listing');

                                controller.showHideProgressBar();

                                await Future.delayed(
                                    const Duration(milliseconds: 700));
                                controller.setProgressBarValue(.5);
                                String? pdfFilePath = await PdfGenerator()
                                    .downloadPdf(property: widget.property);

                                controller.setProgressBarValue(1);
                                await Future.delayed(const Duration(
                                    seconds: 1, milliseconds: 300));

                                await OpenFile.open(pdfFilePath);

                                controller.setProgressBarValue(.25);
                                controller.showHideProgressBar();
                              } else {
                                AppConstant.statusDialog(
                                    context: context,
                                    title: 'Action not Allowed',
                                    text:
                                        'Please Reactivate your account first.',
                                    success: false);
                              }
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
                          child: CustomButtonReverse(
                            text: 'Share',
                            onPressed: () async {
                              User currentUser = await App.getUser();
                              if (currentUser.accountStatus != 'Deactivated') {
                                // controller.mixpanel?.track('Share Listing');

                                controller.showHideProgressBar();

                                await Future.delayed(
                                    const Duration(milliseconds: 700));
                                controller.setProgressBarValue(.5);

                                String? pdfFilePath = await PdfGenerator()
                                    .sharePdf(property: widget.property);

                                controller.setProgressBarValue(1);
                                await Future.delayed(const Duration(
                                    seconds: 1, milliseconds: 300));
                                List<String> filePaths = [];
                                filePaths.add(pdfFilePath!);

                                await Share.shareFiles(
                                  filePaths,
                                  mimeTypes: [
                                    Platform.isAndroid
                                        ? "image/jpg"
                                        : "application/pdf"
                                  ],
                                  subject:
                                      'Dazle Property Listing-${widget.property.id}',
                                  text:
                                      'Dazle Property Listing-${widget.property.id}',
                                );

                                controller.setProgressBarValue(.25);
                                controller.showHideProgressBar();
                              } else {
                                AppConstant.statusDialog(
                                    context: context,
                                    title: 'Action not Allowed',
                                    text:
                                        'Please Reactivate your account first.',
                                    success: false);
                              }
                            },
                            backgroudColor: Colors.white,
                            textColor: App.mainColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
        ),
        SafeArea(
          child: ControlledWidgetBuilder<DownloadListController>(
            builder: (context, controller) {
              return controller.showProgressBar == false
                  ? Container()
                  : Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        // color: Color.fromARGB(162, 154, 160, 166),
                        color: Colors.white,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        // height: MediaQuery.of(context).size.height,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image(
                                  image: AssetImage(
                                      'assets/icons/dazle_icon.png')),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                height: 50,
                                width: MediaQuery.of(context).size.width * 0.70,
                                alignment: Alignment.center,
                                child: CustomProgressBar(
                                  text:
                                      'Generating PDF ${controller.progressPercentage()}%',
                                  progressValue: controller.progressValue,
                                ),
                              ),
                              CustomText(
                                text: 'Generating PDF . . . .',
                                fontWeight: FontWeight.bold,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
            },
          ),
        ),
      ],
    );
  }
}
