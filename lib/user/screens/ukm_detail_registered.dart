import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class UKMDetailRegisteredPage extends StatelessWidget {
  final String ukmName;

  UKMDetailRegisteredPage({required this.ukmName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail $ukmName'),
        backgroundColor: Color.fromARGB(255, 255, 252, 230),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderImage(),
            _buildProgramKerjaCard(
                context, 'Program Kerja Panggung Rakyat', '26 September 2024'),
            _buildProgramKerjaCard(
                context, 'Kegiatan Mangan Turu', '1 Desember 2025'),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderImage() {
    return Image.asset(
      'assets/bem_header.png',
      width: double.infinity,
      height: 200,
      fit: BoxFit.cover,
    );
  }

  Widget _buildProgramKerjaCard(
      BuildContext context, String title, String date) {
    return Card(
      margin: EdgeInsets.all(8),
      child: ExpansionTile(
        title: Text(
          title,
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        subtitle: Text(date, style: TextStyle(color: Colors.black87)),
        backgroundColor: Color.fromARGB(255, 255, 252, 230),
        collapsedBackgroundColor: Color.fromARGB(255, 255, 252, 230),
        children: [
          Container(
            color: Color.fromARGB(255, 255, 252, 230),
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Panitia Program Kerja',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                SizedBox(height: 8),
                _buildPanitiaList(),
                SizedBox(height: 16),
                _buildRapatButton(context, 'Rapat 1', 'assets/rapat1.pdf'),
                SizedBox(height: 8),
                _buildRapatButton(context, 'Rapat 2', 'assets/rapat1.pdf'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPanitiaList() {
    final List<Map<String, String>> panitia = [
      {'name': 'Fais', 'position': 'Ketua Umum'},
      {'name': 'Safa', 'position': 'Wakil Ketua'},
      {'name': 'Ammar', 'position': 'Sekretaris'},
      {'name': 'Dio', 'position': 'Bendahara'},
      {'name': 'Zaim', 'position': 'Koordinator Acara'},
      {'name': 'Ajik', 'position': 'Koordinator Perlengkapan'},
      {'name': 'Calista', 'position': 'Koordinator Konsumsi'},
      {'name': 'Aldo', 'position': 'Koordinator Dokumentasi'},
      {'name': 'Dirga', 'position': 'Koordinator Humas'},
    ];

    return Container(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: panitia.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.only(right: 8),
            child: Container(
              width: 150,
              padding: EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    panitia[index]['name']!,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 4),
                  Text(
                    panitia[index]['position']!,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.black87),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRapatButton(
      BuildContext context, String rapatName, String pdfAsset) {
    return ElevatedButton(
      child: Text(rapatName, style: TextStyle(color: Colors.black)),
      onPressed: () => _showPDFView(context, pdfAsset),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        minimumSize: Size(double.infinity, 40),
      ),
    );
  }

  void _showPDFView(BuildContext context, String pdfAsset) async {
    String pdfPath = await _extractPDFAsset(pdfAsset);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PDFViewerPage(pdfPath: pdfPath),
      ),
    );
  }

  Future<String> _extractPDFAsset(String assetPath) async {
    final bytes = await rootBundle.load(assetPath);
    final list = bytes.buffer.asUint8List();
    final tempDir = await getTemporaryDirectory();
    final tempDocumentPath = '${tempDir.path}/$assetPath';
    final file = await File(tempDocumentPath).create(recursive: true);
    file.writeAsBytesSync(list);
    return tempDocumentPath;
  }
}

class PDFViewerPage extends StatelessWidget {
  final String pdfPath;

  PDFViewerPage({required this.pdfPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
        backgroundColor: Color.fromARGB(255, 255, 252, 230),
      ),
      body: PDFView(
        filePath: pdfPath,
        enableSwipe: true,
        swipeHorizontal: true,
        autoSpacing: false,
        pageFling: false,
        onError: (error) {
          print(error.toString());
        },
        onPageError: (page, error) {
          print('$page: ${error.toString()}');
        },
      ),
    );
  }
}
