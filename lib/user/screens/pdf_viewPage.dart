import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;

class PDFViewerPage extends StatefulWidget {
  final String pdfFileName;

  const PDFViewerPage({
    Key? key, 
    required this.pdfFileName,
  }) : super(key: key);

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
      final data = await rootBundle.load(asset);
      final bytes = data.buffer.asUint8List();
      final dir = await getApplicationDocumentsDirectory();
      final file = File("${dir.path}/rapat1.pdf");
      final assetFile = await file.writeAsBytes(bytes);
      return assetFile;
    } catch (e) {
      throw Exception("Error opening asset file: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Viewer'),
        backgroundColor: const Color.fromARGB(255, 255, 252, 230),
      ),
      body: localPath != null
          ? PDFView(
              filePath: localPath!,
              enableSwipe: true,
              swipeHorizontal: true,
              autoSpacing: false,
              pageFling: false,
              onError: (error) {
                print('Error while loading PDF: $error');
              },
              onPageError: (page, error) {
                print('Error on page $page: $error');
              },
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}