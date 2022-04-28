import 'package:dazle/app/pages/home/home_view.dart';
import 'package:dazle/app/pages/listing/listing_view.dart';
// import 'package:dazle/app/pages/main/components/triangle_painter.dart';
import 'package:dazle/app/pages/profile/profile_view.dart';
import 'package:flutter/material.dart';

import '../connection/connection_view.dart';

class MainPage extends StatefulWidget {
  static const String id = 'main_page';

  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  final List<Widget> _navs = [
    HomePage(),
    // ConnectionPage(),
    ListingPage(),
    //MessagePage(),
    ProfilePage(),
  ];

  customBottomNavigationBarItem({
    required String asset,
    required String label,
    required String icons,
  }) {
    print(icons);
    return BottomNavigationBarItem(
      activeIcon: Container(
        child: Image.asset(
          icons,
          height: 30,
        ),
      ),
      icon: Image.asset(
        asset,
        height: 30,
      ),
      label: label,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _navs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color.fromRGBO(51, 212, 157, 1),
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          print(index);
        },
        items: [
          //0
          customBottomNavigationBarItem(
            asset: 'assets/icons/tab_bar/clear_home.png',
            label: 'Home',
            icons: 'assets/icons/tab_bar/home.png',
          ),
          // customBottomNavigationBarItem(
          //   asset: 'assets/icons/tab_bar/clear_connection.png',
          //   label: 'Connections',
          // icons: 'assets/icons/tab_bar/connection.png',
          // ),
          customBottomNavigationBarItem(
            asset: 'assets/icons/tab_bar/clear_listing.png',
            label: 'New Listing',
            icons: 'assets/icons/tab_bar/listing.png',
          ),
          // customBottomNavigationBarItem(
          //   asset: 'assets/icons/tab_bar/clear_message.png',
          //   label: 'Message',
          //   icon: 'assets/icons/tab_bar/message.png',
          // ),
          customBottomNavigationBarItem(
            asset: 'assets/icons/tab_bar/clear_profile.png',
            label: 'Profile',
            icons: 'assets/icons/tab_bar/profile.png',
          ),
        ],
      ),
    );
  }
}
