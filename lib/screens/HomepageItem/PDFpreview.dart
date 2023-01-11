import 'dart:async';
import 'dart:io';

import 'package:e_stock/services/pdfGenerator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
// import 'package:url_launcher/url_launcher.dart' as ul;

import 'package:open_filex/open_filex.dart';

class pdfScreen extends StatefulWidget {
  const pdfScreen({Key? key, required this.data, required this.fileName})
      : super(key: key);
  final List<List<String>> data;
  final String? fileName;
  @override
  pdfScreenState createState() {
    return pdfScreenState();
  }
}

class pdfScreenState extends State<pdfScreen>
    with SingleTickerProviderStateMixin {
  Future<void> _saveAsFile(
    BuildContext context,
    LayoutCallback build,
    PdfPageFormat pageFormat,
  ) async {
    final bytes = await buildPdf(pageFormat, widget.data, widget.fileName!);

    final appDocDir = await getApplicationDocumentsDirectory();
    final appDocPath = appDocDir.path;
    final file = File('$appDocPath/${widget.fileName}.pdf');
    print('Save as file ${file.path} ...');
    await file.writeAsBytes(bytes);
    await OpenFilex.open(file.path);
  }

  @override
  Widget build(BuildContext context) {
    pw.RichText.debug = true;

    final actions = <PdfPreviewAction>[
      if (!kIsWeb)
        PdfPreviewAction(
          icon: const Icon(Icons.save),
          onPressed: _saveAsFile,
        )
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Apercu du bilan')),
      body: PdfPreview(
        maxPageWidth: 700,
        build: (format) => buildPdf(format, widget.data, widget.fileName!),
        actions: actions,
        allowPrinting: false,
        previewPageMargin:
            const EdgeInsets.symmetric(vertical: 50, horizontal: 5),
        shouldRepaint: true,
      ),
    );
  }

  // void _showSources() {
  //   ul.launchUrl(
  //     Uri.parse(
  //       'https://github.com/DavBfr/dart_pdf/blob/master/demo/lib/examples/${examples[_tab].file}',
  //     ),
  //   );
  // }

}
