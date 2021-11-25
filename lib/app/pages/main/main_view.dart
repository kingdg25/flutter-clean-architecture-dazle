import 'package:dazle/app/pages/connection/connection_view.dart';
import 'package:dazle/app/pages/home/home_view.dart';
import 'package:dazle/app/pages/listing/listing_view.dart';
import 'package:dazle/app/pages/main/components/triangle_painter.dart';
import 'package:dazle/app/pages/main/main_controller.dart';
import 'package:dazle/app/pages/message/message_view.dart';
import 'package:dazle/app/pages/profile/profile_view.dart';
import 'package:dazle/data/repositories/data_home_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';



class MainPage extends View {
  static const String id = 'main_page';

  MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}


class _MainPageState extends ViewState<MainPage, MainController> {
  _MainPageState() : super(MainController(DataHomeRepository()));

  int _currentIndex = 0;
  final List<Widget> _navs = [
    HomePage(),
    ConnectionPage(),
    ListingPage(),
    MessagePage(),
    ProfilePage(),
  ];

  customBottomNavigationBarItem({
    @required String asset,
    @required String label
  }) {
    return BottomNavigationBarItem(
      activeIcon: CustomPaint(
        painter: TrianglePainter(),
        child: Container(
          child: Image.asset(
            asset,
            height: 30,
          ),
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
  Widget get view {
    return Scaffold(
      body: _navs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _currentIndex,
        items: [
          customBottomNavigationBarItem(
            asset: 'assets/icons/tab_bar/home.png',
            label: 'home',
          ),

          customBottomNavigationBarItem(
            asset: 'assets/icons/tab_bar/connection.png',
            label: 'connection',
          ),

          customBottomNavigationBarItem(
            asset: 'assets/icons/tab_bar/listing.png',
            label: 'listing',
          ),

          customBottomNavigationBarItem(
            asset: 'assets/icons/tab_bar/message.png',
            label: 'message',
          ),

          customBottomNavigationBarItem(
            asset: 'assets/icons/tab_bar/profile.png',
            label: 'profile',
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}