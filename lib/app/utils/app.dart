import 'package:dazle/domain/entities/todo_user.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;

class App{
  static const name = "Dazle";

  static const mainColor = Color.fromRGBO(51, 212, 157, 1.0);
  static const fieldTextColor = Color.fromRGBO(75, 70, 70, 1.0);
  static const textColor = Color.fromRGBO(46, 53, 61, 1.0);

  static getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var user = prefs.getString('user');
    var todoUser = convert.jsonDecode(user);

    return TodoUser.fromJson(todoUser);
  }
}