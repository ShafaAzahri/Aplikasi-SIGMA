import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:latihan/user/screens/pendaftaran.dart';

class UKMDetail_notRegister extends StatefulWidget {
  @override
  _UKMDetailState createState() => _UKMDetailState();
}

class _UKMDetailState extends State<UKMDetail_notRegister> {
  bool showVisi = true;
  bool showStruktur = true;

  // Dummy data untuk galeri
  final List<Map<String, String>> galleryItems = [
    {"image": "assets/mancing.jpeg", "description": "Kegiatan Mancing Perkara"},
    {
      "image": "assets/boker.jpg",
      "description":
          "Kegiatan membuang kuning kuning di perut ahdiashdaiudhaidhaiduahisduahsiduahiudahiduahiduasd"
    },
    {
      "image": "assets/1.jpg",
      "description":
          "Kegiatan membuang kuning kuning di perut ahdiashdaiudhaidhaiduahisduahsiduahiudahiduahiduasd"
    },
  ];

  @override
  Widget build(BuildContext context) {
    final String ukmName = ModalRoute.of(context)?.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Text(ukmName),
        backgroundColor: Color.fromARGB(255, 247, 236, 197),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: buildCoverImage(context)),
          SliverToBoxAdapter(child: SizedBox(height: 16)),
          SliverToBoxAdapter(
            child: Container(
              height: 50,
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => showVisi = true),
                      child: Container(
                        color: showVisi ? Color(0xFFFFF5E6) : Colors.white,
                        child: Center(
                          child: Text('Visi',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => showVisi = false),
                      child: Container(
                        color: !showVisi ? Color(0xFFFFF5E6) : Colors.white,
                        child: Center(
                          child: Text('Misi',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              color: Color(0xFFFFF5E6),
              padding: EdgeInsets.all(16),
              child: showVisi ? _buildVisiContent() : _buildMisiContent(),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 50,
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => showStruktur = true),
                      child: Container(
                        color: showStruktur ? Color(0xFFFFF5E6) : Colors.white,
                        child: Center(
                          child: Text('Struktur Organisasi',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => showStruktur = false),
                      child: Container(
                        color: !showStruktur ? Color(0xFFFFF5E6) : Colors.white,
                        child: Center(
                          child: Text('Galeri',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              color: Color(0xFFFFF5E6),
              padding: EdgeInsets.all(16),
              child:
                  showStruktur ? buildStructureOrganization() : buildGallery(),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 16)),
          // Space between sections
          SliverToBoxAdapter(child: buildRegistrationSection()),
          // New registration section
        ],
      ),
    );
  }

  Widget buildCoverImage(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double maxWidth = constraints.maxWidth;
        double maxHeight = maxWidth * 8 / 19;

        return Container(
          constraints: BoxConstraints(
            maxHeight: maxHeight,
            maxWidth: maxWidth,
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/bem_header.png',
                fit: BoxFit.cover,
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.white.withOpacity(0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildGallery() {
    return CarouselSlider(
      options: CarouselOptions(
        height: 300.0,
        autoPlay: true,
        enlargeCenterPage: true,
        aspectRatio: 16 / 9,
        autoPlayCurve: Curves.fastOutSlowIn,
        enableInfiniteScroll: true,
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        viewportFraction: 0.85,
      ),
      items: galleryItems.map((item) {
        return Builder(
          builder: (BuildContext context) {
            return Stack(
              children: [
                Image.asset(
                  item['image']!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
                // Gradient overlay
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.5),
                          Colors.transparent,
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    color: Colors.black.withOpacity(0.5),
                    child: Text(
                      item['description']!,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildVisiContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '"Mewujudkan KBM polines yang solid dan dinamis demi terciptanya sinergisitas mahasiswa"',
          style: TextStyle(
            fontStyle: FontStyle.italic,
            fontSize: 16,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20),
        Text(
          'Solid /so·lid/ a 1 kuat; kukuh; berbobot 2 padat; berisi. '
          'Organisasi yang solid adalah organisasi yang memiliki kesepahaman dalam pemikiran, keterikatan, perasaan, dan tindakan nyata untuk mencapai tujuan. '
          'Hal ini diperlukan dapat terwujud ketika memiliki tim kerja yang mengerti dan disiplin pada tanggung jawabnya masing-masing...',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Dinamis /di·na·mis/ a penuh semangat dan tenaga sehingga cepat bergerak dan mudah menyesuaikan diri dengan keadaan...',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Sinergisitas /si·ner·gi·si·tas/ n 1 kegiatan atau operasi gabungan; 2 sinergisme...',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildMisiContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '1. Meningkatkan kualitas dan kuantitas mahasiswa dalam berorganisasi.',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 10),
        Text(
          '2. Mengoptimalkan fungsi advokasi kemahasiswaan.',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 10),
        Text(
          '3. Memperkuat hubungan internal dan eksternal KBM polines.',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 10),
        Text(
          '4. Meningkatkan prestasi dan kreativitas mahasiswa.',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget buildStructureOrganization() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    // Menambahkan gambar dari aset
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                              'assets/1.jpg'), // Ganti dengan nama gambar Anda
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(
                            8), // Untuk memberikan sudut yang melengkung
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Pais Akmal',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.indigo,
                      ),
                    ),
                    Text('Presiden Mahasiswa'),
                    Text('Tahun Periode 2025/2026'),
                  ],
                ),
              ),
              SizedBox(width: 16), // Space between columns
              Expanded(
                child: Column(
                  children: [
                    // Menambahkan gambar dari aset
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                              'assets/boker.jpg'), // Ganti dengan nama gambar Anda
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(
                            8), // Untuk memberikan sudut yang melengkung
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Shafa',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.indigo,
                      ),
                    ),
                    Text('Wakil Presiden Mahasiswa'),
                    Text('Tahun Periode 2025/2026'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildRegistrationSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Image.asset(
              'assets/registration_image.png',
              // Replace with your actual image path
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 16), // Space between image and text
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
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegistrationPage()),
                    );
                  },
                  child: Text('Daftar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF1E1D67), // Button color
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    textStyle: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
