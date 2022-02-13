import 'package:dazle/domain/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;

class App{
  static const name = "Dazle";

  static const mainColor = Color.fromRGBO(51, 212, 157, 1.0);
  static const fieldTextColor = Color.fromRGBO(75, 70, 70, 1.0);
  static const textColor = Color.fromRGBO(46, 53, 61, 1.0);
  static const hintColor = Color.fromRGBO(154, 160, 166, 1.0);

  static textStyle({
    double fontSize = 14.0,
    Color color = textColor,
    FontWeight fontWeight = FontWeight.normal,
    FontStyle fontStyle = FontStyle.normal
  }) {
    return TextStyle(
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight,
      fontFamily: "Poppins",
      fontStyle: fontStyle
    );
  }

  static getUser() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      var user = prefs.getString('user')!;
      var todoUser = convert.jsonDecode(user);

      return User.fromJson(todoUser);
    } catch (e) {
      print('getUser error $e');
    }
  }

  static logOutUser() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final GoogleSignIn googleSignIn = GoogleSignIn();
    
      await prefs.remove('accessToken');
      await prefs.remove('user');
      
      await FacebookAuth.instance.logOut();
      await googleSignIn.signOut();
    
    } catch (e) {
      print('getUser error $e');
    }
  }

}