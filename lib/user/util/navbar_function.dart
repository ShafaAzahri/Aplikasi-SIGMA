import 'package:flutter/material.dart';
import 'package:latihan/user/screens/home_page.dart';
import 'package:latihan/user/screens/profile_page.dart';
import 'package:latihan/user/screens/ukm_list.dart';

void navigateWithAnimation(
    BuildContext context, String routeName, int currentIndex) {
  Navigator.of(context).pushReplacement(PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) {
      return getPageByRoute(routeName);
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
    transitionDuration: Duration(milliseconds: 500),
  ));
}

Widget getPageByRoute(String routeName) {
  switch (routeName) {
    case '/beranda':
      return HomePage();
    case '/ukm_list':
      return ListUKM();
    case '/profile':
      return ProfilePage();
    default:
      return HomePage();
  }
}

Widget buildBottomNavBar(
    int currentIndex, BuildContext context, Function(int) onItemTapped) {
  return BottomNavigationBar(
    currentIndex: currentIndex,
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
        icon: Icon(Icons.person),
        label: 'Profil',
      ),
    ],
    selectedItemColor: const Color.fromARGB(255, 22, 29, 111),
    unselectedItemColor: const Color.fromARGB(255, 22, 29, 111),
    backgroundColor: const Color.fromARGB(255, 255, 252, 230),
    type: BottomNavigationBarType.fixed,
    elevation: 8,
    onTap: (index) {
      // Mengatur navigasi sesuai dengan item yang dipilih
      if (index == 0) {
        navigateWithAnimation(context, '/beranda', index);
      } else if (index == 1) {
        navigateWithAnimation(
            context, '/ukm_list', index); // Animasi untuk ListUKM
      } else if (index == 2) {
        navigateWithAnimation(context, '/profile', index);
      }
      onItemTapped(index); // Panggil callback fungsi jika diperlukan
    },
  );
}
