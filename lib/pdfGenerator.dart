import 'dart:io';
import 'dart:typed_data';

import 'package:e_stock/other/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';

const _darkColor = PdfColors.blueGrey800;
const _lightColor = PdfColors.white;
Future<Uint8List> buildPdf(
    PdfPageFormat pageFormat, List<List<String>> data, String filename) async {
  String? logo = await rootBundle.loadString('assets/images/logo.svg');
  // Create a PDF document.
  final doc = pw.Document();

  // Add page to the PDF
  doc.addPage(
    pw.MultiPage(
      pageTheme: _buildTheme(
        pageFormat,
        await PdfGoogleFonts.robotoRegular(),
        await PdfGoogleFonts.robotoBold(),
        await PdfGoogleFonts.robotoItalic(),
      ),
      build: (context) => [
        _contentHeader(filename, logo),
        pw.SizedBox(height: 20),
        _contentTable(context, data),

        // pw.SizedBox(height: 20),
      ],
    ),
  );

  // Return the PDF file content
  return doc.save();
}

pw.Widget _contentTable(pw.Context context, List<List<String>> data) {
  return pw.Table.fromTextArray(
    data: data,
    border: null,
    headerHeight: 25,
    cellHeight: 40,
    cellAlignment: pw.Alignment.centerLeft,
    headerDecoration: const pw.BoxDecoration(
      borderRadius: pw.BorderRadius.all(pw.Radius.circular(2)),
      color: PdfColor.fromInt(0xFFceced6),
    ),
    headerStyle: pw.TextStyle(
        color: PdfColors.blueGrey800,
        fontSize: 15,
        fontWeight: pw.FontWeight.bold),
    cellStyle: const pw.TextStyle(color: _darkColor, fontSize: 12),
    rowDecoration: const pw.BoxDecoration(
      border: pw.Border(
        bottom: pw.BorderSide(color: PdfColors.blueGrey800, width: 1),
      ),
    ),
    // cellAlignments: {
    //   0: pw.Alignment.centerLeft,
    //   1: pw.Alignment.centerLeft,
    //   2: pw.Alignment.centerRight,
    //   3: pw.Alignment.center,
    //   4: pw.Alignment.centerRight,
    // },
  );
}

pw.Widget _contentHeader(String filename, String? logo) {
  // String? logo = await rootBundle.loadString('assets/images/logo.png');
  return pw.Container(
    child: pw.Column(
      // mainAxisAlignment: pw.MainAxisAlignment.spa/,
      mainAxisSize: pw.MainAxisSize.max,
      children: [
        pw.Column(children: [
          pw.Container(
            alignment: pw.Alignment.topLeft,
            // padding: const pw.EdgeInsets.only(),
            height: 75,
            child: logo != null ? pw.SvgImage(svg: logo) : pw.PdfLogo(),
          ),
          pw.Container(
            alignment: pw.Alignment.topLeft,
            padding: const pw.EdgeInsets.only(left: 14),
            child: pw.Text("e-Stock",
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 14,
                )),
          )
        ]),
        pw.Text(
          filename.replaceAll("_", " "),
          style: pw.TextStyle(
            // color: baseColor,
            fontWeight: pw.FontWeight.bold,
            fontSize: 40,
          ),
        ),
      ],
    ),
  );
}

pw.PageTheme _buildTheme(
    PdfPageFormat pageFormat, pw.Font base, pw.Font bold, pw.Font italic) {
  return pw.PageTheme(
      pageFormat: pageFormat,
      theme: pw.ThemeData.withFont(
        base: base,
        bold: bold,
        italic: italic,
      ));
}
