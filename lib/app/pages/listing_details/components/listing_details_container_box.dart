import 'package:dazle/app/utils/app.dart';
import 'package:dazle/app/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class ListingDetailsContainerBox extends StatelessWidget {
  final String asset;
  final String text;

  ListingDetailsContainerBox({
    required this.asset,
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(
          color: App.hintColor
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Image.asset(
            asset
          ),
          Flexible(
            child: CustomText(
              text: text,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }
}