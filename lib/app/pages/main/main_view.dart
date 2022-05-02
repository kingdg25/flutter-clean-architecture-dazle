import 'package:dazle/app/pages/home/home_view.dart';
import 'package:dazle/app/pages/listing/listing_view.dart';
// import 'package:dazle/app/pages/main/components/triangle_painter.dart';
import 'package:dazle/app/pages/profile/profile_view.dart';
import 'package:flutter/material.dart';

import '../connection/connection_view.dart';

class MainPage extends StatefulWidget {
  static const String id = 'main_page';

  final String backCurrentIndex;
  final List<Map<String, dynamic>> _navs = [
    {
      "HomePage": HomePage(),
      "items": [
        {
          "icon": 'assets/icons/tab_bar/clear_home.png',
          "label": "Home",
          "asset": "assets/icons/tab_bar/home.png"
        }
      ]
    },
    // {
    //   "ConnectionPage": ConnectionPage(),
    //   "items": [
    //     {
    //       "icon": 'assets/icons/tab_bar/clear_connection.png',
    //       "label": "Connection",
    //       "asset": "assets/icons/tab_bar/connection.png"
    //     }
    //   ]
    // },
    {
      "ListingPage": ListingPage(),
      "items": [
        {
          "icon": 'assets/icons/tab_bar/clear_listing.png',
          "label": "New listing",
          "asset": "assets/icons/tab_bar/listing.png"
        }
      ]
    },
    // {
    //   "MessagePage": MessagePage(),
    //   "items": [
    //     {
    //       "icon": 'assets/icons/tab_bar/clear_message.png',
    //       "label": "message",
    //       "asset": "assets/icons/tab_bar/message.png"
    //     }
    //   ]
    // },
    {
      "ProfilePage": ProfilePage(),
      "items": [
        {
          "icon": 'assets/icons/tab_bar/clear_profile.png',
          "label": "profile",
          "asset": "assets/icons/tab_bar/profile.png"
        }
      ]
    },
  ];

  MainPage({this.backCurrentIndex = "HomePage", Key? key}) : super(key: key);

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
          for (int indexPage = 0; indexPage < _navs.length; indexPage++) ...[
            ...(_navs[indexPage]['items'] as List<Map<String, String>>)
                .map(
                  (item) => BottomNavigationBarItem(
                    activeIcon: CustomPaint(
                        // painter: TrianglePainter(),
                        child: Container(
                            child: Image.asset(item['asset']!, height: 30))),
                    icon: Image.asset(item['icon']!, height: 30),
                    label: item['label'],
                  ),
                )
                .toList()
          ]
        ],
      ),
    );
  }
}
