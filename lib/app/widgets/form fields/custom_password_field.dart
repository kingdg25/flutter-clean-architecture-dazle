import 'package:dwellu/app/utils/dwellu.dart';
import 'package:dwellu/app/widgets/form%20fields/custom_field_layout.dart';
import 'package:flutter/material.dart';

class CustomPasswordField extends StatefulWidget {
  final String hintText;
  final Color hintColor;
  final TextEditingController controller;
  final bool isRequired;
  
  final TextInputType keyboardType;
  final double fontSize;

  final Function validator;
  final Function onSaved;

  final Color fillColor;
  final bool filled;


  const CustomPasswordField({
    this.hintText,
    this.hintColor = const Color.fromRGBO(154, 160, 166, 1.0),
    this.controller,
    this.isRequired = false,
    this.keyboardType = TextInputType.text,
    this.fontSize = 16.0,
    this.validator,
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
        validator: (widget.isRequired && widget.validator == null) ? (val) {
          if (val.length == 0){
            return "Required field.";
          }
          return null;
        } : widget.validator,
        keyboardType: widget.keyboardType,
        style: TextStyle(
          decorationStyle: TextDecorationStyle.dotted,
          color: Dwellu.appTextColor,
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
              color: widget.filled ? widget.fillColor : Color.fromRGBO(154, 160, 166, 1.0)
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:  BorderSide(
              color: widget.filled ? widget.fillColor : Color.fromRGBO(154, 160, 166, 1.0)
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