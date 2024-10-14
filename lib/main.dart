import 'package:flutter/material.dart';
import 'package:latihan/user/screens/home_page.dart';
import 'package:latihan/user/screens/profile_page.dart';
import 'package:latihan/user/screens/ukm_list.dart';
import 'package:latihan/user/screens/login_page.dart';
import 'package:latihan/user/screens/Ukm_Detail_notRegister.dart';
import 'package:latihan/user/screens/pengumaman.dart';
import 'package:latihan/user/screens/ukm_detail_registered.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SIGMA',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/login', // Menggunakan penamaan rute yang lebih deskriptif
      routes: {
        '/login' : (context) => LoginPage(),
        '/beranda': (context) => HomePage(),
        '/ukm_list': (context) => ListUKM(),
        '/profile': (context) => ProfilePage(),
        '/ukm_detail': (context) => UKMDetail(), // Halaman detail UKM
        '/pengumuman' : (context) => PengumumanPage(),
        '/menu_ukm_terdaftar' : (context) => UKMDetailTerdaftar(),
      },
    );
  }
}
