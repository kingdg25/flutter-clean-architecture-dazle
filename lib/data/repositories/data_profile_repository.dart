import 'dart:convert' as convert;
// import 'dart:typed_data';
import 'package:dazle/app/utils/app_constant.dart';
import 'package:dazle/data/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
// import 'package:path/path.dart';
import 'package:dazle/app/utils/app.dart';

import 'package:dazle/domain/entities/user.dart';
import 'package:dazle/domain/repositories/profile_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataProfileRepository extends ProfileRepository {
  final double maxFileSize = 12.0;

  static DataProfileRepository _instance = DataProfileRepository._internal();
  DataProfileRepository._internal();
  factory DataProfileRepository() => _instance;

  @override
  Future<void> deleteAccount({String? userId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var response = await http.delete(
        Uri.parse("${Constants.siteURL}/api/users/delete-account/$userId"),
        headers: {
          'Authorization': 'Bearer ${prefs.getString("accessToken")}',
          'Content-Type': 'application/json'
        });

    var jsonResponse = await convert.jsonDecode(response.body);

    if (response.statusCode == 200) {
      print(jsonResponse);
      bool success = jsonResponse['success'];

      if (success == false) {
        throw {
          "error": false,
          "error_type": "${jsonResponse['error_type'] ?? ''}",
          "status": jsonResponse['status']
        };
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

  @override
  Future<String> checkLoginType({User? user}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('Activate/Deactivate user: ${user!.toJson()}');

    Map params = {"user": user.toJson()};

    var response = await http.put(
        Uri.parse("${Constants.siteURL}/api/users/check-login-type"),
        body: convert.jsonEncode(params),
        headers: {
          'Authorization': 'Bearer ${prefs.getString("accessToken")}',
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        });

    var jsonResponse = await convert.jsonDecode(response.body);
    if (response.statusCode == 200) {
      print('check login type: $jsonResponse');
      bool success = jsonResponse['success'];
      String loginType = jsonResponse['login_type'];

      if (success) {
        return loginType;
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
  Future<void> deactivateActivateAccount({User? user}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('Activate/Deactivate user: ${user!.toJson()}');

    Map params = {"user": user.toJson()};

    var response = await http.put(
        Uri.parse("${Constants.siteURL}/api/users/deactivate-activate-account"),
        body: convert.jsonEncode(params),
        headers: {
          'Authorization': 'Bearer ${prefs.getString("accessToken")}',
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        });

    var jsonResponse = await convert.jsonDecode(response.body);
    if (response.statusCode == 200) {
      print('deactivate/activate $jsonResponse');
      bool success = jsonResponse['success'];
      var resUser = jsonResponse['user'];

      if (success) {
        await prefs.setString('user', convert.jsonEncode(resUser));
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
  Future<UserFeedback> createFeedback({UserFeedback? feedback}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final user = await App.getUser();
    final uid = user.id;

    if (uid != null) {
      Map params = {
        "feedback": feedback!.toJson(),
      };

      var response = await http.post(
          Uri.parse("${Constants.siteURL}/api/feedbacks/create-feedback"),
          body: convert.jsonEncode(params),
          headers: {
            'Authorization': 'Bearer ${prefs.getString("accessToken")}',
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          });

      var jsonResponse = await convert.jsonDecode(response.body);
      print(jsonResponse);
      print(response.statusCode);

      if (response.statusCode == 200) {
        final Map createFeedbackRequest = jsonResponse["feedback"];

        final UserFeedback feedbaclInstance = UserFeedback.fromJson(
            createFeedbackRequest as Map<String, dynamic>);

        print(feedbaclInstance.toJson());

        return feedbaclInstance;
      } else {
        throw {
          "error": true,
          "error_type": "server_error",
          "status": "Feedback was not created."
        };
      }
    } else {
      throw {
        "error": false,
        "error_type": "dynamic",
        "status": "Has no user _id"
      };
    }
  }

  @override
  Future<void> update({User? user, File? profilePicture}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('UPDATED USER: ${user!.toJson()}');
    print(prefs.getString("accessToken"));

    if (profilePicture != null) {
      String? imageUrl =
          await AppConstant().getFileUrl(attachment: profilePicture);
      user.profilePicture = imageUrl;
    }

    Map params = {"user": user.toJson()};

    var response = await http.put(
        Uri.parse("${Constants.siteURL}/api/users/update"),
        body: convert.jsonEncode(params),
        headers: {
          'Authorization': 'Bearer ${prefs.getString("accessToken")}',
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        });

    var jsonResponse = await convert.jsonDecode(response.body);
    if (response.statusCode == 200) {
      print('update update $jsonResponse');
      bool success = jsonResponse['success'];
      var resUser = jsonResponse['user'];

      if (success) {
        await prefs.setString('user', convert.jsonEncode(resUser));
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
  Future<Verification> requestVerification({File? attachment}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? imageUrl = await AppConstant().getFileUrl(attachment: attachment!);

    final user = await App.getUser();
    final uid = user.id;

    Verification verification = Verification(userId: uid, attachment: imageUrl);

    if (uid != null) {
      Map params = {
        "verification": verification.toJson(),
      };

      var response = await http.post(
          Uri.parse(
              "${Constants.siteURL}/api/verifications/create-verification"),
          body: convert.jsonEncode(params),
          headers: {
            'Authorization': 'Bearer ${prefs.getString("accessToken")}',
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          });

      var jsonResponse = await convert.jsonDecode(response.body);
      print(jsonResponse);
      print(response.statusCode);

      if (response.statusCode == 200) {
        final Map verificationRequest = jsonResponse["property"];

        final Verification verificationInstance =
            Verification.fromJson(verificationRequest as Map<String, dynamic>);

        print(verificationInstance.toJson());

        return verificationInstance;
      } else {
        throw {
          "error": true,
          "error_type": "server_error",
          "status": "Request for Verification not created."
        };
      }
    } else {
      throw {
        "error": false,
        "error_type": "dynamic",
        "status": "Has no user _id"
      };
    }
  }
}
