import 'package:flutter/material.dart';
import 'package:latihan/user/screens/home_page.dart';
import 'package:latihan/user/screens/profile_page.dart';
import 'package:latihan/user/screens/ukm_list.dart';
import 'package:latihan/user/screens/login_page.dart';
import 'package:latihan/user/screens/Ukm_Detail_notRegister.dart';
import 'package:latihan/user/screens/pengumaman.dart';
import 'package:latihan/user/screens/ukm_detail_registered.dart'; // Pastikan ini diimpor

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
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/beranda': (context) => HomePage(),
        '/ukm_list': (context) => ListUKM(),
        '/profile': (context) => ProfilePage(),
        '/ukm_detail': (context) => UKMDetail_notRegister(),
        '/pengumuman': (context) => PengumumanPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/ukm_detail_registered') {
          final args = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) {
              return UKMDetailRegisteredPage(ukmName: args);
            },
          );
        }
        return null;
      },
    );
  }
}
