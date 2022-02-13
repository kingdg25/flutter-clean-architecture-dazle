import 'package:dazle/app/pages/message_lead/message_lead_view.dart';
import 'package:dazle/app/pages/message_listing/message_listing_view.dart';
import 'package:dazle/app/widgets/custom_bottom_tab_bar.dart';
import 'package:dazle/app/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class MessageTabBar extends StatefulWidget {
  const MessageTabBar({ Key? key }) : super(key: key);

  @override
  _MessageTabBarState createState() => _MessageTabBarState();
}

class _MessageTabBarState extends State<MessageTabBar> with SingleTickerProviderStateMixin {
  TabController? _tabcontroller;

  final List myTabs = <Widget>[
    Tab(text: 'Listings'),
    Tab(text: 'Leads'),
  ];

  @override
  void initState(){
    super.initState();
    _tabcontroller = TabController(vsync: this, length: myTabs.length);
  }

  @override
  void dispose(){
    _tabcontroller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: 'Inbox',
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
          MessageListingPage(),
          MessageLeadPage()
        ],
      ),
    );
  }
}