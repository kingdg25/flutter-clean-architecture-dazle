import 'package:dazle/app/pages/home/home_view.dart';
import 'package:dazle/app/pages/listing/listing_view.dart';
import 'package:dazle/app/pages/profile/profile_view.dart';
import 'package:flutter/material.dart';

import '../connection/connection_view.dart';
import '../message/message_view.dart';

class MainPage extends StatefulWidget {
  static const String id = 'main_page';

  final String backCurrentIndex;
  final List<Map<String, dynamic>> _navs = [
    {
      "HomePage": HomePage(),
      "items": [
        {
          "asset": 'assets/icons/tab_bar/clear_home.png',
          "label": "Home",
          "icon": "assets/icons/tab_bar/home.png"
        }
      ]
    },
    {
      "ConnectionPage": ConnectionPage(),
      "items": [
        {
          "asset": 'assets/icons/tab_bar/clear_connection.png',
          "label": "Connection",
          "icon": "assets/icons/tab_bar/connection.png"
        }
      ]
    },
    {
      "ListingPage": ListingPage(),
      "items": [
        {
          "asset": 'assets/icons/tab_bar/clear_listing.png',
          "label": "New listing",
          "icon": "assets/icons/tab_bar/listing.png"
        }
      ]
    },
    {
      "MessagePage": MessagePage(),
      "items": [
        {
          "asset": 'assets/icons/tab_bar/clear_message.png',
          "label": "message",
          "icon": "assets/icons/tab_bar/message.png"
        }
      ]
    },
    {
      "ProfilePage": ProfilePage(),
      "items": [
        {
          "asset": 'assets/icons/tab_bar/clear_profile.png',
          "label": "profile",
          "icon": "assets/icons/tab_bar/profile.png"
        }
      ]
    },
  ];

  MainPage({this.backCurrentIndex = "HomePage", Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late int _currentIndex;
  late List<Map<String, dynamic>> _navs;

  void initState() {
    _navs = widget._navs;
    _navs.asMap().forEach((key, values) {
      if (values[widget.backCurrentIndex] != null) {
        _currentIndex = key;
        return;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _navs[_currentIndex][_navs[_currentIndex].keys.first],
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
