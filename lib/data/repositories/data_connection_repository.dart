import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:dazle/data/constants.dart';
import 'package:dazle/domain/repositories/connection_repository.dart';

class DataConnectionRepository extends ConnectionRepository {
  static DataConnectionRepository _instance = DataConnectionRepository._internal();
  DataConnectionRepository._internal();
  factory DataConnectionRepository() => _instance;


  @override
  Future<void> notifyUser({String email, String mobileNumber}) async {
    Map params = {
      "email": email,
      "mobile_number": mobileNumber
    };

    var response = await http.post(
      "${Constants.siteURL}/api/notify/notify-user",
      body: convert.jsonEncode(params),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      }
    );

    var jsonResponse = await convert.jsonDecode(response.body);
    if (response.statusCode == 200){
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
  
}