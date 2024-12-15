import 'package:flutter/material.dart';
import 'package:latihan/user/screens/home_page.dart';
import 'package:latihan/user/screens/profile_page.dart';
import 'package:latihan/user/screens/ukm_list.dart';
import 'package:latihan/user/screens/login_page.dart';
import 'package:latihan/user/screens/Ukm_Detail_notRegister.dart';
import 'package:latihan/user/screens/pengumaman.dart';
import 'package:latihan/user/screens/ukm_detail_registered.dart';
import 'package:latihan/service/auth_check.dart';
import 'package:latihan/user/screens/edit_profile_page.dart';
import 'package:latihan/user/screens/edit_password_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:latihan/user/screens/pendaftaran.dart';
import 'package:latihan/user/screens/pendaftaran_2.dart';
import 'package:latihan/user/screens/pendaftaran_3.dart';
import 'package:latihan/user/screens/struktur_lengkap.dart';
import 'package:latihan/user/screens/pemberitahuan.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Check auth saat startup
  final isLoggedIn = await AuthCheck.isLoggedIn();
  if (!isLoggedIn) {
    // Clear preferences jika tidak terautentikasi
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print('Cleared preferences - not authenticated');
  }
  
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
      home: FutureBuilder<bool>(
        future: AuthCheck.isLoggedIn(),
        builder: (context, snapshot) {
          print('Auth check snapshot: ${snapshot.data}');
          print('Connection state: ${snapshot.connectionState}');
          
          if (snapshot.hasError) {
            print('Error checking login: ${snapshot.error}');
            return LoginPage();
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return snapshot.data == true ? HomePage() : LoginPage();  
        },
      ),
      routes: {
        '/login': (context) => LoginPage(),
        '/beranda': (context) => HomePage(),
        '/ukm_list': (context) => ListUKM(),
        '/profile': (context) => ProfilePage(),
        '/pengumuman': (context) => PengumumanPage(),
        '/edit_profile': (context) => EditProfilePage(),
        '/edit_password': (context) => EditPasswordPage(),

        '/registration_status': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return RegistrationStatusPage(
            idUkm: args['idUkm'],
            ukmName: args['ukmName'],
          );
        },
        
        // Route untuk pendaftaran tahap 1
        '/pendaftaran': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
          if (args != null) {
            return RegistrationPage(
              ukmId: args['ukmId'].toString(),
              ukmName: args['ukmName'].toString(),
              periodId: args['periodId'] as int,
            );
          }
          return const Scaffold(
            body: Center(child: Text('Invalid arguments for registration')),
          );
        },

        // Route untuk pendaftaran tahap 2
        '/pendaftaran_2': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
          if (args != null) {
            return RegistrationStep2Page(
              ukmId: args['ukmId'].toString(),
              ukmName: args['ukmName'].toString(),
            );
          }
          return const Scaffold(
            body: Center(child: Text('Invalid arguments for registration step 2')),
          );
        },

        // Route untuk pendaftaran tahap 3
        '/pendaftaran_3': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
          if (args != null) {
            return RegistrationStep3Page(
              ukmId: args['ukmId'].toString(),
              ukmName: args['ukmName'].toString(),
            );
          }
          return const Scaffold(
            body: Center(child: Text('Invalid arguments for registration step 3')),
          );
        },

        // Route untuk detail UKM yang sudah terdaftar
        '/ukm_detail_registered': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
          if (args != null) {
            return UKMDetailRegisteredPage(
              ukmId: args['ukmId'].toString(),
              ukmName: args['ukmName'].toString(),
            );
          }
          return const Scaffold(
            body: Center(child: Text('Invalid arguments for registered UKM detail')),
          );
        },

        // Route untuk detail UKM yang belum terdaftar
        '/ukm_detail': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
          if (args != null) {
            return UKMDetailNotRegister(
              ukmId: args['ukmId'].toString(),
              ukmName: args['ukmName'].toString(),
            );
          }
          return const Scaffold(
            body: Center(child: Text('Invalid arguments for UKM detail')),
          );
        },

        // Route untuk struktur lengkap
        '/struktur': (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          if (args is String) {
            return StrukturPage(ukmId: args);
          }
          return const Scaffold(
            body: Center(child: Text('Invalid arguments for struktur page')),
          );
        },
      },
    );
  }
}