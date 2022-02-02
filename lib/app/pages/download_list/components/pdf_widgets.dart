import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfWidgets {
  PdfColor _textColor = PdfColor.fromHex('#2e353d');
  PdfColor _hintColor = PdfColor.fromHex('#9aa0a6');
  PdfColor _mainColor = PdfColor.fromHex('#33d49d');

  /// Custom Text for the pdf file
  pdfCustomText({
    @required String text,
    double fontSize = 13,
    pw.FontWeight fontWeight,
  }) {
    return pw.Text(
      text,
      style: pw.TextStyle(
        color: _textColor,
        fontWeight: fontWeight,
        fontStyle: pw.FontStyle.normal,
        fontSize: fontSize,
      ),
    );
  }

  /// Custom RichText for the pdf file
  pdfCustomRichText({
    @required String mainText,
    @required String valueText,
    double fontSize,
  }) {
    return pw.RichText(
      text: pw.TextSpan(
        children: [
          pw.TextSpan(
            text: mainText,
            style: pw.TextStyle(
              color: _textColor,
              fontWeight: pw.FontWeight.bold,
              fontSize: 13,
            ),
          ),
          pw.TextSpan(
            text: valueText,
            style: pw.TextStyle(
              color: _textColor,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  /// Takes a the district property from "Property" and returns a pill shaped
  /// container on top of the pdf pictures
  pdfAddressContainer({
    @required String district,
  }) {
    return pw.Container(
      padding: pw.EdgeInsets.symmetric(vertical: 15),
      width: 180,
      height: 50,
      decoration: pw.BoxDecoration(
        shape: pw.BoxShape.rectangle,
        borderRadiusEx: pw.BorderRadius.all(pw.Radius.circular(25)),
        border: pw.Border.all(
          color: PdfColors.white,
          width: 2,
        ),
        color: _mainColor,
      ),
      child: pw.Center(
        child: pw.Text(
          district == null ? 'Test' : district,
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
    @required String price,
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
        borderRadiusEx: pw.BorderRadius.all(pw.Radius.circular(25)),
        color: _mainColor,
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
            // TODO: Finalize where/how to compute this data.
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
