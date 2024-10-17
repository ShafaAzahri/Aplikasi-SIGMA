import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:flutter/services.dart' show rootBundle;

class PDFViewerPage extends StatefulWidget {
  final String pdfFileName;

  PDFViewerPage({required this.pdfFileName});

  @override
  _PDFViewerPageState createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPage> {
  String? localPath;

  @override
  void initState() {
    super.initState();
    getFileFromAssets(widget.pdfFileName).then((f) {
      setState(() {
        localPath = f.path;
      });
    });
  }

  Future<File> getFileFromAssets(String asset) async {
    try {
      var data = await rootBundle.load(asset);
      var bytes = data.buffer.asUint8List();
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/rapat1.pdf");

      File assetFile = await file.writeAsBytes(bytes);
      return assetFile;
    } catch (e) {
      throw Exception("Error opening asset file");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
      ),
      body: localPath != null
          ? PDFView(
              filePath: localPath!,
              enableSwipe: true,
              swipeHorizontal: true,
              autoSpacing: false,
              pageFling: false,
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
