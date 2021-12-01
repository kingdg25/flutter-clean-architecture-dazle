import 'dart:convert' as convert;
import 'package:dazle/domain/entities/invite_tile.dart';
import 'package:http/http.dart' as http;
import 'package:dazle/data/constants.dart';
import 'package:dazle/domain/repositories/connection_repository.dart';

class DataConnectionRepository extends ConnectionRepository {
  List<InviteTile> invites;

  static DataConnectionRepository _instance = DataConnectionRepository._internal();
  DataConnectionRepository._internal() {
    invites = <InviteTile>[];
  }
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

  @override
  Future<List<InviteTile>> readInvites({String email}) async {
    // Map params = {
    //   "email": email
    // };

    var response = await http.get(
      "${Constants.siteURL}/api/connection/read-invite",
      // body: convert.jsonEncode(params),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      }
    );

    var jsonResponse = await convert.jsonDecode(response.body);
    if (response.statusCode == 200){
      bool success = jsonResponse['success'];
      var invitesData = jsonResponse['invites'];

      if(success) {
        print('readInvites readInvites readInvites $jsonResponse');
        invites = List<InviteTile>.from(invitesData.map((i) => InviteTile.fromJson(i)));
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

    return invites;
  }
  
}