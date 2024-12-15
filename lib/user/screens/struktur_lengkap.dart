import 'package:flutter/material.dart';
import 'package:latihan/service/api_url.dart';
import 'package:latihan/service/ukm.dart';
import 'package:latihan/models/struktur_lengkap.dart';

class StrukturPage extends StatelessWidget {
  final String ukmId;
  final UkmService _ukmService = UkmService();

  StrukturPage({Key? key, required this.ukmId}) : super(key: key);

  String _getPeriode(List<StrukturOrganisasiLengkap> struktur) {
    if (struktur.isEmpty) return '';
    return '${struktur.first.tahunMulai}/${struktur.first.tahunSelesai}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<StrukturLengkapResponse>(
        future: _ukmService.getStrukturLengkap(ukmId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return Center(child: Text('Data tidak ditemukan'));
          }

          final data = snapshot.data!;
          
          // Kelompokkan struktur berdasarkan divisi
          final Map<String, List<StrukturOrganisasiLengkap>> strukturByDivisi = {};
          
          for (var struktur in data.strukturOrganisasi) {
            if (!strukturByDivisi.containsKey(struktur.namaDivisi)) {
              strukturByDivisi[struktur.namaDivisi] = [];
            }
            strukturByDivisi[struktur.namaDivisi]!.add(struktur);
          }

          // Urutkan anggota dalam setiap divisi berdasarkan hierarki jabatan
          strukturByDivisi.forEach((key, value) {
            value.sort((a, b) => a.jabatanHierarki.compareTo(b.jabatanHierarki));
          });

          final periode = _getPeriode(data.strukturOrganisasi);

          return CustomScrollView(
            slivers: [
              _buildAppBar(data.ukmDetail),
              SliverToBoxAdapter(
                child: _buildHeader(data.ukmDetail, periode),
              ),
              // Pengurus Inti dengan layout khusus
              if (strukturByDivisi.containsKey('inti'))
                SliverToBoxAdapter(
                  child: _buildIntiSection(strukturByDivisi['inti']!),
                ),
              // Divider antara pengurus inti dan divisi
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: Divider(thickness: 1),
                ),
              ),
              // Divisi-divisi lain
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    ...strukturByDivisi.entries
                        .where((entry) => entry.key != 'inti')
                        .map((entry) => _buildDivisiSection(entry.key, entry.value)),
                  ]),
                ),
              ),
              SliverPadding(padding: EdgeInsets.only(bottom: 24)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAppBar(UkmDetailStruktur ukm) {
    return SliverAppBar(
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      centerTitle: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          ukm.namaUkm,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF161D6F),
                Color(0xFF161D6F).withOpacity(0.8),
              ],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 40),
                Icon(
                  Icons.people_alt_rounded,
                  size: 50,
                  color: Colors.white.withOpacity(0.8),
                ),
                SizedBox(height: 8),
                Text(
                  'Struktur Organisasi',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(UkmDetailStruktur ukm, String periode) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                'Periode Kepengurusan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF161D6F),
                ),
              ),
              SizedBox(height: 8),
              Text(
                periode,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIntiSection(List<StrukturOrganisasiLengkap> anggotaInti) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          SizedBox(height: 24),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: anggotaInti.length,
            itemBuilder: (context, index) {
              final anggota = anggotaInti[index];
              return Container(
                margin: EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Color(0xFF161D6F),
                          width: 3,
                        ),
                      ),
                      child: ClipOval(
                        child: Image.network(
                          '${AppConfig.assetBaseUrl}/${anggota.fotoPath}',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.person, size: 50, color: Colors.grey),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            anggota.namaJabatan,
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF161D6F),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            anggota.namaLengkap,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDivisiSection(String title, List<StrukturOrganisasiLengkap> anggota) {
      return Container(
        margin: EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 16),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Color(0xFF161D6F).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Color(0xFF161D6F).withOpacity(0.2),
                ),
              ),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF161D6F),
                ),
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.8,
              ),
              itemCount: anggota.length,
              itemBuilder: (context, index) {
                final anggotaDivisi = anggota[index];  // Mengubah nama variabel untuk menghindari konflik
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                          child: Image.network(
                            '${AppConfig.assetBaseUrl}/${anggotaDivisi.fotoPath}',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (context, error, stackTrace) =>
                                Icon(Icons.person, size: 50, color: Colors.grey),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              anggotaDivisi.namaJabatan,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4),
                            Text(
                              anggotaDivisi.namaLengkap,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      );
    }
  }