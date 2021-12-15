import 'package:dazle/app/utils/app.dart';
import 'package:dazle/app/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class KeywordContainer extends StatelessWidget {
  final String text;
  final ValueChanged onRemoved;

  KeywordContainer({
    @required this.text,
    @required this.onRemoved
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 23,
      padding: EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        border: Border.all(
          color: App.hintColor
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomText(
            text: text,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          SizedBox(width: 4),
          GestureDetector(
            onTap: () {
              onRemoved(text);
            },
            child: Icon(
              Icons.highlight_remove,
              size: 18,
            )
          )
        ],
      ),
    );
  }
}