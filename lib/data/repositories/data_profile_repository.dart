import 'dart:convert' as convert;
import 'package:dazle/data/constants.dart';
import 'package:http/http.dart' as http;

import 'package:dazle/domain/entities/user.dart';
import 'package:dazle/domain/repositories/profile_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataProfileRepository extends ProfileRepository {
  static DataProfileRepository _instance = DataProfileRepository._internal();
  DataProfileRepository._internal();
  factory DataProfileRepository() => _instance;

  @override
  Future<void> update({User user}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('update user update user ${user.toJson()}');

    Map params = {
      "user": user.toJson()
    };

    var response = await http.put(
      "${Constants.siteURL}/api/users/update",
      body: convert.jsonEncode(params),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      }
    );

    var jsonResponse = await convert.jsonDecode(response.body);
    if (response.statusCode == 200){
      print('update update $jsonResponse');
      bool success = jsonResponse['success'];
      var resUser = jsonResponse['user'];

      if(success){
        await prefs.setString('user', convert.jsonEncode(resUser));
      }
      else{
        throw {
          "error": false,
          "error_type": "${jsonResponse['error_type'] ?? ''}",
          "status": jsonResponse['status']
        };
      }
    }
    else {
      throw {
        "error": true,
        "error_type": "dynamic",
        "status": "$jsonResponse"
      };
    }
  }
  
}