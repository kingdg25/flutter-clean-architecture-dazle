import 'package:dazle/app/utils/app.dart';
import 'package:dazle/app/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class PropertyTextInfo extends StatelessWidget {
  final String text;
  final String asset;

  PropertyTextInfo({
    this.text,
    this.asset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      padding: EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        border: Border.all(
          color: App.hintColor
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomText(
            text: text,
            fontSize: 10,
          ),
          (asset != null && asset.isNotEmpty) ? Image.asset(
            asset
          ) : Container()
        ],
      ),
    );
  }
}