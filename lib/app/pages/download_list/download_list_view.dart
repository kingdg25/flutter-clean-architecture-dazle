import 'dart:async';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dazle/app/pages/download_list/download_list_controller.dart';
import 'package:dazle/app/utils/app.dart';
import 'package:dazle/app/widgets/custom_appbar.dart';
import 'package:dazle/app/widgets/custom_richtext.dart';
import 'package:dazle/app/widgets/custom_text.dart';
import 'package:dazle/app/widgets/form_fields/custom_button.dart';
import 'package:dazle/app/widgets/form_fields/custom_button_reverse.dart';
import 'package:dazle/data/repositories/data_listing_repository.dart';
import 'package:dazle/domain/entities/property.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:open_file/open_file.dart';
import './components/pdf_generator.dart';
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

    return Scaffold(
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
                          borderRadius: BorderRadius.all(Radius.circular(15)),
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
                            onTap: () => _controller.animateToPage(entry.key),
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
                mainText: 'Price: ',
                valueText: widget.property.formatPrice,
              ),
              SizedBox(
                height: 10,
              ),
              CustomRichText(
                mainText: 'Lot area(sqm): ',
                valueText: widget.property.formatArea,
              ),
              SizedBox(
                height: 10,
              ),
              CustomRichText(
                mainText: 'Frontage: ',
                valueText: '',
                // *To be added on the Property object
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
                  mainText: 'Location: ', valueText: '${widget.property.city}'),
              SizedBox(
                height: 10,
              ),
              CustomRichText(
                mainText: 'Property Description: ',
                valueText: widget.property.description,
              ),
              SizedBox(
                height: 10,
              ),
              CustomRichText(
                mainText: 'Property: ',
                valueText: widget.property.isYourProperty,
              ),
              SizedBox(
                height: 10,
              ),
              CustomRichText(
                mainText: 'No. of bedrooms: ',
                valueText: widget.property.totalBedRoom,
              ),
              SizedBox(
                height: 10,
              ),
              CustomRichText(
                mainText: 'No. of bathrooms: ',
                valueText: widget.property.totalBathRoom,
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
      bottomNavigationBar: Column(
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
                        //? Changed to open pdf
                        print('ashjkfdjasdhfkljashdfljkhasf');
                        Loader.show(context);
                        String? pdfFilePath = await PdfGenerator()
                            .downloadPdf(property: widget.property);
                        Loader.hide();
                        await OpenFile.open(pdfFilePath);
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
                        Loader.show(context);
                        String? pdfFilePath = await PdfGenerator()
                            .sharePdf(property: widget.property);
                        Loader.hide();
                        if (pdfFilePath != null) {
                          await Share.shareFiles(
                            [pdfFilePath],
                            subject:
                                'Dazle Property Listing-${widget.property.id}',
                            text:
                                'Dazle Property Listing-${widget.property.id}',
                          );
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
      ),
    );
  }
}
