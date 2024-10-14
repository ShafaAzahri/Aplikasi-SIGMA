import 'package:flutter/material.dart';
import 'package:latihan/user/util/navbar_function.dart';

class ListUKM extends StatefulWidget {
  @override
  _ListUKMState createState() => _ListUKMState();
}

class _ListUKMState extends State<ListUKM> {
  final List<Map<String, String>> ukms = [
    {'name': 'PMC', 'fullName': 'Perkumpulan Musang Cebol', 'image': 'assets/1.jpg'},
    {'name': 'PP', 'fullName': 'Persatuan Pecinta Panu', 'image': 'assets/1.jpg'},
    {'name': 'PMBF', 'fullName': 'Perkumpulan Mancing Bareng Feses', 'image': 'assets/1.jpg'},
    {'name': 'KMPP', 'fullName': 'Komunitas Mahasiswa Pencinta Paha', 'image': 'assets/1.jpg'},
    {'name': 'PACO', 'fullName': 'Perkumpulan Anak Cinta Otot', 'image': 'assets/1.jpg'},
    {'name': 'PKTK', 'fullName': 'Politeknik Kaki Tiga Klub', 'image': 'assets/1.jpg'},
    {'name': 'PFK', 'fullName': 'Polban Fans Kentut', 'image': 'assets/1.jpg'},
    {'name': 'PMK', 'fullName': 'Persekutuan Mahasiswa Kolor', 'image': 'assets/1.jpg'}
  ];

  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        navigateWithAnimation(context, '/home', index);
        break;
      case 1:
      // Sudah di halaman UKM
        break;
      case 2:
        navigateWithAnimation(context, '/profile', index);
        break;
    }
  }

  void _navigateToDetail(String ukmName) {
    Navigator.pushNamed(context, '/ukm_detail', arguments: ukmName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar UKM'),
        automaticallyImplyLeading: false,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          int crossAxisCount;
          if (constraints.maxWidth > 1200) {
            crossAxisCount = 6;
          } else if (constraints.maxWidth > 900) {
            crossAxisCount = 5;
          } else if (constraints.maxWidth > 600) {
            crossAxisCount = 4;
          } else if (constraints.maxWidth > 400) {
            crossAxisCount = 3;
          } else {
            crossAxisCount = 2;
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.9,
              ),
              itemCount: ukms.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _navigateToDetail(ukms[index]['name']!),
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                              child: Image.asset(
                                ukms[index]['image']!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Center(
                                    child: Icon(
                                      Icons.error,
                                      size: 50,
                                      color: Colors.grey[400],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ukms[index]['name']!,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 4),
                              Text(
                                ukms[index]['fullName']!,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
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
              },
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'UKM',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
