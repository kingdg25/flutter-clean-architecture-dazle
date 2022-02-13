import 'dart:async';

import 'package:dazle/app/utils/app.dart';
import 'package:dazle/app/widgets/form_fields/custom_field_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class CustomSearchField extends StatelessWidget {
  final String? hintText;
  final Color hintColor;
  final TextEditingController? controller;

  final Function? onChanged;
  final Function? onTap;
  final Function? suggestionsCallback;
  final Function? onSuggestionSelected;
  final Function? onSubmitted;

  final Function? onPressedButton;
  final IconData? iconData;
  final double borderRadius;

  final bool filled;
  final Color? fillColor;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;

  final bool withIcon;
  final bool isAssetIcon;
  final String? asset;

  final EdgeInsets padding;
  
  CustomSearchField({
    this.hintText,
    this.hintColor = App.hintColor,
    this.controller,
    this.onPressedButton,
    this.iconData,
    this.onChanged,
    this.onTap,
    this.suggestionsCallback,
    this.onSuggestionSelected,
    this.onSubmitted,
    this.borderRadius = 20.0,
    this.filled = false,
    this.fillColor,
    this.enabledBorder,
    this.focusedBorder,
    this.isAssetIcon = false,
    this.asset,
    this.withIcon = false,
    this.padding = const EdgeInsets.all(20)
  });

  @override
  Widget build(BuildContext context) {
    return CustomFieldLayout(
      child: Container(
        padding: padding,
        child: Row(
          children: [
            Flexible(
              child: TypeAheadFormField(
                textFieldConfiguration: TextFieldConfiguration(
                  controller: controller,
                  onChanged: onChanged as void Function(String)?,
                  onSubmitted: (value) {
                    FocusScope.of(context).unfocus();

                    onSubmitted!(value);
                  },
                  onEditingComplete: () {
                    print('onEditingComplete 12312');
                  },
                  onTap: onTap as void Function()?,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(borderRadius),
                    ),
                    hintText: hintText,
                    hintStyle: TextStyle(
                      color: hintColor
                    ),
                    isDense: true,
                    contentPadding: EdgeInsets.all(0.0),
                    filled: filled,
                    fillColor: fillColor,
                    enabledBorder: enabledBorder,
                    focusedBorder: focusedBorder,
                  ),
                ),
                suggestionsCallback: suggestionsCallback as Future<List<dynamic>> Function(String),
                itemBuilder: (context, dynamic suggestion) {
                  return ListTile(
                    title: Text(suggestion),
                  );
                },
                noItemsFoundBuilder: (BuildContext context) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Not Found!',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Theme.of(context).disabledColor, fontSize: 18.0)
                    ),
                  );
                },
                transitionBuilder: (context, suggestionsBox, controller) {
                  return FadeTransition(
                    child: suggestionsBox,
                    opacity: CurvedAnimation(
                      parent: controller!,
                      curve: Curves.fastOutSlowIn
                    ),
                  );
                },
                onSuggestionSelected: onSuggestionSelected as void Function(dynamic),
                validator: (value) {
                  return null;
                },
                onSaved: (value) {
                  print('onSaved $value');
                },
              ),
            ),
            withIcon ? ( isAssetIcon ? Container() : SizedBox(width: 4.0) ) : Container(),
            withIcon ? ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: MaterialButton(
                onPressed: onPressedButton as void Function()?,
                minWidth: 0,
                height: 0,
                padding: EdgeInsets.zero,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                child: isAssetIcon ? Image.asset(
                  asset!,
                  width: 70,
                  height: 70,
                  
                ) : Container(
                  padding: EdgeInsets.all(5),
                  child: Icon(
                    iconData,
                    size: 30.0,
                  ),
                )
              ),
            ) : Container(),
          ],
        )
      ),
    );
  }
}
