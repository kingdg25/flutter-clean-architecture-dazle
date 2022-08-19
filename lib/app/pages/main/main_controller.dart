import 'dart:async';
import 'dart:io';

import 'package:dazle/app/pages/find_match/find_match_view.dart';
import 'package:dazle/app/pages/home/home_view.dart';
import 'package:dazle/app/pages/listing/listing_view.dart';
import 'package:dazle/app/utils/app.dart';
import 'package:dazle/app/utils/app_constant.dart';
import 'package:dazle/app/widgets/custom_text.dart';
import 'package:dazle/app/widgets/pdf/pdf_generator.dart';
import 'package:dazle/domain/entities/property.dart';
import 'package:dazle/domain/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:dazle/app/pages/main/main_presenter.dart';
import 'package:share_plus/share_plus.dart';

class MainController extends Controller {
  final MainPresenter mainPresenter;

  double progressValue = .25;
  bool showProgressBar = false;

  Property? listingToShare;

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

  showModal() {
    showModalBottomSheet(
      context: getContext(),
      builder: ((builder) => bottomSheet()),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(getContext()).size.width,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          CustomText(
            text: 'Share Listing as',
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                child: TextButton.icon(
                  icon: Icon(
                    Icons.picture_as_pdf,
                    color: App.mainColor,
                    size: 30,
                  ),
                  label: CustomText(
                    text: 'PDF',
                    fontWeight: FontWeight.w500,
                  ),
                  onPressed: () async {
                    Navigator.pop(getContext());
                    User currentUser = await App.getUser();
                    if (currentUser.accountStatus != 'Deactivated') {
                      // mixpanel?.track('Share Listing');
                      showHideProgressBar();

                      await Future.delayed(const Duration(milliseconds: 700));
                      setProgressBarValue(.5);

                      String? pdfFilePath = await PdfGenerator()
                          .sharePdf(property: listingToShare!);

                      setProgressBarValue(1);
                      await Future.delayed(
                          const Duration(seconds: 1, milliseconds: 300));

                      List<String> filePaths = [];
                      filePaths.add(pdfFilePath!);

                      await Share.shareFiles(
                        filePaths,
                        mimeTypes: [
                          Platform.isAndroid ? "image/jpg" : "application/pdf"
                        ],
                        subject: 'Dazle Property Listing-${listingToShare!.id}',
                        text: 'Dazle Property Listing-${listingToShare!.id}',
                      );
                      setProgressBarValue(.25);
                      showHideProgressBar();
                    } else {
                      AppConstant.statusDialog(
                          context: getContext(),
                          title: 'Action not Allowed',
                          text: 'Please Reactivate your account first.',
                          success: false);
                    }
                  },
                ),
              ),
              Expanded(
                child: TextButton.icon(
                  icon: Icon(
                    Icons.share,
                    color: App.mainColor,
                  ),
                  label: CustomText(
                    text: 'Link',
                    fontWeight: FontWeight.w500,
                  ),
                  onPressed: () async {
                    await Share.share(
                        'https://dazle-links.web.app/web_listing_details?listingId=${listingToShare!.id}',
                        subject: 'TestShare');
                    Navigator.pop(getContext());
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
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
