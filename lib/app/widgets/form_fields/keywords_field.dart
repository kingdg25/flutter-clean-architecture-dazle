import 'package:dazle/app/utils/app.dart';
import 'package:dazle/app/widgets/form_fields/custom_field_layout.dart';
import 'package:dazle/app/widgets/keyword_container.dart';
import 'package:flutter/material.dart';


class KeywordsField extends StatefulWidget {
  final String hintText;
  final Color hintColor;
  final double fontSize;
  
  const KeywordsField({
    Key key,
    this.hintText,
    this.hintColor = App.hintColor,
    this.fontSize = 16.0,
  }) : super(key: key);

  @override
  _KeywordsFieldState createState() => _KeywordsFieldState();
}

class _KeywordsFieldState extends State<KeywordsField> {
  final TextEditingController keywordTextController = TextEditingController();
  List<String> keywords = [];

  @override
  Widget build(BuildContext context) {
    return CustomFieldLayout(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
              controller: keywordTextController,
              onFieldSubmitted: (value) {
                setState(() {
                  keywords.add(keywordTextController.text);
                });

                keywordTextController.clear();
              },
              keyboardType: TextInputType.text,
              style: TextStyle(
                decorationStyle: TextDecorationStyle.dotted,
                color: App.fieldTextColor,
                fontFamily: "Poppins",
                fontSize: widget.fontSize
              ),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.all(14.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0)
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:  BorderSide(
                    color: widget.hintColor
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:  BorderSide(
                    color: widget.hintColor
                  ),
                ),
                hintText: widget.hintText,
                hintStyle: TextStyle(
                  color: widget.hintColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.add_circle_outline_rounded,
                    color: widget.hintColor,
                  ), 
                  onPressed: () {
                    setState(() {
                      keywords.add(keywordTextController.text);
                    });

                    keywordTextController.clear();
                  }
                )
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            alignment: Alignment.centerLeft,
            child: Wrap(
              runSpacing: 8,
              spacing: 10,
              direction: Axis.horizontal,

              children: List.generate(keywords.length, (index) {
                return KeywordContainer(
                  text: keywords[index],
                  onRemoved: (value){
                    setState(() {
                      keywords.removeAt(index);
                    });
                  },
                );
              }),
            ),
          )
        ],
      ),
    );
  }
}