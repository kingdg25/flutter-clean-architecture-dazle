// import 'dart:io';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfWidgets {
  PdfColor mainTextColor = PdfColor.fromHex('#2e353d');
  PdfColor hintColor = PdfColor.fromHex('#9aa0a6');
  PdfColor mainColor = PdfColor.fromHex('#33d49d');

  /// Custom Text for the pdf file
  pdfCustomText(
      {required String text,
      double fontSize = 13,
      pw.FontWeight? fontWeight,
      pw.TextAlign? textAlign,
      PdfColor? textColor,
      pw.FontStyle? fontstyle}) {
    return pw.Text(
      text,
      textAlign: textAlign ?? pw.TextAlign.left,
      style: pw.TextStyle(
        color: textColor ?? mainTextColor,
        fontWeight: fontWeight,
        fontStyle: fontstyle ?? pw.FontStyle.normal,
        fontSize: fontSize,
      ),
    );
  }

  /// Custom RichText for the pdf file
  pdfCustomRichText({
    required String mainText,
    required String? valueText,
    double? fontSize,
  }) {
    return pw.RichText(
      text: pw.TextSpan(
        children: [
          pw.TextSpan(
            text: mainText,
            style: pw.TextStyle(
              color: mainTextColor,
              fontWeight: pw.FontWeight.bold,
              fontSize: fontSize ?? 13,
            ),
          ),
          pw.TextSpan(
            text: valueText,
            style: pw.TextStyle(
              color: mainTextColor,
              fontSize: fontSize ?? 13,
            ),
          ),
        ],
      ),
    );
  }

  /// Takes a the district property from "Property" and returns a pill shaped
  /// container on top of the pdf pictures
  pdfAddressContainer({
    required String? text,
  }) {
    return pw.Container(
      // padding: pw.EdgeInsets.symmetric(vertical: 15),
      width: 180,
      height: 50,
      decoration: pw.BoxDecoration(
        shape: pw.BoxShape.rectangle,
        borderRadius: pw.BorderRadius.all(pw.Radius.circular(25)),
        border: pw.Border.all(
          color: PdfColors.white,
          width: 2,
        ),
        color: mainColor,
      ),
      child: pw.Center(
        child: pw.Text(
          text == null ? 'Test' : text,
          textAlign: pw.TextAlign.center,
          style: pw.TextStyle(
            color: PdfColors.white,
            fontWeight: pw.FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  /// Takes a the price property from "Property" and returns a pill shaped
  /// container below the pdf pictures
  pdfPriceContainer({
    required String price,
  }) {
    return pw.Container(
      padding: pw.EdgeInsets.symmetric(vertical: 5),
      width: 180,
      // height: 50,
      decoration: pw.BoxDecoration(
        shape: pw.BoxShape.rectangle,
        border: pw.Border.all(
          color: PdfColors.white,
          width: 2,
        ),
        borderRadius: pw.BorderRadius.all(pw.Radius.circular(25)),
        color: mainColor,
      ),
      child: pw.Center(
        child: pw.Column(children: [
          pw.Text(
            price,
            style: pw.TextStyle(
              color: PdfColors.white,
              fontWeight: pw.FontWeight.bold,
              fontSize: 20,
            ),
          ),
          pw.Text(
            '20,000/sqm',
            style: pw.TextStyle(
              color: PdfColors.white,
              fontSize: 10,
            ),
          ),
        ]),
      ),
    );
  }
}
