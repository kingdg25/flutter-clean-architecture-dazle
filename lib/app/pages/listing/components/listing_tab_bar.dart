import 'package:dazle/app/pages/create_listing/create_listing_view.dart';
import 'package:dazle/app/pages/my_collection/my_collection_view.dart';
import 'package:dazle/app/pages/my_listing/my_listing_view.dart';
import 'package:dazle/app/utils/app.dart';
import 'package:dazle/app/widgets/custom_bottom_tab_bar.dart';
import 'package:dazle/app/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:dazle/app/utils/app_constant.dart';

class ListingTabBar extends StatefulWidget {
  const ListingTabBar({Key? key}) : super(key: key);

  @override
  _ListingTabBarState createState() => _ListingTabBarState();
}

class _ListingTabBarState extends State<ListingTabBar>
    with SingleTickerProviderStateMixin {
  TabController? _tabcontroller;
  Mixpanel? _mixpanel;

  final List myTabs = <Widget>[
    Tab(text: 'My Listings'),
    // Tab(text: 'My Collection'),
  ];

  @override
  void initState() {
    super.initState();
    _tabcontroller = TabController(vsync: this, length: myTabs.length);
  }

  @override
  void dispose() {
    _tabcontroller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: 'My Listings',
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        bottom: CustomBottomTabBar(
          tabController: _tabcontroller,
          tabs: myTabs as List<Widget>,
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: TabBarView(
        controller: _tabcontroller,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          MyListingPage(),
          // MyCollectionPage()
        ],
      ),
    );
  }
}
