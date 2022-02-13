import 'package:dazle/app/utils/app.dart';
import 'package:flutter/material.dart';

class CustomBottomTabBar extends StatefulWidget implements PreferredSizeWidget {
  final TabController? tabController;
  final List<Widget> tabs;

  CustomBottomTabBar({
    Key? key,
    required this.tabController,
    required this.tabs
  }) : preferredSize = Size.fromHeight(40.0), super(key: key);

  @override
  final Size preferredSize;

  @override
  _CustomBottomTabBarState createState() => _CustomBottomTabBarState();
}

class _CustomBottomTabBarState extends State<CustomBottomTabBar>{

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: widget.preferredSize,
      child: Container(
        alignment: Alignment.centerLeft,
        child: TabBar(
          controller: widget.tabController,
          tabs: widget.tabs,
          indicatorColor: App.mainColor,
          labelColor: App.textColor,
          unselectedLabelColor: App.hintColor,
          indicatorSize: TabBarIndicatorSize.label,
          isScrollable: true,
        ),
      ),
    );
  }
}