import 'package:dazle/app/pages/connection/connection_view.dart';
import 'package:dazle/app/pages/home/home_view.dart';
import 'package:dazle/app/pages/listing/listing_view.dart';
import 'package:dazle/app/pages/main/components/triangle_painter.dart';
import 'package:dazle/app/pages/message/message_view.dart';
import 'package:dazle/app/pages/profile/profile_view.dart';
import 'package:dazle/app/utils/app.dart';
import 'package:dazle/domain/entities/user.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  static const String id = 'main_page';
  
  const MainPage({ Key key }) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  User user;
  int _currentIndex = 0;

  getCurrentUser() async {
    User _user = await App.getUser();

    if (_user != null){
      user = _user;
    }
  }

  List<Widget> _navs() => [
    HomePage(user: user),
    ConnectionPage(user: user),
    ListingPage(user: user),
    MessagePage(user: user),
    ProfilePage(user: user),
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
  void initState() {
    super.initState();
    getCurrentUser();
  }


  @override
  Widget build(BuildContext context) {
    final List<Widget> navs = _navs();

    return Scaffold(
      body: navs[_currentIndex],
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