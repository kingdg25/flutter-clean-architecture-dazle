import 'package:flutter/material.dart';

class BoxContainer extends StatelessWidget {
  final Widget widget;
  const BoxContainer({Key? key, required this.widget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10)),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey.withOpacity(0.2),
        //     spreadRadius: 1,
        //     blurRadius: 4,
        //     offset: Offset(0, 4), // changes position of shadow
        //   ),
        // ],
      ),
      child: widget,
    );
  }
}
