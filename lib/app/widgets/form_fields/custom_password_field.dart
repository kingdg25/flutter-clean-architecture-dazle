import 'package:dazle/app/utils/app.dart';
import 'package:dazle/app/widgets/form_fields/custom_field_layout.dart';
import 'package:flutter/material.dart';

class CustomPasswordField extends StatefulWidget {
  final String hintText;
  final Color hintColor;
  
  final TextEditingController controller;
  
  final TextInputType keyboardType;
  final double fontSize;

  final Function onSaved;

  final Color fillColor;
  final bool filled;


  const CustomPasswordField({
    this.hintText,
    this.hintColor = App.hintColor,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.fontSize = 16.0,
    this.onSaved,
    this.fillColor = const Color.fromRGBO(255, 255, 255, 0.4),
    this.filled = false
  });


  @override
  _CustomPasswordFieldState createState() => new _CustomPasswordFieldState();
}

class _CustomPasswordFieldState extends State<CustomPasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return CustomFieldLayout(
      child: TextFormField(
        controller: widget.controller,
        obscureText: _obscureText,
        onSaved: widget.onSaved,
        validator: (val) {
          if (val.length == 0){
            return "Required field.";
          }
          else if (val.length < 8) {
            return "Password must be at least 8 characters.";
          }
          return null;
        },
        keyboardType: widget.keyboardType,
        style: TextStyle(
          decorationStyle: TextDecorationStyle.dotted,
          color: App.fieldTextColor,
          fontFamily: "Poppins",
          fontSize: widget.fontSize
        ),
        decoration: InputDecoration(
          isDense: true,
          filled: widget.filled,
          fillColor: widget.fillColor,
          contentPadding: EdgeInsets.all(14.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0)
          ),
          enabledBorder: OutlineInputBorder(
            borderSide:  BorderSide(
              color: widget.filled ? widget.fillColor : App.hintColor
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:  BorderSide(
              color: widget.filled ? widget.fillColor : App.hintColor
            ),
          ),
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: widget.hintColor
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility : Icons.visibility_off
            ), 
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            }
          )
        ),
      ),
    );
  }
}