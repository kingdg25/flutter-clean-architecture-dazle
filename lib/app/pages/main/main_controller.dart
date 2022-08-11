import 'dart:async';

import 'package:dazle/app/pages/find_match/find_match_view.dart';
import 'package:dazle/app/pages/home/home_view.dart';
import 'package:dazle/app/pages/listing/listing_view.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:dazle/app/pages/main/main_presenter.dart';

class MainController extends Controller {
  final MainPresenter mainPresenter;

  double progressValue = .25;
  bool showProgressBar = false;

  late int currentIndex;
  // int get currentIndex => _currentIndex;
  // late List<Map<String, dynamic>> navs;

  final List<Map<String, dynamic>> navs = [
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
          "label": "My listings",
          "asset": "assets/icons/tab_bar/listing.png"
        }
      ]
    },
    // {
    //   "MessagePage": MessagePage(),
    //   "items": [
    //     {
    //       "icon": 'assets/icons/tab_bar/clear_message.png',
    //       "label": "Message",
    //       "asset": "assets/icons/tab_bar/message.png"
    //     }
    //   ]
    // },
    // {
    //   "ProfilePage": ProfilePage(),
    //   "items": [
    //     {
    //       "icon": 'assets/icons/tab_bar/clear_profile.png',
    //       "label": "Profile",
    //       "asset": "assets/icons/tab_bar/profile.png"
    //     }
    //   ]
    // },
    {
      "FindMatchPage": FindMatchPage(),
      "items": [
        {
          "icon": 'assets/icons/tab_bar/property_match_inactive.png',
          "label": "Property Match",
          "asset": "assets/icons/tab_bar/property_match_active.png"
        }
      ]
    },
  ];
  final backCurrentIndex;

  MainController({this.backCurrentIndex})
      : mainPresenter = MainPresenter(),
        super();

  @override
  void initListeners() {
    navs.asMap().forEach((key, values) {
      if (values[backCurrentIndex] != null) {
        currentIndex = key;
      }
    });
  }

  void showHideProgressBar() {
    if (showProgressBar) {
      showProgressBar = false;
    } else {
      showProgressBar = true;
    }
    refreshUI();
  }

  void setProgressBarValue(double newProgressValue) {
    progressValue = newProgressValue;
    refreshUI();
  }

  String progressPercentage() {
    double initial = progressValue / 1;
    double percent = initial * 100;

    return '$percent';
  }

  @override
  void onResumed() => print('On resumed');

  @override
  void onReassembled() => print('View is about to be reassembled');

  @override
  void onDeactivated() => print('View is about to be deactivated');

  @override
  void onDisposed() {
    // don't forget to dispose of the presenter
    super.onDisposed();
  }
}
