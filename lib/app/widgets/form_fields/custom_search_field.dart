import 'package:dazle/app/utils/app.dart';
import 'package:dazle/app/widgets/form_fields/custom_field_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class CustomSearchField extends StatelessWidget {
  final String hintText;
  final Color hintColor;
  final TextEditingController controller;

  final Function onPressedButton;
  final IconData iconData;
  
  CustomSearchField({
    this.hintText,
    this.hintColor = App.hintColor,
    this.controller,
    this.onPressedButton,
    this.iconData
  });

  @override
  Widget build(BuildContext context) {
    return CustomFieldLayout(
      child: Container(
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            Flexible(
              child: TypeAheadFormField(
                textFieldConfiguration: TextFieldConfiguration(
                  controller: controller,
                  onChanged: (value) {
                    print('onchange $value');
                  },
                  onSubmitted: (value) {
                    print('onSubmitted $value');
                  },
                  onEditingComplete: () {
                    print('onEditingComplete 12312');
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    hintText: hintText,
                    hintStyle: TextStyle(
                      color: hintColor
                    ),
                    isDense: true,
                    contentPadding: EdgeInsets.all(0.0)
                  ),
                ),
                suggestionsCallback: (pattern) async {
                  print('pattern $pattern');
                  // var realtyData = await Brooky.getRealtyFirmData(pattern);
                  // if(realtyData.isEmpty){
                  //   _selectedRealty = null;
                  // }
                  // return realtyData;
                  return null;
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text(suggestion['name']),
                  );
                },
                noItemsFoundBuilder: (BuildContext context) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'No Found!',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Theme.of(context).disabledColor, fontSize: 18.0)
                    ),
                  );
                },
                transitionBuilder: (context, suggestionsBox, controller) {
                  return FadeTransition(
                    child: suggestionsBox,
                    opacity: CurvedAnimation(
                      parent: controller,
                      curve: Curves.fastOutSlowIn
                    ),
                  );
                },
                onSuggestionSelected: (suggestion) {
                  print('suggestion $suggestion');
                  // _realtyController.text = suggestion['name'];
                  // _selectedRealty = suggestion['name'];
                },
                validator: (value) {
                  // print('validator $value $_selectedRealty ${_realtyController.text}');
                  // if (value.isEmpty) {
                  //   return 'Select your Realty';
                  // }
                  // else {
                  //   if (_selectedRealty == null){
                  //     return 'Select your Realty';
                  //   }
                  // }
                  return null;
                },
                onSaved: (value) {
                  print('onSaved $value');
                  // _selectedRealty = value;
                },
              ),
            ),
            SizedBox(width: 4.0),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: MaterialButton(
                onPressed: onPressedButton,
                minWidth: 0,
                height: 0,
                padding: EdgeInsets.zero,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                child: Container(
                  padding: EdgeInsets.all(5),
                  child: Icon(
                    iconData,
                    size: 30.0,
                  ),
                )
              ),
            ),
          ],
        )
      ),
    );
  }
}
