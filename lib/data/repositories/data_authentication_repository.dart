import 'dart:convert' as convert;
import 'package:dazle/app/utils/app.dart';
import 'package:http/http.dart' as http;

import 'package:dazle/data/constants.dart';
import 'package:dazle/domain/entities/user.dart';
import 'package:dazle/domain/repositories/authentication_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataAuthenticationRepository extends AuthenticationRepository {
  User? todoUser;

  static DataAuthenticationRepository _instance =
      DataAuthenticationRepository._internal();
  DataAuthenticationRepository._internal();
  factory DataAuthenticationRepository() => _instance;

  @override
  Future<void> verifyPassword({String? email, String? password}) async {
    Map params = {
      "user": {"email": email, "password": password}
    };

    var response = await http.post(
        Uri.parse("${Constants.siteURL}/auth/verify-password"),
        body: convert.jsonEncode(params),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        });

    var jsonResponse = await convert.jsonDecode(response.body);
    if (response.statusCode == 200) {
      print('verifypassword data $jsonResponse');
      bool success = jsonResponse['success'];

      if (!success) {
        throw {
          "error": false,
          "error_type": "${jsonResponse['error_type'] ?? ''}",
          "status": jsonResponse['status']
        };
      }
    } else {
      throw {"error": true, "error_type": "dynamic", "status": "$jsonResponse"};
    }
  }

  @override
  Future<String?> deleteAccountCode({String? email, String? action}) async {
    Map params = {
      "user": {"email": email, "action": action}
    };

    var response = await http.post(
        Uri.parse("${Constants.siteURL}/auth/delete-account-code"),
        body: convert.jsonEncode(params),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        });

    var jsonResponse = await convert.jsonDecode(response.body);
    if (response.statusCode == 200) {
      print('delete account code json data $jsonResponse');
      bool success = jsonResponse['success'];
      var user = jsonResponse['user'];

      if (success) {
        return user['code'];
      } else {
        throw {
          "error": false,
          "error_type": "${jsonResponse['error_type'] ?? ''}",
          "status": "${jsonResponse?['status'] ?? jsonResponse}"
        };
      }
    } else {
      throw {"error": true, "error_type": "dynamic", "status": "$jsonResponse"};
    }
  }

  @override
  Future<void> checkDeleteAccountCode({String? email, String? code}) async {
    Map params = {
      "user": {"email": email, "code": code}
    };

    var response = await http.post(
        Uri.parse("${Constants.siteURL}/auth/check-delete-account-code"),
        body: convert.jsonEncode(params),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        });

    var jsonResponse = await convert.jsonDecode(response.body);
    if (response.statusCode == 200) {
      print('check delete account code data $jsonResponse');
      bool success = jsonResponse['success'];

      if (!success) {
        throw {
          "error": false,
          "error_type": "${jsonResponse['error_type'] ?? ''}",
          "status": jsonResponse['status']
        };
      }
    } else {
      throw {"error": true, "error_type": "dynamic", "status": "$jsonResponse"};
    }
  }

  @override
  Future<String?> forgotPassword({String? email}) async {
    Map params = {
      "user": {
        "email": email,
      }
    };

    var response = await http.post(
        Uri.parse("${Constants.siteURL}/auth/forgot-password"),
        body: convert.jsonEncode(params),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        });

    var jsonResponse = await convert.jsonDecode(response.body);
    if (response.statusCode == 200) {
      print('forgot password json data $jsonResponse');
      bool success = jsonResponse['success'];
      var user = jsonResponse['user'];

      if (success) {
        return user['code'];
      } else {
        throw {
          "error": false,
          "error_type": "${jsonResponse['error_type'] ?? ''}",
          "status": "${jsonResponse?['status'] ?? jsonResponse}"
        };
      }
    } else {
      throw {"error": true, "error_type": "dynamic", "status": "$jsonResponse"};
    }
  }

  @override
  Future<void> resetPassword(
      {String? email, String? code, String? password}) async {
    Map params = {
      "user": {"email": email, "code": code, "password": password}
    };

    var response = await http.post(
        Uri.parse("${Constants.siteURL}/auth/reset-password"),
        body: convert.jsonEncode(params),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        });

    var jsonResponse = await convert.jsonDecode(response.body);
    if (response.statusCode == 200) {
      print('reset password json data $jsonResponse');
      bool success = jsonResponse['success'];

      if (!success) {
        throw {
          "error": false,
          "error_type": "${jsonResponse['error_type'] ?? ''}",
          "status": jsonResponse['status']
        };
      }
    } else {
      throw {"error": true, "error_type": "dynamic", "status": "$jsonResponse"};
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("IS AUTHH");
    User? _user = await App.getUser();
    // temp

    if (prefs.getString('accessToken') != null &&
        _user?.id != null &&
        _user?.id != null) {
      try {
        await this.getUserInfo(); // update user profile info
      } catch (e) {
        print("NAA ERRRR");
        print(e);
      }
      return true;
    }
    return false;

    // if (prefs.getString('accessToken') != null) {
    //   Map params = {"token": prefs.getString('accessToken')};

    //   var response = await http.post(
    //       Uri.parse("${Constants.siteURL}/auth/is-authenticated"),
    //       body: convert.jsonEncode(params),
    //       headers: {
    //         'Content-Type': 'application/json',
    //         'Accept': 'application/json'
    //       });

    //   var jsonResponse = await convert.jsonDecode(response.body);
    //   if (response.statusCode == 200) {
    //     bool success = jsonResponse['success'];

    //     if (!success) {
    //       await prefs.remove('accessToken');
    //       await prefs.remove('user');
    //     }

    //     return success;
    //   }
    // }

    // return false;
  }

  @override
  Future<User?> login({String? email, String? password}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map params = {
      "user": {"email": email, "password": password}
    };

    var response = await http.post(Uri.parse("${Constants.siteURL}/auth/login"),
        body: convert.jsonEncode(params),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        });

    var jsonResponse = await convert.jsonDecode(response.body);
    if (response.statusCode == 200) {
      bool success = jsonResponse['success'];
      var user = jsonResponse['user'];
      print('login login TODOUSER $jsonResponse');

      if (success) {
        print('accessToken ${user['token']} ${user['token'].runtimeType}');
        await prefs.setString('accessToken', user['token']);
        await prefs.setString('user', convert.jsonEncode(user));

        print('accessToken ${prefs.getString('accessToken')}');

        todoUser = User.fromJson(user);

        return todoUser;
      } else {
        throw {
          "error": false,
          "error_type": "${jsonResponse['error_type'] ?? ''}",
          "status": jsonResponse['status']
        };
      }
    } else {
      throw {"error": true, "error_type": "dynamic", "status": "$jsonResponse"};
    }
  }

  @override
  Future<void> register(
      {String? firstName,
      String? lastName,
      String? mobileNumber,
      String? position,
      // String? brokerLicenseNumber,
      String? email,
      String? password}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map params = {
      "user": {
        "firstname": firstName,
        "lastname": lastName,
        "mobile_number": mobileNumber,
        "position": position,
        "email": email,
        "password": password
      }
    };

    var response = await http.post(
        Uri.parse("${Constants.siteURL}/auth/register"),
        body: convert.jsonEncode(params),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        });

    var jsonResponse = await convert.jsonDecode(response.body);
    if (response.statusCode == 200) {
      print('login login TODOUSER REGISTER $jsonResponse');
      bool success = jsonResponse['success'];

      if (!success) {
        throw {
          "error": false,
          "error_type": "${jsonResponse['error_type'] ?? ''}",
          "status": jsonResponse['status']
        };
      }

      final user = jsonResponse['user'];
      print(user);
      await prefs.setString('accessToken', user['token']);
      await prefs.setString('user', convert.jsonEncode(user));
    } else {
      throw {"error": true, "error_type": "dynamic", "status": "$jsonResponse"};
    }
  }

  @override
  Future<User?> socialLogin(
      {String? email,
      String? loginType,
      String? token,
      dynamic otherDetails}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map params = {
      "user": {
        "email": email,
        "login_type": loginType,
        "token": token,
        "otherDetails": otherDetails
      }
    };
    print("PRARMARMR ++++++++");
    print(params);

    var response = await http.post(
        Uri.parse("${Constants.siteURL}/auth/social-login"),
        body: convert.jsonEncode(params),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        });

    var jsonResponse = await convert.jsonDecode(response.body);
    if (response.statusCode == 200) {
      bool success = jsonResponse['success'];
      var user = jsonResponse['user'];
      print('social login TODOUSER $jsonResponse');

      if (success) {
        print(
            'social login accessToken ${user['token']} ${user['token'].runtimeType}');
        await prefs.setString('accessToken', user['token']);
        await prefs.setString('user', convert.jsonEncode(user));

        print('social login accessToken ${prefs.getString('accessToken')}');

        todoUser = User.fromJson(user);

        return todoUser;
      } else {
        // need to set profile when user not yet full registered.
        if (jsonResponse['error_type'] == "no_setup_profile") {
          await prefs.setString('user', convert.jsonEncode(user));
        }

        throw {
          "error": false,
          "error_type": "${jsonResponse['error_type'] ?? ''}",
          "status": jsonResponse['status']
        };
      }
    } else {
      throw {"error": true, "error_type": "dynamic", "status": "$jsonResponse"};
    }
  }

  @override
  Future<User?> setupProfile(
      {String? firstName,
      String? lastName,
      String? mobileNumber,
      String? position,
      String? email}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map params = {
      "user": {
        "firstname": firstName,
        "lastname": lastName,
        "mobile_number": mobileNumber,
        "position": position,
        "email": email
      }
    };

    var response = await http.put(
        Uri.parse("${Constants.siteURL}/auth/setup-profile"),
        body: convert.jsonEncode(params),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        });

    var jsonResponse = await convert.jsonDecode(response.body);
    if (response.statusCode == 200) {
      bool success = jsonResponse['success'];
      var user = jsonResponse['user'];
      print('setup profile TODOUSER $jsonResponse');

      if (success) {
        await prefs.setString('accessToken', user['token']);
        await prefs.setString('user', convert.jsonEncode(user));

        todoUser = User.fromJson(user);

        return todoUser;
      } else {
        throw {
          "error": false,
          "error_type": "${jsonResponse['error_type'] ?? ''}",
          "status": jsonResponse['status']
        };
      }
    } else {
      throw {"error": true, "error_type": "dynamic", "status": "$jsonResponse"};
    }
  }

  @override
  Future<bool?> checkLicenseNumber({String? brokerLicenseNumber}) async {
    Map params = {"broker_license_number": brokerLicenseNumber};

    var response = await http.post(
        Uri.parse("${Constants.siteURL}/auth/check-license-number"),
        body: convert.jsonEncode(params),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        });

    var jsonResponse = await convert.jsonDecode(response.body);
    if (response.statusCode == 200) {
      bool? success = jsonResponse['success'];

      return success;
    } else {
      throw {"error": true, "error_type": "dynamic", "status": "$jsonResponse"};
    }
  }

  // @override
  Future<bool> loggedIn() async {
    throw UnimplementedError();
  }

  Future<User?> getUserInfo() async {
    print("ya");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final User user = await App.getUser();

    print("jsonResponse");
    var response = await http
        .get(Uri.parse("${Constants.siteURL}/api/users/${user.id}"), headers: {
      'Authorization': 'Bearer ${prefs.getString("accessToken")}',
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    });
    var jsonResponse = await convert.jsonDecode(response.body);
    print("jsonResponse");
    print(jsonResponse);
    if (response.statusCode == 200) {
      var user = jsonResponse;
      print("USERRR");
      print(user);
      if (user is Map && user.containsKey("_id")) {
        await prefs.setString('user', convert.jsonEncode(user));
        todoUser = User.fromJson(user as Map<String, dynamic>);

        return todoUser;
      } else {
        throw {
          "error": false,
          "error_type": "error_fetching_profile",
          "status": jsonResponse['status']
        };
      }
    } else if (response.statusCode == 401) {
      await App.logOutUser();
      throw {
        "error": false,
        "error_type": "unauthorized",
        "status": "Unauthorized. Logging out!"
      };
    } else {
      throw {
        "error": false,
        "error_type": "dynamic",
        "status": "$jsonResponse"
      };
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    User _user = await App.getUser();

    var response = await http.post(
        Uri.parse(
            "${Constants.siteURL}/api/email_verification/send-email-verification"),
        body: convert.jsonEncode({"email": _user.email, "user_id": _user.id}),
        headers: {
          'Authorization': 'Bearer ${prefs.getString("accessToken")}',
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        });
    var jsonResponse = await convert.jsonDecode(response.body);
    print("jsonResponse");
    print(jsonResponse);
    if (response.statusCode == 200) {
      if (jsonResponse is Map) {
        if (jsonResponse.containsKey('success') && !jsonResponse['success']) {
          print("SULOD DIR");
          throw {
            "error": false,
            "error_type": "error_sending_email_verification",
            "status": "Can't send email verification. Please try again."
          };
        }
      }
    } else if (response.statusCode == 401) {
      throw {
        "error": false,
        "error_type": "unauthorized",
        "status": "Unauthorized. Signing out!"
      };
    } else {
      throw {"error": true, "error_type": "dynamic", "status": "$jsonResponse"};
    }
  }
}
