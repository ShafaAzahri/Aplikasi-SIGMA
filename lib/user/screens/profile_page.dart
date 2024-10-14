import 'package:flutter/material.dart';
import 'package:latihan/user/util/navbar_function.dart';

class ProfilePage extends StatelessWidget {

  @override

  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: Text('Profil'),

      ),

      body: SingleChildScrollView(

        child: Column(

          children: [

            _buildProfileHeader(),

            _buildPersonalInfo(),

            _buildUKMList(),

            SizedBox(height: 20),

            _buildLogoutButton(context),

            SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: buildBottomNavBar(2, context, (index) {
      }),
    );

  }


  Widget _buildLogoutButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).pushReplacementNamed('/login');
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),

      child: Text('Logout',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/1.jpg'),
          ),
          SizedBox(height: 16),
          Text(
            'Furina Hutapea',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text('433.23.2.23'),
        ],
      ),
    );
  }

  Widget _buildPersonalInfo() {
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Jurusan', 'Teknik Elektro'),
            _buildInfoRow('Program Studi', 'D4 Teknologi Rekayasa Komputer'),
            _buildInfoRow('Kelas', 'TI-2C'),
            _buildInfoRow('Jenis Kelamin', 'Laki-laki'),
            _buildInfoRow('No. WhatsApp', '081234567890'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildUKMList() {

    List<Map<String, String>> ukms = [

      {

        'name': 'Pengembangan Pengetahuan',

        'period': '2023-2024',

        'logo': 'assets/pp.png',

      },

      {

        'name': 'Politeknik Computer Club',

        'period': '2023-2024',

        'logo': 'assets/logo-pcc.png',

      },

    ];


    return Card(

      margin: EdgeInsets.all(16),

      child: Padding(

        padding: EdgeInsets.all(16),

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            Text('Daftar UKM', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            SizedBox(height: 16),

            ListView.builder(

              shrinkWrap: true,

              physics: NeverScrollableScrollPhysics(),

              itemCount: ukms.length,

              itemBuilder: (context, index) {

                return ListTile(

                  leading: CircleAvatar(

                    backgroundImage: AssetImage(ukms[index]['logo']!),

                  ),

                  title: Text(ukms[index]['name']!),

                  subtitle: Text(ukms[index]['period']!),

                );

              },

            ),

          ],

        ),

      ),

    );

  }
}