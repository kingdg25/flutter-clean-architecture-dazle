import 'package:dazle/app/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final bool centerTitle;
  final bool automaticallyImplyLeading;

  CustomAppBar({
    Key key,
    this.title,
    this.centerTitle = false,
    this.automaticallyImplyLeading = true
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
      title: CustomText(
        text: widget.title ?? '',
        color: Color(0xff2E353D),
        fontSize: 18.0,
        fontWeight: FontWeight.w600
      ),
      automaticallyImplyLeading: widget.automaticallyImplyLeading,
      centerTitle: widget.centerTitle,
      backgroundColor: Colors.white,
      titleSpacing: 0.0,
      leading: widget.automaticallyImplyLeading ? IconButton(
        icon: Icon(
          Icons.arrow_back_ios_rounded, 
          color: Colors.black
        ),
        tooltip: MaterialLocalizations.of(context).backButtonTooltip,
        onPressed: () => Navigator.of(context).pop(),
      ) : null,
    );
  }
}