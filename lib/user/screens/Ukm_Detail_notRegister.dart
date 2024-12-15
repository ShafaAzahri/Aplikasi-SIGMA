import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:latihan/models/ukm_detail_not_registered.dart';
import 'package:latihan/service/api_url.dart';
import 'package:latihan/service/ukm.dart';
import 'package:latihan/service/button_pendaftaran.dart';
import 'package:latihan/models/cek_periode_pendaftaran.dart';
import 'package:latihan/models/registration_status_model.dart';
import 'package:latihan/user/screens/pemberitahuan.dart';

// Constants
const kColors = {
  'primary': Color(0xFF161D6F),
  'cream': Color(0xFFFFF5E6),
  'white': Colors.white,
  'black': Colors.black,
  'grey': Colors.grey,
};

const kPadding = {
  'small': 8.0,
  'medium': 16.0,
  'large': 24.0,
};

class UKMDetailNotRegister extends StatefulWidget {
  final String ukmName;
  final String ukmId;

  const UKMDetailNotRegister({
    Key? key,
    required this.ukmName,
    required this.ukmId,
  }) : super(key: key);

  @override
  _UKMDetailState createState() => _UKMDetailState();
}

class _UKMDetailState extends State<UKMDetailNotRegister> {
  bool showVisi = true;
  bool showStruktur = true;
  final UkmService _ukmService = UkmService();
  final RegistrationService _registrationService = RegistrationService();
  late Future<UkmDetailNotRegistered> _ukmDetailFuture;
  late Future<RegistrationStatusData> _registrationStatusFuture;
  late Future<RegistrationPeriodResponse> _registrationPeriodFuture;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    _ukmDetailFuture = _ukmService.getUkmDetailNotRegistered(widget.ukmId);
    _registrationStatusFuture = _registrationService.checkRegistrationStatus(widget.ukmId);
    _registrationPeriodFuture = _registrationService.checkRegistrationPeriod(widget.ukmId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<UkmDetailNotRegistered>(
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
      child: Text('Tidak ada data tersedia'),
    );
  }

  Widget _buildContent(UkmDetailNotRegistered data) {
    return CustomScrollView(
      slivers: [
        _buildAppBar(),
        SliverToBoxAdapter(child: _buildBanner(data.ukmDetail.bannerPath)),
        SliverToBoxAdapter(child: _buildVisiMisiToggle()),
        SliverToBoxAdapter(child: _buildVisiMisiContent(data)),
        SliverToBoxAdapter(child: _buildStrukturGaleriToggle()),
        SliverToBoxAdapter(
          child: showStruktur
              ? _buildStrukturSection(data)
              : _buildGaleriSection(data.timeline),
        ),
        SliverToBoxAdapter(child: _buildRegistrationSection()),
      ],
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      title: Text(
        widget.ukmName,
        style: TextStyle(color: kColors['primary']),
      ),
      backgroundColor: kColors['cream'],
      floating: true,
      pinned: true,
      elevation: 0,
    );
  }

