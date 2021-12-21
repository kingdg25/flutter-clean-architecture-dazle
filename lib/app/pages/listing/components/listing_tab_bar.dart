import 'package:dazle/app/pages/create_listing/create_listing_view.dart';
import 'package:dazle/app/pages/my_collection/my_collection_view.dart';
import 'package:dazle/app/pages/my_listing/my_listing_view.dart';
import 'package:dazle/app/utils/app.dart';
import 'package:dazle/app/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class ListingTabBar extends StatefulWidget {
  const ListingTabBar({ Key key }) : super(key: key);

  @override
  _ListingTabBarState createState() => _ListingTabBarState();
}

class _ListingTabBarState extends State<ListingTabBar> with SingleTickerProviderStateMixin {
  TabController _tabcontroller;

  final List myTabs = <Widget>[
    Tab(text: 'My Listing'),
    Tab(text: 'My Collection'),
  ];

  @override
  void initState(){
    super.initState();
    _tabcontroller = TabController(vsync: this, length: myTabs.length);
  }

  @override
  void dispose(){
    _tabcontroller.dispose();
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
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(40),
          child: Container(
            alignment: Alignment.centerLeft,
            // decoration: BoxDecoration(
            //   border: Border(
            //     top: BorderSide(
            //       color: App.hintColor,
            //       width: 0.3
            //     )
            //   )
            // ),
            child: TabBar(
              controller: _tabcontroller,
              tabs: myTabs,
              indicatorColor: App.mainColor,
              labelColor: App.textColor,
              unselectedLabelColor: App.hintColor,
              indicatorSize: TabBarIndicatorSize.label,
              isScrollable: true,
              // labelPadding: EdgeInsets.only(left: 0, right: 0),
              // indicatorPadding: EdgeInsets.only(
              //   left: 0,
              //   right: 8,
              //   bottom: 4
              // ),
              // indicator: UnderlineTabIndicator(
              //   borderSide: BorderSide(
              //     width: 4,
              //     color: Color(0xFF646464),
              //   ),
              // )
            ),
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (buildContext) => CreateListingPage()
            )
          );
        },
        tooltip: 'Create listing',
        backgroundColor: App.mainColor,
        child: Icon(Icons.add),
      ),
      body: TabBarView(
        controller: _tabcontroller,
        children: <Widget>[
          MyListingPage(),
          MyCollectionPage()
        ],
      ),
    );
  }
}