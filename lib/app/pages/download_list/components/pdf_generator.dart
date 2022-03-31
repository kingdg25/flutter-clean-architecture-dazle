import 'dart:io';
import 'dart:typed_data';

import 'package:dazle/domain/entities/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart';
import '../../../../domain/entities/property.dart';
import 'pdf_widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import '../../../utils/app.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

// import 'package:downloads_path_provider/downloads_path_provider.dart';
// import 'package:ext_storage/ext_storage.dart';

class PdfGenerator {
  /// Takes a Property Object and use it's properties to
  /// return a pdf

  Future<pw.Document> buildPdf({required Property property}) async {
    final pdf = pw.Document();
    final image = (await rootBundle.load('assets/dazle_sample_logo.png'))
        .buffer
        .asUint8List();
    final List<pw.Widget> pdfImages = await pdfImageGenerator(property.photos!);
    final User currentUser = await App.getUser();

    pdf.addPage(
      pw.MultiPage(
        theme: pw.ThemeData.withFont(
          icons: await PdfGoogleFonts.materialIcons(),
        ),
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) => <pw.Widget>[
          pw.Container(
            child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  //*======== PDF Title [start]
                  pw.Center(
                      child: PdfWidgets().pdfCustomText(
                          text: property.propertyFor == 'Sell'
                              ? '${property.propertyType} for Sale at ${property.street}, ${property.city}'
                              : '${property.propertyType} for ${property.propertyFor} at ${property.street}, ${property.city} ',
                          fontSize: 27,
                          fontWeight: pw.FontWeight.bold,
                          textAlign: pw.TextAlign.center)),
                  pw.SizedBox(height: 30),
                  //*======== PDF Title [end]
                  // TODO: Move image below the pdf page
                  // pw.Image(
                  //   pw.MemoryImage(image),
                  //   height: 50,
                  // ),
                  pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Expanded(
                        flex: 4,
                        //*===== Pdf Property Details Column [start]
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.SizedBox(
                              height: 10,
                            ),
                            PdfWidgets().pdfCustomRichText(
                              mainText: 'Lot area (sqm): ',
                              valueText: property.formatArea,
                            ),
                            pw.SizedBox(
                              height: 10,
                            ),
                            PdfWidgets().pdfCustomRichText(
                              mainText: 'Frontage: ',
                              valueText: '',
                            ),
                            pw.SizedBox(
                              height: 10,
                            ),
                            PdfWidgets().pdfCustomRichText(
                              mainText: 'Property Type: ',
                              valueText: property.propertyType,
                            ),
                            pw.SizedBox(
                              height: 10,
                            ),
                            PdfWidgets().pdfCustomRichText(
                              mainText: 'Location: ',
                              valueText: '${property.city}',
                            ),
                            pw.SizedBox(
                              height: 10,
                            ),
                            PdfWidgets().pdfCustomRichText(
                              mainText: 'Property Description: ',
                              valueText: property.description,
                            ),
                            pw.SizedBox(
                              height: 10,
                            ),
                            PdfWidgets().pdfCustomRichText(
                              mainText: 'Property: ',
                              valueText: property.isYourProperty,
                            ),
                            pw.SizedBox(
                              height: 10,
                            ),
                            PdfWidgets().pdfCustomRichText(
                              mainText: 'No. of bedrooms: ',
                              valueText: property.totalBedRoom,
                            ),
                            pw.SizedBox(
                              height: 10,
                            ),
                            PdfWidgets().pdfCustomRichText(
                              mainText: 'No. of bathrooms: ',
                              valueText: property.totalBathRoom,
                            ),
                            pw.SizedBox(
                              height: 10,
                            ),
                            PdfWidgets().pdfCustomRichText(
                              mainText: 'No. of parking spots: ',
                              valueText: property.totalParkingSpace,
                            ),
                            pw.SizedBox(
                              height: 10,
                            ),
                            PdfWidgets().pdfCustomRichText(
                              mainText: 'Features and amenities: ',
                              valueText: property.amenities!.join(", "),
                            ),
                          ],
                        ),
                      ),
                      //*===== Pdf Property Details Column [end]
                      //------------------------------------------------------
                      //*===== Pdf Property Photos Column [start]
                      pw.Expanded(
                        flex: 6,
                        child: pw.Padding(
                          padding: pw.EdgeInsets.symmetric(vertical: 10),
                          child: pw.Stack(
                            overflow: pw.Overflow.visible,
                            alignment: pw.Alignment.center,
                            children: [
                              pw.Column(
                                crossAxisAlignment:
                                    pw.CrossAxisAlignment.stretch,
                                children: pdfImages,
                              ),
                              // pw.Positioned(
                              //   top: -20,
                              //   child: PdfWidgets().pdfAddressContainer(
                              //       text: '${property.city} '),
                              // ),
                              pw.Positioned(
                                top: -20,
                                child: PdfWidgets().pdfAddressContainer(
                                    text: property.propertyFor == 'Sell'
                                        ? '${property.formatPrice} PHP'
                                        : '${property.formatPrice} PHP /${property.timePeriod}'),
                              ),
                              // pw.Positioned(
                              //   bottom: -18,
                              //   child: PdfWidgets()
                              //       .pdfPriceContainer(price: property.price!),
                              // )
                            ],
                          ),
                        ),
                      ),
                      //*===== Pdf Property Photos Column [end]
                    ],
                  ),
                ]),
          ),
        ],
        //*===== Pdf Property Footer [start]
        footer: (pw.Context context) {
          return pw.Row(children: [
            pw.Expanded(
              flex: 2,
              child: pw.Image(
                pw.MemoryImage(image),
                height: 40,
              ),
            ),
            pw.Expanded(
              flex: 5,
              child: pw.Container(
                alignment: pw.Alignment.centerRight,
                margin: pw.EdgeInsets.only(top: 1 * PdfPageFormat.cm),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    PdfWidgets().pdfCustomRichText(
                      mainText: 'Selling Agent: ',
                      valueText: currentUser.displayName,
                    ),
                    pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.end,
                        children: [
                          pw.Icon(pw.IconData(0xe0cd), size: 13),
                          PdfWidgets().pdfCustomText(
                              text: ' ${currentUser.mobileNumber}')
                        ]),
                    pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.end,
                        children: [
                          pw.Icon(pw.IconData(0xe0be), size: 13),
                          PdfWidgets()
                              .pdfCustomText(text: ' ${currentUser.email}')
                        ]),
                  ],
                ),
              ),
            ),
          ]);
        },
        //*===== Pdf Property Footer [start]
      ),
    );

    return pdf;
  }

  /// Takes a Property object to be used by the buildPdf() function
  /// then returns the String of the download path
  Future<String?> downloadPdf({Property? property}) async {
    String? downloadPath;

    /// Request Permission to Write on Local Storage
    Map<Permission, PermissionStatus> statuses =
        await [Permission.storage].request();

    if (statuses[Permission.storage]!.isGranted) {
      final listingPdf =
          await buildPdf(property: property!); // Builds the pdf file

      try {
        final dir = await getExternalStorageDirectory();
        // downloadPath =
        //     '${dir?.path}/Dazzle Property List - ${property.district} - ${property.city} ${DateTime.now().toIso8601String()}.pdf';
        downloadPath = '${dir!.path}/Dazle Property Listing-${property.id}.pdf';

        final file = File(downloadPath);
        await file.writeAsBytes(await listingPdf.save());
        print('saved to app internal directory');
      } catch (e) {
        print('error ${e.toString()}');
      }
    }

    return downloadPath;
  }

  /// Takes a Property object to be used by the buildPdf() function
  /// then share the pdf using the share_plus package
  Future<String?> sharePdf({required Property property}) async {
    final listingPdf = await buildPdf(property: property);
    String? filePath;

    //* Save pdf to App Storage Directory
    try {
      final dir = await getApplicationDocumentsDirectory();
      // localPath =
      // '${dir.path}/Dazle Property List - ${property.street} - ${property.city} ${DateTime.now().toIso8601String()}.pdf';
      filePath = '${dir.path}/Dazle Property Listing-${property.id}.pdf';

      final file = File(filePath);
      await file.writeAsBytes(await listingPdf.save());

      print('saved to documents');
    } catch (e) {
      print('error ${e.toString()}');
    }

    return filePath;
  }

  /// Takes the List of links(of the photos) from the
  /// Property Object and returns a List<pw.Widget> to be
  /// inserted in the 2nd column of the pdf.
  /// This is flexible for 1 - 5 images
  Future<List<pw.Widget>> pdfImageGenerator(List photos) async {
    List<pw.Widget> pdfImages = <pw.Widget>[];

    //* First/cover image
    pdfImages.add(
      pw.Container(
        margin: pw.EdgeInsets.fromLTRB(5, 0, 5, 5),
        child: pw.ClipRRect(
          horizontalRadius: 5.0,
          verticalRadius: 5.0,
          child: pw.Image(
            pw.MemoryImage(await imageConverter(photos[0])),
            fit: pw.BoxFit.cover,
            height: 200,
          ),
        ),
      ),
    );

    // *If photos.lenth == 2 will add below the first with the
    // *the same size
    if (photos.length == 2) {
      pdfImages.add(
        pw.Container(
          margin: pw.EdgeInsets.all(5),
          child: pw.ClipRRect(
            horizontalRadius: 5.0,
            verticalRadius: 5.0,
            child: pw.Image(
              pw.MemoryImage(await imageConverter(photos[1])),
              fit: pw.BoxFit.cover,
              height: 200,
            ),
          ),
        ),
      );
    } else if (photos.length > 2) {
      // *If photos.lenth > 2 will add a row below the first with half
      // *the height of the cover photo containing 2 images
      pdfImages.add(
        pw.Row(children: [
          pw.Expanded(
            child: pw.Container(
              margin: pw.EdgeInsets.all(5),
              child: pw.ClipRRect(
                horizontalRadius: 5.0,
                verticalRadius: 5.0,
                child: pw.Image(
                  pw.MemoryImage(await imageConverter(photos[1])),
                  fit: pw.BoxFit.cover,
                  height: 100,
                ),
              ),
            ),
          ),
          pw.Expanded(
            child: pw.Container(
              margin: pw.EdgeInsets.all(5),
              child: pw.ClipRRect(
                horizontalRadius: 5.0,
                verticalRadius: 5.0,
                child: pw.Image(
                  pw.MemoryImage(await imageConverter(photos[2])),
                  fit: pw.BoxFit.cover,
                  height: 100,
                ),
              ),
            ),
          ),
        ]),
      );
    }

    // *If photos.length == 4 will add below the 2nd row  with the
    // *the same size of the cover image
    if (photos.length == 4) {
      pdfImages.add(
        pw.Container(
          margin: pw.EdgeInsets.all(5),
          child: pw.ClipRRect(
            horizontalRadius: 5.0,
            verticalRadius: 5.0,
            child: pw.Image(
              pw.MemoryImage(await imageConverter(photos[3])),
              fit: pw.BoxFit.cover,
              height: 200,
            ),
          ),
        ),
      );
    }
    // *If photos.lenth ==5 2 will add a row below the 2nd row with half
    // *the height of the cover photo containing 2 images
    else if (photos.length > 4) {
      pdfImages.add(
        pw.Row(children: [
          pw.Expanded(
            child: pw.Container(
              margin: pw.EdgeInsets.all(5),
              child: pw.ClipRRect(
                horizontalRadius: 5.0,
                verticalRadius: 5.0,
                child: pw.Image(
                  pw.MemoryImage(await imageConverter(photos[3])),
                  fit: pw.BoxFit.cover,
                  height: 100,
                ),
              ),
            ),
          ),
          pw.Expanded(
            child: pw.Container(
              margin: pw.EdgeInsets.all(5),
              child: pw.ClipRRect(
                horizontalRadius: 5.0,
                verticalRadius: 5.0,
                child: pw.Image(
                  pw.MemoryImage(await imageConverter(photos[4])),
                  fit: pw.BoxFit.cover,
                  height: 100,
                ),
              ),
            ),
          ),
        ]),
      );
    }

    print(pdfImages);

    return pdfImages;
  }

  /// Takes the image from the link, convert it and return a Uint8List
  /// to be used by the pdfImageGenerator()
  Future<Uint8List> imageConverter(String link) async {
    return Uint8List.fromList((await Dio()
            .get(link, options: Options(responseType: ResponseType.bytes),
                onReceiveProgress: (cur, total) {
      print(((cur / total) * 100).round().toString());
    }))
        .data);
  }
}
