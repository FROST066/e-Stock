import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';

const _darkColor = PdfColors.blueGrey800;
// const _lightColor = PdfColors.white;
Future<Uint8List> buildPdf(
    PdfPageFormat pageFormat, List<List<String>> data, String filename) async {
  String? logo = await rootBundle.loadString('assets/images/logo.svg');
  // Create a PDF document.
  final doc = Document();

  // Add page to the PDF
  doc.addPage(
    MultiPage(
      pageTheme: _buildTheme(
        pageFormat,
        await PdfGoogleFonts.robotoRegular(),
        await PdfGoogleFonts.robotoBold(),
        await PdfGoogleFonts.robotoItalic(),
      ),
      build: (context) => [
        _contentHeader(filename, logo),
        SizedBox(height: 20),
        _contentTable(context, data),
      ],
    ),
  );

  // Return the PDF file content
  return doc.save();
}

Widget _contentTable(Context context, List<List<String>> data) {
  return Table.fromTextArray(
    data: data,
    border: null,
    headerHeight: 25,
    cellHeight: 40,
    cellAlignment: Alignment.center,
    headerDecoration: const BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(2)),
      color: PdfColor.fromInt(0xFFceced6),
    ),
    headerStyle: TextStyle(
        color: PdfColors.blueGrey800,
        fontSize: 15,
        fontWeight: FontWeight.bold),
    cellStyle: const TextStyle(color: _darkColor, fontSize: 12),
    rowDecoration: const BoxDecoration(
      border: Border(
        bottom: BorderSide(color: PdfColors.blueGrey800, width: 1),
      ),
    ),
  );
}

Widget _contentHeader(String filename, String? logo) {
  return Container(
    child: Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Column(children: [
          Container(
            alignment: Alignment.topLeft,
            height: 75,
            child: logo != null ? SvgImage(svg: logo) : PdfLogo(),
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.only(left: 14),
            child: Text("e-Stock",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                )),
          )
        ]),
        Text(
          filename.replaceAll("_", " "),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 33,
          ),
        ),
      ],
    ),
  );
}

PageTheme _buildTheme(
    PdfPageFormat pageFormat, Font base, Font bold, Font italic) {
  return PageTheme(
      pageFormat: pageFormat,
      theme: ThemeData.withFont(
        base: base,
        bold: bold,
        italic: italic,
      ));
}
