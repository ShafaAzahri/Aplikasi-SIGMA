import 'package:flutter/material.dart';

class UKMDetailTerdaftar extends StatelessWidget {
  final Map<String, dynamic> ukmDetail = {
    'nama': 'PMC - Perkumpulan Musang Cebol',
    'deskripsi':
    'Perkumpulan Musang Cebol adalah UKM yang bergerak dalam pelestarian musang cebol. Kami memiliki berbagai kegiatan, mulai dari edukasi hingga penangkaran musang.',
    'agenda': [
      {'judul': 'Pelatihan Penangkaran Musang', 'tanggal': '20 Oktober 2024'},
      {'judul': 'Workshop Lingkungan', 'tanggal': '5 November 2024'},
    ],
    'image': 'assets/1.jpg',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail UKM'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildHeaderImage(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildUKMTitle(),
                  SizedBox(height: 16),
                  _buildUKMDescription(),
                  SizedBox(height: 24),
                  _buildAgendaSection(),
                  SizedBox(height: 16),
                  _buildJoinButton(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderImage() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ukmDetail['image']),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildUKMTitle() {
    return Text(
      ukmDetail['nama'],
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.blueAccent,
      ),
    );
  }

  Widget _buildUKMDescription() {
    return Text(
      ukmDetail['deskripsi'],
      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
    );
  }

  Widget _buildAgendaSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Agenda Kegiatan',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: ukmDetail['agenda'].length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 3,
              margin: EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: Icon(Icons.event, color: Colors.blueAccent),
                title: Text(ukmDetail['agenda'][index]['judul']),
                subtitle: Text(ukmDetail['agenda'][index]['tanggal']),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildJoinButton(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Fitur Gabung belum tersedia')),
          );
        },
        icon: Icon(Icons.group_add),
        label: Text('Gabung UKM'),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          backgroundColor: Colors.blueAccent,
        ),
      ),
    );
  }
}