  Widget _buildBanner(String bannerPath) {
    return Image.network(
      '${AppConfig.assetBaseUrl}/$bannerPath',
      height: 200,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        height: 200,
        color: kColors['grey']?.withOpacity(0.3),
        child: Icon(Icons.image_not_supported),
      ),
    );
  }

  Widget _buildVisiMisiToggle() {
    return Container(
      height: 50,
      child: Row(
        children: [
          _buildToggleButton('Visi', showVisi, () => setState(() => showVisi = true)),
          _buildToggleButton('Misi', !showVisi, () => setState(() => showVisi = false)),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String text, bool isSelected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          color: isSelected ? kColors['cream'] : kColors['white'],
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: kColors['black'],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVisiMisiContent(UkmDetailNotRegistered data) {
    return Container(
      color: kColors['cream'],
      padding: EdgeInsets.all(kPadding['medium']!),
      child: Text(
        showVisi ? data.ukmDetail.visi : data.ukmDetail.misi,
        style: TextStyle(
          fontSize: 16,
          color: kColors['black'],
        ),
      ),
    );
  }

  Widget _buildStrukturGaleriToggle() {
    return Container(
      height: 50,
      child: Row(
        children: [
          _buildToggleButton(
            'Struktur Organisasi',
            showStruktur,
                () => setState(() => showStruktur = true),
          ),
          _buildToggleButton(
            'Galeri',
            !showStruktur,
                () => setState(() => showStruktur = false),
          ),
        ],
      ),
    );
  }

  Widget _buildStrukturSection(UkmDetailNotRegistered data) {
    if (data.strukturOrganisasi.isEmpty) {
      return _buildEmptyStateCard('Tidak ada data struktur organisasi');
    }

    return Column(
      children: [
        Container(
          height: 200,
          padding: EdgeInsets.symmetric(vertical: kPadding['medium']!),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: data.strukturOrganisasi.length,
            itemBuilder: (context, index) => _buildStrukturCard(
              data.strukturOrganisasi[index],
            ),
          ),
        ),
        _buildViewAllButton(),
      ],
    );
  }

  Widget _buildStrukturCard(StrukturOrganisasi anggota) {
    return Card(
      margin: EdgeInsets.only(right: kPadding['medium']!),
      child: Container(
        width: 150,
        padding: EdgeInsets.all(kPadding['small']!),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildProfileImage(anggota.fotoPath),
            SizedBox(height: kPadding['small']),
            Text(
              anggota.namaLengkap,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: kColors['primary'],
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              anggota.namaJabatan,
              style: TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
            Text(
              '${anggota.tahunMulai}/${anggota.tahunSelesai}',
              style: TextStyle(
                fontSize: 12,
                color: kColors['grey'],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage(String imagePath) {
    return Container(
      height: 80,
      width: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          image: NetworkImage('${AppConfig.assetBaseUrl}/$imagePath'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildGaleriSection(List<Timeline> timeline) {
    if (timeline.isEmpty) {
      return _buildEmptyStateCard('Tidak ada data galeri');
    }

    return CarouselSlider(
      options: CarouselOptions(
        height: 200,
        autoPlay: true,
        enlargeCenterPage: true,
        aspectRatio: 16/9,
        viewportFraction: 0.85,
      ),
      items: timeline.map((item) => _buildGaleriItem(item)).toList(),
    );
  }

  Widget _buildGaleriItem(Timeline item) {
    return GestureDetector(
      onTap: () => _showImageDialog(item),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            '${AppConfig.assetBaseUrl}/${item.imagePath}',
            fit: BoxFit.cover,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withOpacity(0.6),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          Positioned(
            bottom: kPadding['medium'],
            left: kPadding['medium'],
            right: kPadding['medium'],
            child: Text(
              item.judulKegiatan,
              style: TextStyle(
                color: kColors['white'],
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  void _showImageDialog(Timeline item) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              title: Text('Detail Gambar'),
              leading: IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Image.network(
              '${AppConfig.assetBaseUrl}/${item.imagePath}',
              fit: BoxFit.contain,
            ),
            Padding(
              padding: EdgeInsets.all(kPadding['medium']!),
              child: Text(item.judulKegiatan),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegistrationSection() {
    return FutureBuilder<RegistrationStatusData>(
      future: _registrationStatusFuture,
      builder: (context, statusSnapshot) {
        if (statusSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        return FutureBuilder<RegistrationPeriodResponse>(
          future: _registrationPeriodFuture,
          builder: (context, periodSnapshot) {
            if (periodSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            return _buildRegistrationCard(statusSnapshot.data, periodSnapshot.data);
          },
        );
      },
    );
  }

  Widget _buildRegistrationCard(
      RegistrationStatusData? statusData,
      RegistrationPeriodResponse? periodData,
      ) {
    final ButtonConfig config = _getRegistrationButtonConfig(
      statusData,
      periodData,
    );

    return Card(
      margin: EdgeInsets.all(kPadding['medium']!),
      child: Padding(
        padding: EdgeInsets.all(kPadding['medium']!),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Image.asset('assets/daftar.png'),
                ),
                SizedBox(width: kPadding['medium']),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ayo daftarkan dirimu sekarang',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: kPadding['medium']),
                      _buildRegistrationButton(config),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegistrationButton(ButtonConfig config) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (config.message != null) ...[
          Text(
            config.message!,
            style: TextStyle(color: kColors['grey']),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: kPadding['small']),
        ],
        ElevatedButton(
          onPressed: config.enabled ? config.onPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: config.enabled ? kColors['primary'] : kColors['grey'],
            padding: EdgeInsets.symmetric(vertical: 12),
          ),
          child: Text(
              config.text,
              style: TextStyle(
                color: config.enabled ? Colors.white : Colors.grey,
                fontSize: 16,
              ),
          ),
        ),
      ],
    );
  }

  ButtonConfig _getRegistrationButtonConfig(
      RegistrationStatusData? statusData,
      RegistrationPeriodResponse? periodData,
      ) {
    if (periodData != null && !periodData.isOpen) {
      return ButtonConfig(
        text: 'Pendaftaran Ditutup',
        enabled: false,
        message: 'Periode pendaftaran telah berakhir',
      );
    }

    if (statusData == null) {
      return ButtonConfig(
        text: 'Daftar Sekarang',
        enabled: true,
        onPressed: () => _handleRegistration(),
      );
    }

    switch (statusData.status) {
      case 'BELUM_DAFTAR':
        return ButtonConfig(
          text: 'Daftar Sekarang',
          enabled: true,
          onPressed: () => _handleRegistration(),
        );
      case 'PENDING_TAHAP1':
      case 'PENDING_TAHAP2':
      case 'PENDING_TAHAP3':
      case 'ACC_TAHAP1':
      case 'ACC_TAHAP2':
      case 'ACC_TAHAP3':
      case 'DITOLAK':
        return ButtonConfig(
          text: 'Lihat Status',
          enabled: true,
          onPressed: () => _viewRegistrationStatus(),
        );
      case 'PERIODE_TUTUP':
        return ButtonConfig(
          text: 'Pendaftaran Ditutup',
          enabled: false,
          message: 'Periode pendaftaran telah berakhir',
        );
      default:
        return ButtonConfig(
          text: 'Daftar Sekarang',
          enabled: true,
          onPressed: () => _handleRegistration(),
        );
    }
  }

  void _handleRegistration() {
    Navigator.pushNamed(
      context,
      '/pendaftaran',
      arguments: {
        'ukmId': widget.ukmId,
        'ukmName': widget.ukmName,
        'periodId': 1, // This should come from periodData
      },
    );
  }

  void _viewRegistrationStatus() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegistrationStatusPage(
          idUkm: widget.ukmId,
          ukmName: widget.ukmName,
        ),
      ),
    );
  }

  Widget _buildViewAllButton() {
    return Padding(
      padding: EdgeInsets.all(kPadding['medium']!),
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            '/struktur',
            arguments: widget.ukmId,
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: kColors['primary'],
          padding: EdgeInsets.symmetric(
            horizontal: kPadding['large']!,
            vertical: kPadding['medium']!,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          'Lihat Struktur Lengkap',
          style: TextStyle(
            fontSize: 16,
            color: kColors['white'],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyStateCard(String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(kPadding['large']!),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.info_outline,
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
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// Helper class for registration button configuration
class ButtonConfig {
  final String text;
  final bool enabled;
  final String? message;
  final VoidCallback? onPressed;

  ButtonConfig({
    required this.text,
    required this.enabled,
    this.message,
    this.onPressed,
  });
}