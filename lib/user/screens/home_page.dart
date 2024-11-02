import 'dart:async';
import 'package:flutter/material.dart';
import 'package:latihan/user/util/navbar_function.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController(initialPage: 1000);
  int _currentPage = 1000;
  int _currentIndex = 0;
  Timer? _timer;

  // Dummy data untuk UKM yang diikuti
  final List<Map<String, dynamic>> ukmDiikuti = [
    {
      'nama': 'PMC',
      'deskripsi': 'Perkumpulan Musang Cebol',
      'image': 'assets/2.jpg'
    },
    {
      'nama': 'PP',
      'deskripsi': 'Persatuan Pecinta Panu',
      'image': 'assets/2.jpg'
    },
    {
      'nama': 'PMBF',
      'deskripsi': 'Perkumpulan Mancing Bareng Feses',
      'image': 'assets/2.jpg'
    },
  ];

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
      _currentPage++;
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SIGMA - Mahasiswa',
            style: TextStyle(color: const Color.fromARGB(255, 22, 29, 111))),
        backgroundColor: const Color.fromARGB(255, 255, 252, 230),
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              Navigator.pushNamed(context, '/pengumuman');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildImageSlider(),
            SizedBox(height: 20),
            _buildWelcomeSection(),
            SizedBox(height: 20),
            _buildUKMDiikutiList(),
            SizedBox(height: 20),
            _buildUKMRekomendasiSection(),
          ],
        ),
      ),
      bottomNavigationBar:
          buildBottomNavBar(_currentIndex, context, onItemTapped),
    );
  }

  Widget _buildImageSlider() {
    return Stack(
      children: [
        Container(
          height: 200,
          child: PageView.builder(
            controller: _pageController,
            itemBuilder: (context, index) {
              int currentIndex = index % 3;
              return Stack(
                children: [
                  Image.asset(
                    'assets/1.jpg',
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.white.withOpacity(0.5),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        Positioned(
          bottom: 10,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildIndicator(0),
              _buildIndicator(1),
              _buildIndicator(2),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeSection() {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(Icons.school, color: Colors.blue, size: 40),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selamat Datang di SIGMA!',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Jelajahi aktivitas kampus dan bergabunglah dalam berbagai kegiatan seru!',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUKMDiikutiList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'UKM yang Diikuti',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF161D6F),
            ),
          ),
        ),
        SizedBox(height: 10),
        Container(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: ukmDiikuti.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/ukm_detail_registered',
                    arguments: ukmDiikuti[index]['nama'],
                  );
                },
                child: Card(
                  margin: EdgeInsets.only(
                      left: 16, right: index == ukmDiikuti.length - 1 ? 16 : 0),
                  child: Container(
                    width: 200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.vertical(top: Radius.circular(10)),
                            image: DecorationImage(
                              image: AssetImage(ukmDiikuti[index]['image']),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Expanded(  // Tambahkan Expanded di sini
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,  // Tambahkan ini
                              children: [
                                Text(
                                  ukmDiikuti[index]['nama'],
                                  style: TextStyle(
                                    fontSize: 16,  // Kurangi ukuran font
                                    fontWeight: FontWeight.normal,
                                    color: Color(0xFF161D6F),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  ukmDiikuti[index]['deskripsi'],
                                  style: TextStyle(fontSize: 12),  // Kurangi ukuran font
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _navigateToDetail(String namaUKM) {
    Navigator.pushNamed(context, '/ukm_detail', arguments: namaUKM);
  }

  Widget _buildUKMRekomendasiSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'UKM Rekomendasi',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF161D6F)),
          ),
        ),
        SizedBox(height: 10),
        Container(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: ukmDiikuti.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  _navigateToDetail(
                    ukmDiikuti[index]['nama'],
                  );
                },
                child: Card(
                  margin: EdgeInsets.only(
                      left: 16, right: index == ukmDiikuti.length - 1 ? 16 : 0),
                  child: Container(
                    width: 200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                            image: DecorationImage(
                              image: AssetImage(ukmDiikuti[index]['image']),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  ukmDiikuti[index]['nama'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                    color: Color(0xFF161D6F),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  ukmDiikuti[index]['deskripsi'],
                                  style: TextStyle(fontSize: 12),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        // Jangan lupa tambahkan bagian "Lihat Lebih Banyak" di sini
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/ukm_list');
                },
                child: Text(
                  'Lihat Lebih Banyak',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIndicator(int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      height: 8,
      width: _currentPage == index ? 24 : 8,
      decoration: BoxDecoration(
        color: _currentPage == index ? Colors.blue : Colors.grey,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  void onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
      // Mengatur halaman sesuai dengan index yang dipilih
      // Ganti dengan logika navigasi yang sesuai
    });
  }
}
