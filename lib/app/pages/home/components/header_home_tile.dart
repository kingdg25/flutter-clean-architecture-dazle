import 'package:dazle/app/utils/app.dart';
import 'package:dazle/app/utils/app_constant.dart';
import 'package:dazle/app/widgets/custom_text.dart';
import 'package:dazle/app/widgets/form_fields/custom_flat_button.dart';
import 'package:flutter/material.dart';

class HeaderHomeTile extends StatelessWidget {
  final Widget child;
  final String title;
  final String subTitle;
  final Function viewAllOnTap;


  HeaderHomeTile({
    @required this.child,
    @required this.title,
    @required this.subTitle,
    this.viewAllOnTap
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20, bottom: 20, left: 20),
      decoration: AppConstant.bottomBorder,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: title ?? '',
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                ),
                Container(
                  width: 55,
                  height: 17,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromRGBO(240, 242, 247, 1.0)
                  ),
                  child: CustomFlatButton(
                    text: 'View All',
                    fontSize: 10,
                    color: App.hintColor,
                    fontWeight: FontWeight.w400,
                    padding: EdgeInsets.zero,
                    onPressed: viewAllOnTap
                  ),
                )
              ],
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: CustomText(
              text: subTitle ?? '',
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: App.hintColor,
            ),
          ),
          child
        ],
      ),
    );
  }
}