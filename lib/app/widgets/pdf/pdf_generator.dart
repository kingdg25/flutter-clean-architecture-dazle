import 'dart:io';
import 'dart:typed_data';

import 'package:dazle/domain/entities/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart';
import '../../../../domain/entities/property.dart';
import 'pdf_widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:dazle/app/utils/app.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

// import 'package:downloads_path_provider/downloads_path_provider.dart';
// import 'package:ext_storage/ext_storage.dart';

class PdfGenerator {
  /// Takes a Property Object and use it's properties to
  /// return a pdf

  Future<pw.Document> buildPdf({required Property property}) async {
    final pdf = pw.Document();
    final dazleLogo = (await rootBundle.load('assets/dazle_sample_logo.png'))
        .buffer
        .asUint8List();
    final defaultProfilePic =
        (await rootBundle.load('assets/user_profile.png')).buffer.asUint8List();

    final List<pw.Widget> pdfImages = await pdfImageGenerator(property.photos!);
    final User currentUser = await App.getUser();
    pw.MemoryImage userProfilePic = pw.MemoryImage(defaultProfilePic);

    final pw.Widget coverPhoto = await pdfCoverPhoto(property.photos!);
    final double rowImageHeight = 120;
    final pw.Widget listingImages =
        await pdfRowImages(property.photos!, rowImageHeight);

    if (currentUser.profilePicture != null) {
      userProfilePic =
          pw.MemoryImage(await imageConverter(currentUser.profilePicture!));
    }

    final customDateFormat1 = new DateFormat('MM/dd/yyyy');
    final customDateFormat2 = new DateFormat('MMM yyyy');

    Map<dynamic, dynamic>? mapCoordinates = {};
    double? latitude;
    double? longitude;
    String mapLink = "";
    pw.Widget mapImage = pw.Container();

    if (property.coordinates != null) {
      mapCoordinates = property.coordinates;
      latitude = mapCoordinates?["Latitude"];
      longitude = mapCoordinates?["Longitude"];
      mapLink =
          "https://maps.googleapis.com/maps/api/staticmap?center=$latitude,%20$longitude&zoom=19&size=600x400&markers=color:0x33D49D|$latitude,$longitude&key=AIzaSyCSacvsau8vEncNbORdwU0buakm7Mx2rbE&maptype=hybrid";
      mapImage = await generateMapImage(mapLink);
    }

    pdf.addPage(
      pw.MultiPage(
        theme: pw.ThemeData.withFont(
          icons: await PdfGoogleFonts.materialIcons(),
        ),
        pageFormat: PdfPageFormat.legal,

        build: (pw.Context context) => <pw.Widget>[
          pw.Container(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                //*============================================================= PDF Title [START]
                pw.Container(
                  decoration: pw.BoxDecoration(
                    borderRadius: pw.BorderRadius.circular(10),
                    color: PdfColor.fromHex('#1f4bc6'),
                  ),
                  padding: pw.EdgeInsets.all(15),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                    children: [
                      PdfWidgets().pdfCustomText(
                          text: property.title == null
                              ? '(No Listing Title)'
                              : property.title!,
                          fontSize: 27,
                          textColor: PdfColor.fromHex('#FFFFFF'),
                          fontWeight: pw.FontWeight.bold,
                          textAlign: pw.TextAlign.center),
                      PdfWidgets().pdfCustomText(
                        text: 'Location: ' + property.completeAddress,
                        fontSize: 14,
                        textAlign: pw.TextAlign.center,
                        textColor: PdfColor.fromHex('#FFFFFF'),
                      ),
                      pw.SizedBox(height: 5),
                      pw.Divider(
                        height: 2,
                        color: PdfColor.fromHex('#FFFFFF'),
                      ),
                      pw.SizedBox(height: 5),
                      PdfWidgets().pdfCustomText(
                          text: property.propertyFor == 'Sell'
                              ? '${property.formatPrice} PHP'
                              : '${property.formatPrice} PHP /${property.timePeriod}',
                          fontSize: 25,
                          textColor: PdfColor.fromHex('#FFFFFF'),
                          fontWeight: pw.FontWeight.bold,
                          textAlign: pw.TextAlign.center),
                    ],
                  ),
                ),
                pw.SizedBox(height: 30),
                coverPhoto,
                //*============================================================= PDF Title [END]
                //***************
                //*============================================================= Listing Details [START]
                pw.SizedBox(height: 5),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.SizedBox(
                      height: 5,
                    ),
                    PdfWidgets().pdfCustomRichText(
                      mainText: 'Property Type: ',
                      valueText: property.propertyType,
                    ),
                    pw.SizedBox(
                      height: 5,
                    ),
                    PdfWidgets().pdfCustomRichText(
                      mainText: 'Property for: ',
                      valueText: property.propertyFor,
                    ),
                    pw.SizedBox(
                      height: 5,
                    ),
                    PdfWidgets().pdfCustomRichText(
                      mainText: 'Lot area (sqm): ',
                      valueText: property.formatArea,
                    ),
                    property.floorArea == 0
                        ? pw.Container()
                        : pw.SizedBox(
                            height: 10,
                          ),
                    property.floorArea == 0
                        ? pw.Container()
                        : PdfWidgets().pdfCustomRichText(
                            mainText: 'Floor area (sqm): ',
                            valueText: '${property.formatFloorArea}',
                          ),
                    property.frontageArea == 0
                        ? pw.Container()
                        : pw.SizedBox(
                            height: 5,
                          ),
                    property.frontageArea == 0
                        ? pw.Container()
                        : PdfWidgets().pdfCustomRichText(
                            mainText: 'Frontage (meters): ',
                            valueText: '${property.formatFrontageArea}',
                          ),
                    pw.SizedBox(
                      height: 5,
                    ),
                    PdfWidgets().pdfCustomRichText(
                      mainText: 'Property Description: ',
                      valueText: property.description,
                    ),
                    property.isYourProperty == null ||
                            property.isYourProperty == ''
                        ? pw.Container()
                        : pw.SizedBox(
                            height: 5,
                          ),
                    property.isYourProperty == null ||
                            property.isYourProperty == ''
                        ? pw.Container()
                        : PdfWidgets().pdfCustomRichText(
                            mainText: 'Property: ',
                            valueText: property.isYourProperty,
                          ),
                    property.propertyType!.contains('Lot') ||
                            property.propertyType!.contains('Building')
                        ? pw.Container()
                        : pw.SizedBox(
                            height: 5,
                          ),
                    property.propertyType!.contains('Lot') ||
                            property.propertyType!.contains('Building')
                        ? pw.Container()
                        : PdfWidgets().pdfCustomRichText(
                            mainText: 'No. of bedrooms: ',
                            valueText: '${property.totalBedRoom}',
                          ),
                    property.propertyType!.contains('Lot') ||
                            property.propertyType!.contains('Building')
                        ? pw.Container()
                        : pw.SizedBox(
                            height: 5,
                          ),
                    property.propertyType!.contains('Lot') ||
                            property.propertyType!.contains('Building')
                        ? pw.Container()
                        : PdfWidgets().pdfCustomRichText(
                            mainText: 'No. of bathrooms: ',
                            valueText: '${property.totalBathRoom}',
                          ),
                    pw.SizedBox(
                      height: 5,
                    ),
                    PdfWidgets().pdfCustomRichText(
                      mainText: 'No. of parking spots: ',
                      valueText: property.totalParkingSpace,
                    ),
                    pw.SizedBox(
                      height: 5,
                    ),
                    PdfWidgets().pdfCustomRichText(
                      mainText: 'Features and amenities: ',
                      valueText: property.amenities!.join(", "),
                    ),
                    pw.SizedBox(
                      height: 5,
                    ),
                    property.coordinates == null
                        ? PdfWidgets().pdfCustomRichText(
                            mainText: 'Map Location:',
                            valueText: 'No Map Location provided.',
                          )
                        : pw.Container(),
                  ],
                ),
                //*============================================================= Listing Details [END]
                //***************
                //*============================================================= Listing Images [START]
                property.photos!.length > 1 ? listingImages : pw.Container(),
                pw.SizedBox(height: 20),
                //*============================================================= Listing Images [END]
                //***************
                //*============================================================= Listing Map Location [START]
                property.coordinates == null
                    ? pw.Container()
                    : pw.Container(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            //*---------- PDF Title [start]
                            PdfWidgets().pdfCustomRichText(
                              mainText: 'Map Location:',
                              valueText: '',
                            ),
                            pw.SizedBox(height: 10),
                            pw.Center(
                              child: mapImage,
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          ),
        ],
        //*===================================================================== Listing Images [END]
        //***************
        //*===================================================================== PDF Footer [START]
        footer: (pw.Context context) {
          return pw.Column(
            // crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            mainAxisAlignment: pw.MainAxisAlignment.start,
            children: [
              pw.Divider(
                color: PdfColor.fromHex('#9aa0a6'),
                thickness: .5,
                height: 0,
              ),
              pw.Row(
                children: [
                  //* ================= Broker Contact Details [START]
                  pw.Expanded(
                    flex: 4,
                    child: pw.Container(
                      padding: pw.EdgeInsets.only(top: 10),
                      decoration: pw.BoxDecoration(
                        border: pw.Border(
                          right: pw.BorderSide(
                            width: .5,
                            color: PdfColor.fromHex('#9aa0a6'),
                          ),
                        ),
                      ),
                      child: pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        children: [
                          pw.Center(
                            child: pw.ClipRRect(
                              verticalRadius: 5,
                              horizontalRadius: 5,
                              child: pw.Image(
                                userProfilePic,
                                height: 65,
                                width: 65,
                                fit: pw.BoxFit.cover,
                              ),
                            ),
                          ),
                          pw.SizedBox(height: 2),
                          PdfWidgets().pdfCustomText(
                            text: currentUser.displayName,
                            fontSize: 11,
                            textAlign: pw.TextAlign.center,
                            fontWeight: pw.FontWeight.bold,
                          ),
                          pw.SizedBox(height: 2),
                          PdfWidgets().pdfCustomText(
                            text: 'Real Estate ' + currentUser.position!,
                            fontSize: 10,
                            textAlign: pw.TextAlign.center,
                            fontWeight: pw.FontWeight.bold,
                          ),
                          pw.SizedBox(height: 2),
                          PdfWidgets().pdfCustomText(
                              text: '${currentUser.mobileNumber}',
                              fontSize: 10),
                          pw.SizedBox(height: 2),
                          PdfWidgets().pdfCustomText(
                              text: currentUser.displayEmail != null
                                  ? '${currentUser.displayEmail}'
                                  : '${currentUser.email}',
                              fontSize: 10),

                          // pw.Row(
                          //     mainAxisAlignment: pw.MainAxisAlignment.center,
                          //     children: [
                          //       pw.Icon(pw.IconData(0xe0cd), size: 13),
                          //       pw.SizedBox(
                          //         width: 5,
                          //       ),
                          //       PdfWidgets().pdfCustomText(
                          //           text: currentUser.displayMobileNumber !=
                          //                   null
                          //               ? '${currentUser.displayMobileNumber}'
                          //               : '${currentUser.mobileNumber}')
                          //     ]),
                          // pw.SizedBox(height: 5),
                          // pw.Row(
                          //     mainAxisAlignment: pw.MainAxisAlignment.center,
                          //     children: [
                          //       pw.Icon(pw.IconData(0xe0be), size: 13),
                          //       PdfWidgets().pdfCustomText(
                          //           text: currentUser.displayEmail != null
                          //               ? '${currentUser.displayEmail}'
                          //               : '${currentUser.email}')
                          //     ]),
                        ],
                      ),
                    ),
                  ),
                  //* ================= Broker Contact Details [END]
                  // **********
                  // * ================= Salesperson licence Details [START]
                  currentUser.position != 'Salesperson' ||
                          currentUser.licenseDetails == null
                      ? pw.Container()
                      // pw.Expanded(
                      //     flex: 5,
                      //     child: true
                      //         ? pw.Container()
                      //         : pw.Container(
                      //             padding: pw.EdgeInsets.only(left: 10),
                      //             child: pw.Center(
                      //               child: PdfWidgets().pdfCustomText(
                      //                   fontSize: 10,
                      //                   fontstyle: pw.FontStyle.italic,
                      //                   text:
                      //                       '"No License Details Provided by Broker."'),
                      //             ),
                      //           ),
                      //   )
                      : pw.Expanded(
                          flex: 5,
                          child: pw.Container(
                            padding: pw.EdgeInsets.only(top: 10, left: 15),
                            child: pw.Column(
                              // crossAxisAlignment: pw.CrossAxisAlignment.start,
                              mainAxisAlignment: pw.MainAxisAlignment.start,
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              mainAxisSize: pw.MainAxisSize.min,
                              children: [
                                PdfWidgets().pdfCustomRichText(
                                    mainText: 'RES Accreditation No: ',
                                    fontSize: 10,
                                    valueText: currentUser.licenseDetails[
                                        "Sales RES Accreditation No"]),
                                pw.SizedBox(height: 1),
                                PdfWidgets().pdfCustomRichText(
                                    mainText: 'RES PRC ID No: ',
                                    fontSize: 10,
                                    valueText: currentUser
                                        .licenseDetails["Sales RES PRC Id No"]),
                                pw.SizedBox(height: 1),
                                PdfWidgets().pdfCustomRichText(
                                    mainText: 'Valid Until: ',
                                    fontSize: 10,
                                    valueText: customDateFormat1.format(
                                        DateTime.parse(
                                            currentUser.licenseDetails[
                                                "Sales RES PRC Date"]))),
                                pw.SizedBox(height: 1),
                                PdfWidgets().pdfCustomRichText(
                                    mainText: 'REB PTR No:',
                                    fontSize: 10,
                                    valueText: currentUser
                                        .licenseDetails["Sales REB PTR No"]),
                                pw.SizedBox(height: 1),
                                PdfWidgets().pdfCustomRichText(
                                    mainText: 'Valid Until: ',
                                    fontSize: 10,
                                    valueText: customDateFormat2.format(
                                        DateTime.parse(
                                            currentUser.licenseDetails[
                                                "Sales REB PTR Date"]))),
                                pw.SizedBox(height: 1),
                                PdfWidgets().pdfCustomRichText(
                                  mainText: 'AIPO No: ',
                                  fontSize: 10,
                                  valueText: currentUser
                                      .licenseDetails["Sales AIPO No"],
                                ),
                                pw.SizedBox(height: 1),
                                PdfWidgets().pdfCustomRichText(
                                    mainText: 'Valid Until: ',
                                    fontSize: 10,
                                    valueText: customDateFormat1.format(
                                        DateTime.parse(
                                            currentUser.licenseDetails[
                                                "Sales AIPO Date"]))),
                                pw.SizedBox(height: 1),
                              ],
                            ),
                          ),
                        ),
                  //* ================= Salesperson licence Details [END]
                  // **********
                  //* ================= Broker licence Details [START]
                  currentUser.licenseDetails == null
                      ? pw.Container()
                      : pw.Expanded(
                          flex: 5,
                          child: pw.Container(
                            padding: pw.EdgeInsets.only(top: 10, left: 15),
                            child: pw.Column(
                              // crossAxisAlignment: pw.CrossAxisAlignment.start,
                              mainAxisAlignment: pw.MainAxisAlignment.start,
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              mainAxisSize: pw.MainAxisSize.min,
                              children: [
                                currentUser.position != 'Salesperson'
                                    ? pw.Container()
                                    : PdfWidgets().pdfCustomText(
                                        text:
                                            '${currentUser.licenseDetails['Broker First Name']} ${currentUser.licenseDetails['Broker Last Name']} ',
                                        fontSize: 11,
                                        textAlign: pw.TextAlign.center,
                                        fontWeight: pw.FontWeight.bold,
                                      ),
                                PdfWidgets().pdfCustomRichText(
                                    mainText: 'REB PRC License No: ',
                                    fontSize: 10,
                                    valueText: currentUser
                                        .licenseDetails["REB PRC License No"]),
                                pw.SizedBox(height: 1),
                                PdfWidgets().pdfCustomRichText(
                                    mainText: 'REB PRC ID No: ',
                                    fontSize: 10,
                                    valueText: currentUser
                                        .licenseDetails["REB PRC Id No"]),
                                pw.SizedBox(height: 1),
                                PdfWidgets().pdfCustomRichText(
                                    mainText: 'Valid Until: ',
                                    fontSize: 10,
                                    valueText: customDateFormat1.format(
                                        DateTime.parse(currentUser
                                            .licenseDetails["REB PRC Date"]))),
                                pw.SizedBox(height: 1),
                                PdfWidgets().pdfCustomRichText(
                                    mainText: 'REB PTR No:',
                                    fontSize: 10,
                                    valueText: currentUser
                                        .licenseDetails["REB PTR No"]),
                                pw.SizedBox(height: 1),
                                PdfWidgets().pdfCustomRichText(
                                    mainText: 'Valid Until: ',
                                    fontSize: 10,
                                    valueText: customDateFormat2.format(
                                        DateTime.parse(currentUser
                                            .licenseDetails["REB PTR Date"]))),
                                pw.SizedBox(height: 1),
                                PdfWidgets().pdfCustomRichText(
                                    mainText: 'DHSUD No: ',
                                    fontSize: 10,
                                    valueText:
                                        currentUser.licenseDetails["DHSUD No"]),
                                pw.SizedBox(height: 1),
                                PdfWidgets().pdfCustomRichText(
                                    mainText: 'Valid Until: ',
                                    fontSize: 10,
                                    valueText: customDateFormat2.format(
                                        DateTime.parse(currentUser
                                            .licenseDetails["DHSUD Date"]))),
                                pw.SizedBox(height: 1),
                                PdfWidgets().pdfCustomRichText(
                                  mainText: 'AIPO No: ',
                                  fontSize: 10,
                                  valueText:
                                      currentUser.licenseDetails["AIPO No"],
                                ),
                                pw.SizedBox(height: 1),
                                PdfWidgets().pdfCustomRichText(
                                    mainText: 'Valid Until: ',
                                    fontSize: 10,
                                    valueText: customDateFormat1.format(
                                        DateTime.parse(currentUser
                                            .licenseDetails["AIPO Date"]))),
                                pw.SizedBox(height: 1),
                              ],
                            ),
                          ),
                        ),
                  //* ================= Broker licence Details [END]
                ],
              ),
              pw.SizedBox(
                height: 10,
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Image(
                    pw.MemoryImage(dazleLogo),
                    height: 20,
                  ),
                  pw.SizedBox(width: 10),
                  pw.Container(
                    alignment: pw.Alignment.centerRight,
                    child: PdfWidgets().pdfCustomText(
                        textColor: PdfWidgets().hintColor,
                        text:
                            'Page ${context.pageNumber} of ${context.pagesCount}'),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
    //*========================================================================= PDF Footer [END]

    return pdf;
  }

  Future<pw.Widget> generateMapImage(String mapLink) async {
    pw.Widget mapImage = pw.Container(
      child: pw.ClipRRect(
        child: pw.Image(
          pw.MemoryImage(await imageConverter(mapLink)),
          // fit: pw.BoxFit.cover,
          height: 200,
        ),
      ),
    );

    return mapImage;
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
      // pd.update(value: 100);
      try {
        final dir = Platform.isAndroid
            ? await getExternalStorageDirectory()
            : await getApplicationDocumentsDirectory();
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
      final dir = Platform.isAndroid
          ? await getExternalStorageDirectory()
          : await getApplicationDocumentsDirectory();
      filePath = '${dir!.path}/Dazle Property Listing-${property.id}.pdf';

      final file = File(filePath);
      await file.writeAsBytes(await listingPdf.save());

      print('saved to documents');
    } catch (e) {
      print('error ${e.toString()}');
    }

    return filePath;
  }

  Future<pw.Widget> pdfCoverPhoto(List photos) async {
    return pw.Container(
      // margin: pw.EdgeInsets.fromLTRB(5, 0, 5, 5),
      child: pw.ClipRRect(
        // horizontalRadius: 5.0,
        // verticalRadius: 5.0,
        child: pw.Image(
          pw.MemoryImage(await imageConverter(photos[0])),
          fit: pw.BoxFit.cover,
          height: 200,
        ),
      ),
    );
  }

  Future<pw.Widget> pdfRowImages(List photos, double imgHeight) async {
    return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          PdfWidgets().pdfCustomText(
              text: "Listing Photos",
              textAlign: pw.TextAlign.left,
              fontSize: 20,
              fontWeight: pw.FontWeight.bold),
          // Row 1 of images
          photos.length > 1
              ? pw.Row(children: [
                  pw.Expanded(
                    flex: 1,
                    child: pw.Container(
                      margin: pw.EdgeInsets.fromLTRB(5, 5, 5, 5),
                      child: pw.ClipRRect(
                        horizontalRadius: 5.0,
                        verticalRadius: 5.0,
                        child: pw.Image(
                          pw.MemoryImage(await imageConverter(photos[1])),
                          fit: pw.BoxFit.cover,
                          height: imgHeight,
                        ),
                      ),
                    ),
                  ),
                  photos.length >= 3
                      ? pw.Expanded(
                          flex: 1,
                          child: pw.Container(
                            margin: pw.EdgeInsets.fromLTRB(5, 5, 5, 5),
                            child: pw.ClipRRect(
                              horizontalRadius: 5.0,
                              verticalRadius: 5.0,
                              child: pw.Image(
                                pw.MemoryImage(await imageConverter(photos[2])),
                                fit: pw.BoxFit.cover,
                                height: imgHeight,
                              ),
                            ),
                          ),
                        )
                      : pw.Container(),
                  // : pw.Expanded(flex: 1, child: pw.Container()),
                  photos.length >= 4
                      ? pw.Expanded(
                          flex: 1,
                          child: pw.Container(
                            margin: pw.EdgeInsets.fromLTRB(5, 5, 5, 5),
                            child: pw.ClipRRect(
                              horizontalRadius: 5.0,
                              verticalRadius: 5.0,
                              child: pw.Image(
                                pw.MemoryImage(await imageConverter(photos[3])),
                                fit: pw.BoxFit.cover,
                                height: imgHeight,
                              ),
                            ),
                          ),
                        )
                      : pw.Expanded(flex: 1, child: pw.Container()),
                ])
              : pw.Expanded(flex: 1, child: pw.Container()),
          // 2nd row of images
          photos.length > 4
              ? pw.Row(children: [
                  pw.Expanded(
                    flex: 1,
                    child: pw.Container(
                      margin: pw.EdgeInsets.fromLTRB(5, 5, 5, 5),
                      child: pw.ClipRRect(
                        horizontalRadius: 5.0,
                        verticalRadius: 5.0,
                        child: pw.Image(
                          pw.MemoryImage(await imageConverter(photos[4])),
                          fit: pw.BoxFit.cover,
                          height: imgHeight,
                        ),
                      ),
                    ),
                  ),
                  photos.length >= 6
                      ? pw.Expanded(
                          flex: 1,
                          child: pw.Container(
                            margin: pw.EdgeInsets.fromLTRB(5, 5, 5, 5),
                            child: pw.ClipRRect(
                              horizontalRadius: 5.0,
                              verticalRadius: 5.0,
                              child: pw.Image(
                                pw.MemoryImage(await imageConverter(photos[5])),
                                fit: pw.BoxFit.cover,
                                height: imgHeight,
                              ),
                            ),
                          ),
                        )
                      : pw.Expanded(flex: 1, child: pw.Container()),
                  photos.length >= 7
                      ? pw.Expanded(
                          flex: 1,
                          child: pw.Container(
                            margin: pw.EdgeInsets.fromLTRB(5, 5, 5, 5),
                            child: pw.ClipRRect(
                              horizontalRadius: 5.0,
                              verticalRadius: 5.0,
                              child: pw.Image(
                                pw.MemoryImage(await imageConverter(photos[6])),
                                fit: pw.BoxFit.cover,
                                height: imgHeight,
                              ),
                            ),
                          ),
                        )
                      : pw.Expanded(flex: 1, child: pw.Container()),
                ])
              : pw.Container(),
          // 3rd row of images
          photos.length > 7
              ? pw.Row(children: [
                  pw.Expanded(
                    flex: 1,
                    child: pw.Container(
                      margin: pw.EdgeInsets.fromLTRB(5, 5, 5, 5),
                      child: pw.ClipRRect(
                        horizontalRadius: 5.0,
                        verticalRadius: 5.0,
                        child: pw.Image(
                          pw.MemoryImage(await imageConverter(photos[7])),
                          fit: pw.BoxFit.cover,
                          height: imgHeight,
                        ),
                      ),
                    ),
                  ),
                  photos.length >= 9
                      ? pw.Expanded(
                          flex: 1,
                          child: pw.Container(
                            margin: pw.EdgeInsets.fromLTRB(5, 5, 5, 5),
                            child: pw.ClipRRect(
                              horizontalRadius: 5.0,
                              verticalRadius: 5.0,
                              child: pw.Image(
                                pw.MemoryImage(await imageConverter(photos[8])),
                                fit: pw.BoxFit.cover,
                                height: imgHeight,
                              ),
                            ),
                          ),
                        )
                      : pw.Expanded(flex: 1, child: pw.Container()),
                  photos.length >= 10
                      ? pw.Expanded(
                          flex: 1,
                          child: pw.Container(
                            margin: pw.EdgeInsets.fromLTRB(5, 5, 5, 5),
                            child: pw.ClipRRect(
                              horizontalRadius: 5.0,
                              verticalRadius: 5.0,
                              child: pw.Image(
                                pw.MemoryImage(await imageConverter(photos[9])),
                                fit: pw.BoxFit.cover,
                                height: imgHeight,
                              ),
                            ),
                          ),
                        )
                      : pw.Expanded(flex: 1, child: pw.Container()),
                ])
              : pw.Container(),
        ]);
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
        margin: pw.EdgeInsets.fromLTRB(5, 5, 5, 5),
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
