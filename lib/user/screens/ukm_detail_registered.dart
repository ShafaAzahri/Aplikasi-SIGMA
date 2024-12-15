import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:latihan/models/ukm_detail_registered.dart';
import 'package:latihan/service/api_url.dart';
import 'package:latihan/service/ukm.dart';

// Constants
const kColors = {
  'primary': Color(0xFF161D6F),
  'cream': Color(0xFFFFF8DC),
  'white': Colors.white,
  'black': Colors.black87,
  'grey': Colors.grey,
};

const kPadding = {
  'small': 8.0,
  'medium': 16.0,
  'large': 24.0,
};

class UKMDetailRegisteredPage extends StatefulWidget {
  final String ukmId;
  final String ukmName;

  const UKMDetailRegisteredPage({
    Key? key,
    required this.ukmId,
    required this.ukmName,
  }) : super(key: key);

  @override
  _UKMDetailRegisteredPageState createState() => _UKMDetailRegisteredPageState();
}

class _UKMDetailRegisteredPageState extends State<UKMDetailRegisteredPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final UkmService _ukmService = UkmService();
  late Future<UkmDetail> _ukmDetailFuture;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _ukmDetailFuture = _ukmService.getUkmDetailData(widget.ukmId);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<UkmDetail>(
        future: _ukmDetailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingState();
          }

          if (snapshot.hasError) {
            return _buildErrorState(snapshot.error.toString());
          }

          if (!snapshot.hasData) {
            return _buildEmptyState();
          }

          return _buildContent(snapshot.data!);
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: CircularProgressIndicator(
        color: kColors['primary'],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: Colors.red),
          SizedBox(height: kPadding['medium']),
          Text('Error: $error'),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_open,
            size: 48,
            color: kColors['grey'],
          ),
          SizedBox(height: kPadding['medium']),
          Text('Tidak ada data tersedia'),
        ],
      ),
    );
  }

  Widget _buildContent(UkmDetail ukmDetail) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          _buildSliverAppBar(ukmDetail),
          _buildSliverTabBar(),
        ];
      },
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildProkerTab(ukmDetail.proker),
          _buildAgendaTab(ukmDetail.agenda),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(UkmDetail ukmDetail) {
    return SliverAppBar(
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Image.network(
          '${AppConfig.assetBaseUrl}/${ukmDetail.bannerPath}',
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: kColors['grey']?.withOpacity(0.3),
            child: Icon(Icons.image_not_supported),
          ),
        ),
      ),
    );
  }

  Widget _buildSliverTabBar() {
    return SliverPersistentHeader(
      delegate: _SliverAppBarDelegate(
        TabBar(
          controller: _tabController,
          labelColor: kColors['primary'],
          unselectedLabelColor: kColors['grey'],
          indicatorColor: kColors['primary'],
          tabs: [
            Tab(text: 'Program Kerja'),
            Tab(text: 'Agenda'),
          ],
        ),
      ),
      pinned: true,
    );
  }

  Widget _buildProkerTab(List<TimelineModel> prokerList) {
    if (prokerList.isEmpty) {
      return _buildEmptyTabContent('Tidak ada program kerja');
    }

    return ListView.builder(
      padding: EdgeInsets.all(kPadding['medium']!),
      itemCount: prokerList.length,
      itemBuilder: (context, index) => _buildTimelineCard(
        prokerList[index],
        isProker: true,
      ),
    );
  }

  Widget _buildAgendaTab(List<TimelineModel> agendaList) {
    if (agendaList.isEmpty) {
      return _buildEmptyTabContent('Tidak ada agenda');
    }

    return ListView.builder(
      padding: EdgeInsets.all(kPadding['medium']!),
      itemCount: agendaList.length,
      itemBuilder: (context, index) => _buildTimelineCard(
        agendaList[index],
        isProker: false,
      ),
    );
  }

  Widget _buildEmptyTabContent(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_busy,
            size: 48,
            color: kColors['grey'],
          ),
          SizedBox(height: kPadding['medium']),
          Text(
            message,
            style: TextStyle(
              color: kColors['grey'],
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineCard(TimelineModel timeline, {required bool isProker}) {
    return Card(
      margin: EdgeInsets.only(bottom: kPadding['medium']!),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(
            timeline.judulKegiatan,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: kColors['black'],
            ),
          ),
          subtitle: Text(
            '${timeline.formattedTanggal}\n${timeline.formattedWaktu}',
            style: TextStyle(color: kColors['grey']),
          ),
          children: [
            _buildTimelineDetails(timeline, isProker),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineDetails(TimelineModel timeline, bool isProker) {
    return Padding(
      padding: EdgeInsets.all(kPadding['medium']!),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(timeline.deskripsi),
          if (isProker && timeline.panitia.isNotEmpty) ...[
            SizedBox(height: kPadding['medium']),
            _buildPanitiaSection(timeline.panitia),
          ],
          if (isProker && timeline.rapat != null && timeline.rapat!.isNotEmpty) ...[
            SizedBox(height: kPadding['medium']),
            _buildRapatSection(timeline.rapat!),
          ],
          if (!isProker && timeline.dokumentasi != null) ...[
            SizedBox(height: kPadding['medium']),
            _buildDokumentasiSection(timeline.dokumentasi!),
          ],
        ],
      ),
    );
  }

  Widget _buildPanitiaSection(List<PanitiaModel> panitia) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Panitia Kegiatan',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: kColors['black'],
          ),
        ),
        SizedBox(height: kPadding['small']),
        Container(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: panitia.length,
            itemBuilder: (context, index) => _buildPanitiaCard(panitia[index]),
          ),
        ),
      ],
    );
  }

  Widget _buildPanitiaCard(PanitiaModel panitia) {
    return Card(
      margin: EdgeInsets.only(right: kPadding['small']!),
      child: Container(
        width: 160,
        padding: EdgeInsets.all(kPadding['small']!),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              panitia.nama,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: kColors['black'],
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: kPadding['small']),
            Text(
              panitia.jabatan,
              style: TextStyle(
                color: kColors['grey'],
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRapatSection(List<RapatModel> rapatList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dokumen Rapat',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: kColors['black'],
          ),
        ),
        SizedBox(height: kPadding['small']),
        ...rapatList.map((rapat) => _buildRapatCard(rapat)).toList(),
      ],
    );
  }

  Widget _buildRapatCard(RapatModel rapat) {
    return Card(
      margin: EdgeInsets.only(bottom: kPadding['small']!),
      child: Padding(
        padding: EdgeInsets.all(kPadding['medium']!),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              rapat.judul,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: kColors['black'],
              ),
            ),
            SizedBox(height: kPadding['small']),
            Text(
              rapat.formattedTanggal,
              style: TextStyle(color: kColors['grey']),
            ),
            if (rapat.notulensiPath.isNotEmpty) ...[
              SizedBox(height: kPadding['small']),
              _buildNotulensiButton(rapat.notulensiPath),
            ],
            if (rapat.dokumentasi.isNotEmpty) ...[
              SizedBox(height: kPadding['medium']),
              _buildDokumentasiSection(rapat.dokumentasi),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNotulensiButton(String notulensiPath) {
    return ElevatedButton.icon(
      onPressed: () => _showPDFView(context, notulensiPath),
      icon: Icon(Icons.description),
      label: Text('Lihat Notulensi'),
      style: ElevatedButton.styleFrom(
        backgroundColor: kColors['primary'],
        foregroundColor: kColors['white'],
        padding: EdgeInsets.symmetric(
          horizontal: kPadding['medium']!,
          vertical: kPadding['small']!,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildDokumentasiSection(List<DokumentasiModel> dokumentasi) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dokumentasi',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: kColors['black'],
          ),
        ),
        SizedBox(height: kPadding['small']),
        Container(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: dokumentasi.length,
            itemBuilder: (context, index) => _buildDokumentasiItem(dokumentasi[index]),
          ),
        ),
      ],
    );
  }

  Widget _buildDokumentasiItem(DokumentasiModel dokumentasi) {
    return GestureDetector(
      onTap: () => _showImageDialog(dokumentasi.fotoPath),
      child: Container(
        width: 160,
        margin: EdgeInsets.only(right: kPadding['small']!),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            '${AppConfig.assetBaseUrl}/dokumentasi/${dokumentasi.fotoPath}',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: kColors['grey']?.withOpacity(0.3),
              child: Icon(Icons.image_not_supported),
            ),
          ),
        ),
      ),
    );
  }

  void _showImageDialog(String imagePath) {
    showDialog(
        context: context,
        builder: (context) => Dialog(
        child: Container(
        constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.9,
    maxHeight: MediaQuery.of(context).size.height * 0.7,
    ),
    child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
    AppBar(
    title: Text('Dokumentasi'),
    backgroundColor: kColors['primary'],
    leading: IconButton(
    icon: Icon(Icons.close),
      onPressed: () => Navigator.pop(context),
    ),
    ),
      Flexible(
        child: InteractiveViewer(
          panEnabled: true,
          boundaryMargin: EdgeInsets.all(20),
          minScale: 0.5,
          maxScale: 4,
          child: Image.network(
            '${AppConfig.assetBaseUrl}/dokumentasi/$imagePath',
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => Center(
              child: Icon(Icons.image_not_supported),
            ),
          ),
        ),
      ),
    ],
    ),
        ),
        ),
    );
  }

  Future<void> _showPDFView(BuildContext context, String pdfPath) async {
    try {
      final url = '${AppConfig.assetBaseUrl}/notulensi/$pdfPath';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        final tempDir = await getTemporaryDirectory();
        final tempDocumentPath = '${tempDir.path}/temp.pdf';
        final file = await File(tempDocumentPath).create(recursive: true);
        await file.writeAsBytes(bytes);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => _PDFViewerPage(pdfPath: tempDocumentPath),
          ),
        );
      } else {
        throw Exception('Failed to load PDF');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: File PDF tidak ditemukan'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

class _PDFViewerPage extends StatelessWidget {
  final String pdfPath;

  const _PDFViewerPage({
    Key? key,
    required this.pdfPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
        backgroundColor: kColors['primary'],
      ),
      body: PDFView(
        filePath: pdfPath,
        enableSwipe: true,
        swipeHorizontal: true,
        autoSpacing: false,
        pageFling: false,
        onError: (error) {
          print('Error: $error');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error saat membuka PDF'),
              backgroundColor: Colors.red,
            ),
          );
        },
        onPageError: (page, error) {
          print('Page $page: $error');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error saat memuat halaman PDF'),
              backgroundColor: Colors.red,
            ),
          );
        },
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: kColors['white'],
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}