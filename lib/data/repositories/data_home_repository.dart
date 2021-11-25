import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

import 'package:dazle/domain/repositories/home_repository.dart';
import 'package:dazle/data/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';



class DataHomeRepository extends HomeRepository {
  static DataHomeRepository _instance = DataHomeRepository._internal();
  DataHomeRepository._internal();
  factory DataHomeRepository() => _instance;


  @override
  Future<void> isNewUser({String email, bool isNewUser}) async {
    Map params = {
      "user": {
        "email": email,
        "is_new_user": isNewUser
      }
    };

    var response = await http.post(
      "${Constants.siteURL}/api/users/is-new-user",
      body: convert.jsonEncode(params),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      }
    );

    var jsonResponse = await convert.jsonDecode(response.body);
    if (response.statusCode == 200){
      print('new user json data $jsonResponse');
      bool success = jsonResponse['success'];
      var user = jsonResponse['user'];

      if (success) {
        print('isNewUser isNewUser isNewUser isNewUser ${user['is_new_user']} $user');
        SharedPreferences prefs = await SharedPreferences.getInstance();

        if(user != null){
          await prefs.setString('user', convert.jsonEncode(user));
        }

      }
      else {
        throw {
          "error": false,
          "status": "$jsonResponse"
        };
      }
      
    }
    else {
      throw {
        "error": true,
        "status": "$jsonResponse"
      };
    }
  
  }
  
}