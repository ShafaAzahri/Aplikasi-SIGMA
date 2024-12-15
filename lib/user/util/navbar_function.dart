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
      const begin = Offset(0.0, 0.05);
      const end = Offset.zero;
      const curve = Curves.easeOutCubic;

      var tween = Tween(begin: begin, end: end).chain(
        CurveTween(curve: curve),
      );

      var offsetAnimation = animation.drive(tween);
      var fadeAnimation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: curve,
      ));

      return SlideTransition(
        position: offsetAnimation,
        child: FadeTransition(
          opacity: fadeAnimation,
          child: child,
        ),
      );
    },
    transitionDuration: Duration(milliseconds: 300),
    reverseTransitionDuration: Duration(milliseconds: 300),
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
  return Container(
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 255, 252, 230),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: Offset(0, -3),
        ),
      ],
    ),
    child: BottomNavigationBar(
      currentIndex: currentIndex,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: AnimatedSwitcher(
            duration: Duration(milliseconds: 200),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(
                scale: animation,
                child: child,
              );
            },
            child: Icon(
              currentIndex == 0 ? Icons.home : Icons.home_outlined,
              key: ValueKey<bool>(currentIndex == 0),
            ),
          ),
          label: 'Beranda',
        ),
        BottomNavigationBarItem(
          icon: AnimatedSwitcher(
            duration: Duration(milliseconds: 200),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(
                scale: animation,
                child: child,
              );
            },
            child: Icon(
              currentIndex == 1 ? Icons.group : Icons.group_outlined,
              key: ValueKey<bool>(currentIndex == 1),
            ),
          ),
          label: 'UKM',
        ),
        BottomNavigationBarItem(
          icon: AnimatedSwitcher(
            duration: Duration(milliseconds: 200),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(
                scale: animation,
                child: child,
              );
            },
            child: Icon(
              currentIndex == 2 ? Icons.person : Icons.person_outlined,
              key: ValueKey<bool>(currentIndex == 2),
            ),
          ),
          label: 'Profil',
        ),
      ],
      selectedItemColor: const Color.fromARGB(255, 22, 29, 111),
      unselectedItemColor: const Color.fromARGB(255, 22, 29, 111).withOpacity(0.5),
      backgroundColor: Colors.transparent,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
      unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
      onTap: (index) {
        if (index == currentIndex) return;

        final routes = {
          0: '/beranda',
          1: '/ukm_list',
          2: '/profile',
        };

        if (routes.containsKey(index)) {
          navigateWithAnimation(context, routes[index]!, index);
          onItemTapped(index);
        }
      },
    ),
  );
}