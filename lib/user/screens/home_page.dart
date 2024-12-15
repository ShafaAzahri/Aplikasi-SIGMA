import 'dart:async';
import 'package:flutter/material.dart';
import 'package:latihan/service/api_url.dart';
import 'package:latihan/user/util/navbar_function.dart';
import 'package:latihan/service/ukm.dart';
import 'package:latihan/models/ukm.dart';
import 'package:latihan/models/timeline_model.dart';
import 'package:latihan/service/timeline_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  final UkmService _ukmService = UkmService();
  final TimelineService _timelineService = TimelineService();
  late Future<List<TimelineModel>> _timelinesFuture;
  Timer? _timer;
  int _currentIndex = 0;
  ValueNotifier<int> _currentPage = ValueNotifier<int>(0);

  // Colors
  static const Color primaryColor = Color(0xFFFFF8DC); // Cream
  static const Color secondaryColor = Color(0xFFDEB887); // BurlyWood
  static const Color accentColor = Color(0xFF8B4513); // Saddle Brown
  static const Color textColor = Color(0xFF4A4A4A); // Dark Gray

  @override
  void initState() {
    super.initState();
    _timelinesFuture = _timelineService.getTimelines();
    _startImageSlider();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        color: accentColor,
        onRefresh: () async {
          setState(() {
            _timelinesFuture = _timelineService.getTimelines();
          });
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTimelineSlider(),
              SizedBox(height: 24),
              _buildWelcomeSection(),
              SizedBox(height: 24),
              _buildUKMDiikutiSection(),
              SizedBox(height: 24),
              _buildUKMRekomendasiSection(),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: primaryColor,
        ),
        child: buildBottomNavBar(_currentIndex, context, _onItemTapped),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: primaryColor,
      title: Text(
        'Beranda',
        style: TextStyle(
          color: accentColor,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        Container(
          margin: EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: secondaryColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: Icon(Icons.notifications_none_rounded, color: accentColor),
            onPressed: () => Navigator.pushNamed(context, '/pengumuman'),
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: secondaryColor, width: 4),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: secondaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.school_rounded,
                  color: accentColor,
                  size: 32,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selamat Datang di SIGMA!',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: accentColor,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Jelajahi aktivitas kampus dan bergabunglah dalam berbagai kegiatan seru!',
                      style: TextStyle(
                        fontSize: 14,
                        color: textColor,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineSlider() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 200,
            child: FutureBuilder<List<TimelineModel>>(
              future: _timelinesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(color: accentColor),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      'Tidak ada timeline tersedia',
                      style: TextStyle(color: textColor),
                    ),
                  );
                }

                return PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) => _currentPage.value = index,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final timeline = snapshot.data![index];
                    return _buildTimelineItem(timeline);
                  },
                );
              },
            ),
          ),
          SizedBox(height: 16),
          ValueListenableBuilder<int>(
            valueListenable: _currentPage,
            builder: (context, currentPage, _) {
              return FutureBuilder<List<TimelineModel>>(
                future: _timelinesFuture,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return SizedBox();
                  return _buildCustomIndicator(
                    currentPage,
                    snapshot.data!.length,
                  );
                },
              );
            },
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(TimelineModel timeline) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              '${AppConfig.assetBaseUrl}/${timeline.imagePath}',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: secondaryColor.withOpacity(0.1),
                child: Icon(Icons.image_not_supported, color: secondaryColor),
              ),
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
              bottom: 16,
              left: 16,
              right: 16,
              child: Text(
                timeline.judulKegiatan,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 1),
                      blurRadius: 3.0,
                      color: Colors.black.withOpacity(0.3),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomIndicator(int currentPage, int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
            (index) => Container(
          width: currentPage == index ? 24 : 8,
          height: 8,
          margin: EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: currentPage == index ? accentColor : secondaryColor.withOpacity(0.3),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 24,
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: accentColor,
            ),
          ),
        ],
      ),
    );
  }

  // Modifikasi method yang ada untuk menggunakan style baru
  Widget _buildUKMDiikutiSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('UKM yang Diikuti'),
        SizedBox(height: 16),
        SizedBox(
          height: 220,
          child: FutureBuilder<List<UkmModel>>(
            future: _ukmService.getUkmDiikuti(),
            builder: _buildUKMList('/ukm_detail_registered'),
          ),
        ),
      ],
    );
  }

  Widget _buildUKMRekomendasiSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('UKM Yang Belum Diikuti'),
        SizedBox(height: 16),
        SizedBox(
          height: 220,
          child: FutureBuilder<List<UkmModel>>(
            future: _ukmService.getUkmRekomendasi(),
            builder: _buildUKMList('/ukm_detail', limit: 3),
          ),
        ),
        _buildLihatLebihBanyak(),
      ],
    );
  }

  Widget _buildUKMCard({
    required UkmModel ukm,
    required int index,
    required int totalItems,
    required String routeName,
  }) {
    return GestureDetector(
      onTap: () {
        final args = {
          'ukmId': ukm.idUkm.toString(),
          'ukmName': ukm.namaUkm,
        };
        Navigator.pushNamed(
          context,
          routeName == '/ukm_detail_registered'
              ? '/ukm_detail_registered'
              : '/ukm_detail',
          arguments: args,
        );
      },
      child: Container(
        width: 160,
        margin: EdgeInsets.only(
          left: 16,
          right: index == totalItems - 1 ? 16 : 8,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              child: Container(
                height: 140,
                color: secondaryColor.withOpacity(0.1),
                child: Center(
                  child: Image.network(
                    '${AppConfig.assetBaseUrl}/${ukm.logo}',
                    fit: BoxFit.fill,
                    width: 110,
                    errorBuilder: (_, __, ___) => Icon(
                      Icons.image_not_supported,
                      color: secondaryColor.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ukm.namaUkm,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: accentColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    ukm.deskripsi,
                    style: TextStyle(
                      fontSize: 12,
                      color: textColor,
                      height: 1.5,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLihatLebihBanyak() {
    return Padding(
        padding: const EdgeInsets.only(right: 16, top: 8),
    child: Align(
    alignment: Alignment.centerRight,
    child: TextButton(
    onPressed: () => Navigator.pushReplacementNamed(context, '/ukm_list'),
    style: TextButton.styleFrom(
    backgroundColor: secondaryColor.withOpacity(0.1),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Lihat Lebih Banyak',
            style: TextStyle(
              color: accentColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 4),
          Icon(
            Icons.arrow_forward_rounded,
            size: 16,
            color: accentColor,
          ),
        ],
      ),
    ),
    ),
    );
  }

  Widget Function(BuildContext, AsyncSnapshot<List<UkmModel>>) _buildUKMList(
      String routeName, {
        int? limit,
      }) {
    return (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator(color: accentColor));
      }

      if (snapshot.hasError) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, color: Colors.red, size: 48),
                SizedBox(height: 16),
                Text(
                  'Terjadi kesalahan: ${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: textColor),
                ),
              ],
            ),
          ),
        );
      }

      var ukms = snapshot.data ?? [];
      if (limit != null) {
        ukms = ukms.take(limit).toList();
      }

      if (routeName == '/ukm_detail_registered' && ukms.isEmpty) {
        return Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: secondaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: secondaryColor.withOpacity(0.3),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.group_add_rounded,
                  size: 48,
                  color: accentColor.withOpacity(0.5),
                ),
                SizedBox(height: 12),
                Text(
                  'Anda belum mengikuti UKM manapun',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: accentColor,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Silahkan gabung UKM yang anda inginkan',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
        );
      }

      return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: ukms.length,
        itemBuilder: (context, index) => _buildUKMCard(
          ukm: ukms[index],
          index: index,
          totalItems: ukms.length,
          routeName: routeName,
        ),
      );
    };
  }

  void _startImageSlider() {
    _timer = Timer.periodic(Duration(seconds: 5), (Timer timer) async {
      final timelines = await _timelinesFuture;
      if (timelines.isEmpty) return;

      if (_currentPage.value < timelines.length - 1) {
        _currentPage.value++;
      } else {
        _currentPage.value = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage.value,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    _currentPage.dispose();
    super.dispose();
  }
}