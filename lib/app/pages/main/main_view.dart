import 'package:dazle/app/pages/home/home_view.dart';
import 'package:dazle/app/pages/listing/listing_view.dart';
import 'package:dazle/app/pages/main/components/triangle_painter.dart';
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
        {"asset": 'assets/icons/tab_bar/home.png', "label": "Home"}
      ]
    },
    // {
    //   "ConnectionPage": ConnectionPage(),
    //   "items": [
    //     {"asset": 'assets/icons/tab_bar/connection.png', "label": "connection"}
    //   ]
    // },
    {
      "ListingPage": ListingPage(),
      "items": [
        {"asset": 'assets/icons/tab_bar/listing.png', "label": "listing"}
      ]
    },
    // {
    //   "MessagePage": MessagePage(),
    //   "items": [
    //     {"asset": 'assets/icons/tab_bar/message.png', "label": "message"}
    //   ]
    // },
    {
      "ProfilePage": ProfilePage(),
      "items": [
        {"asset": 'assets/icons/tab_bar/profile.png', "label": "profile"}
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
      _currentIndex = 0;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _navs[_currentIndex][_navs[_currentIndex].keys.first],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _currentIndex,
        items: [
          for (int indexPage = 0; indexPage < _navs.length; indexPage++) ...[
            ...(_navs[indexPage]['items'] as List<Map<String, String>>)
                .map(
                  (item) => BottomNavigationBarItem(
                    activeIcon: CustomPaint(
                        painter: TrianglePainter(),
                        child: Container(
                            child: Image.asset(item['asset']!, height: 30))),
                    icon: Image.asset(item['asset']!, height: 30),
                    label: item['label'],
                  ),
                )
                .toList()
          ]
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
