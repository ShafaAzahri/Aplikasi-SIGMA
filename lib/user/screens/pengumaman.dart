import 'package:flutter/material.dart';

class PengumumanPage extends StatelessWidget {
  // Dummy data untuk pengumuman
  final List<Map<String, String?>> pengumumanList = [
    {'judul': 'Pendaftaran UKM Dibuka!', 'isi': 'Daftar sekarang dan jadilah bagian dari UKM kami!'},
    {'judul': 'Workshop Seni Rupa', 'isi': 'Ikuti workshop seni rupa pada tanggal 20 Oktober!'},
    {'judul': 'Kompetisi Teknologi', 'isi': 'Daftar kompetisi teknologi sebelum 25 Oktober!'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pengumuman'),
      ),
      body: ListView.builder(
        itemCount: pengumumanList.length,
        itemBuilder: (context, index) {
          final judul = pengumumanList[index]['judul'] ?? 'Judul Tidak Tersedia'; // Nilai default jika null
          final isi = pengumumanList[index]['isi'] ?? 'Isi Tidak Tersedia'; // Nilai default jika null

          return Card(
            margin: EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    judul,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(isi),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
