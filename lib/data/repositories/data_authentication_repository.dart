import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

import 'package:dazle/data/constants.dart';
import 'package:dazle/domain/entities/user.dart';
import 'package:dazle/domain/repositories/authentication_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';



class DataAuthenticationRepository extends AuthenticationRepository {
  User todoUser;

  static DataAuthenticationRepository _instance = DataAuthenticationRepository._internal();
  DataAuthenticationRepository._internal();
  factory DataAuthenticationRepository() => _instance;

  @override
  Future<String> forgotPassword({String email}) async {
    Map params = {
      "user": {
        "email": email,
      }
    };

    var response = await http.post(
      "${Constants.siteURL}/api/users/forgot-password",
      body: convert.jsonEncode(params),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      }
    );

    var jsonResponse = await convert.jsonDecode(response.body);
    if (response.statusCode == 200){
      print('forgot password json data $jsonResponse');
      bool success = jsonResponse['success'];
      var user = jsonResponse['user'];

      if(success){
        return user['code'];
      }
      else {
        throw {
          "error": false,
          "error_type": "${jsonResponse['error_type'] ?? ''}",
          "status": "$jsonResponse"
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

  @override
  Future<void> resetPassword({String email, String code, String password}) async {
    Map params = {
      "user": {
        "email": email,
        "code": code,
        "password": password
      }
    };

    var response = await http.post(
      "${Constants.siteURL}/api/users/reset-password",
      body: convert.jsonEncode(params),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      }
    );

    var jsonResponse = await convert.jsonDecode(response.body);
    if (response.statusCode == 200){
      print('reset password json data $jsonResponse');
      bool success = jsonResponse['success'];

      if(!success){
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

  @override
  Future<bool> isAuthenticated() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if ( prefs.getString('accessToken') != null ) {

      Map params = {
        "token": prefs.getString('accessToken')
      };
      
      var response = await http.post(
        "${Constants.siteURL}/api/users/is-authenticated",
        body: convert.jsonEncode(params),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        }
      );

      var jsonResponse = await convert.jsonDecode(response.body);
      if (response.statusCode == 200){
        bool success = jsonResponse['success'];

        if (!success) {
          await prefs.remove('accessToken');
          await prefs.remove('user');
        }
        
        return success;
      }

    }

    return false;
  }

  @override
  Future<User> login({String email, String password}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map params = {
      "user": {
        "email": email,
        "password": password
      }
    };
    
    var response = await http.post(
      "${Constants.siteURL}/api/users/login",
      body: convert.jsonEncode(params),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      }
    );

    var jsonResponse = await convert.jsonDecode(response.body);
    if (response.statusCode == 200){

      bool success = jsonResponse['success'];
      var user = jsonResponse['user'];
      print('login login TODOUSER $jsonResponse');

      if(success){
        print('accessToken ${user['token']} ${user['token'].runtimeType}');
        await prefs.setString('accessToken', user['token']);
        await prefs.setString('user', convert.jsonEncode(user));

        print('accessToken ${prefs.getString('accessToken')}');

        todoUser = User.fromJson(user);

        return todoUser;
      }
      else {
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

  @override
  Future<void> register({String firstName, String lastName, String mobileNumber, String position, String brokerLicenseNumber, String email, String password}) async {
    Map params = {
      "user": {
        "firstname": firstName,
        "lastname": lastName,
        "mobile_number": mobileNumber,
        "position": position,
        "broker_license_number": brokerLicenseNumber,
        "email": email,
        "password": password
      }
    };

    var response = await http.post(
      "${Constants.siteURL}/api/users/register",
      body: convert.jsonEncode(params),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      }
    );

    var jsonResponse = await convert.jsonDecode(response.body);
    if (response.statusCode == 200){
      print('login login TODOUSER REGISTER $jsonResponse');
      bool success = jsonResponse['success'];

      if(!success){
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

  @override
  Future<User> socialLogin({String email, String loginType, String token}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map params = {
      "user": {
        "email": email,
        "login_type": loginType,
        "token": token
      }
    };
    
    var response = await http.post(
      "${Constants.siteURL}/api/users/social-login",
      body: convert.jsonEncode(params),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      }
    );

    var jsonResponse = await convert.jsonDecode(response.body);
    if (response.statusCode == 200){

      bool success = jsonResponse['success'];
      var user = jsonResponse['user'];
      print('social login TODOUSER $jsonResponse');

      if(success){
        print('social login accessToken ${user['token']} ${user['token'].runtimeType}');
        await prefs.setString('accessToken', user['token']);
        await prefs.setString('user', convert.jsonEncode(user));

        print('social login accessToken ${prefs.getString('accessToken')}');

        todoUser = User.fromJson(user);

        return todoUser;
      }
      else {
        
        // need to set profile when user not yet full registered.
        if ( jsonResponse['error_type'] == "no_setup_profile" ) {
          await prefs.setString('user', convert.jsonEncode(user));
        }

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

  @override
  Future<User> setupProfile({String firstName, String lastName, String mobileNumber, String position, String brokerLicenseNumber, String email}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map params = {
      "user": {
        "firstname": firstName,
        "lastname": lastName,
        "mobile_number": mobileNumber,
        "position": position,
        "broker_license_number": brokerLicenseNumber,
        "email": email
      }
    };
    
    var response = await http.put(
      "${Constants.siteURL}/api/users/setup-profile",
      body: convert.jsonEncode(params),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      }
    );

    var jsonResponse = await convert.jsonDecode(response.body);
    if (response.statusCode == 200){

      bool success = jsonResponse['success'];
      var user = jsonResponse['user'];
      print('setup profile TODOUSER $jsonResponse');

      if(success){
        await prefs.setString('accessToken', user['token']);
        await prefs.setString('user', convert.jsonEncode(user));

        todoUser = User.fromJson(user);

        return todoUser;
      }
      else {
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

  @override
  Future<bool> checkLicenseNumber({String brokerLicenseNumber}) async {
    Map params = {
      "broker_license_number": brokerLicenseNumber
    };
    
    var response = await http.post(
      "${Constants.siteURL}/api/users/check-license-number",
      body: convert.jsonEncode(params),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      }
    );

    var jsonResponse = await convert.jsonDecode(response.body);
    if (response.statusCode == 200){
      bool success = jsonResponse['success'];
      
      if(success){
        return success;
      }
      else {
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