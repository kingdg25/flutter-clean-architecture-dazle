import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final bool centerTitle;

  CustomAppBar({
    Key key,
    @required this.title,
    this.centerTitle = false,
    
  }) : preferredSize = Size.fromHeight(60.0), super(key: key);

  @override
  final Size preferredSize;

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar>{

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        widget.title,
        style: TextStyle(
          color: Color(0xff2E353D),
          fontFamily: 'Poppins',
          fontSize: 18.0,
          fontWeight: FontWeight.w600
        ),
      ),
      centerTitle: widget.centerTitle,
      backgroundColor: Colors.white,
      titleSpacing: 0.0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_rounded, 
          color: Colors.black
        ),
        tooltip: MaterialLocalizations.of(context).backButtonTooltip,
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }
}