import 'dart:convert' as convert;
import 'package:dazle/domain/entities/invite_tile.dart';
import 'package:dazle/domain/entities/my_connection_tile.dart';
import 'package:http/http.dart' as http;
import 'package:dazle/data/constants.dart';
import 'package:dazle/domain/repositories/connection_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataConnectionRepository extends ConnectionRepository {
  List<InviteTile> invites;
  List<MyConnectionTile> myConnection;
  List<String> userSearch;

  static DataConnectionRepository _instance = DataConnectionRepository._internal();
  DataConnectionRepository._internal() {
    invites = <InviteTile>[];
    myConnection = <MyConnectionTile>[];
    userSearch = <String>[];
  }
  factory DataConnectionRepository() => _instance;


  @override
  Future<void> notifyUser({String email, String mobileNumber}) async {
    Map params = {
      "email": email,
      "mobile_number": mobileNumber
    };

    var response = await http.post(
      "${Constants.siteURL}/notification/notify-user",
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
  Future<List<InviteTile>> readInvites({String email, String filterByName}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map params = {
      "email": email,
      "filter_by_name": filterByName
    };

    var response = await http.post(
      "${Constants.siteURL}/api/connection/read-invite",
      body: convert.jsonEncode(params),
      headers: {
        'Authorization': 'Bearer ${prefs.getString("accessToken")}',
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

  @override
  Future<List<MyConnectionTile>> readMyConnection({String email, String filterByName}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map params = {
      "email": email,
      "filter_by_name": filterByName
    };

    var response = await http.post(
      "${Constants.siteURL}/api/connection/read-my-connection",
      body: convert.jsonEncode(params),
      headers: {
        'Authorization': 'Bearer ${prefs.getString("accessToken")}',
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      }
    );

    var jsonResponse = await convert.jsonDecode(response.body);
    if (response.statusCode == 200){
      bool success = jsonResponse['success'];
      var myConnectionData = jsonResponse['my_connection'];

      if(success) {
        print('readMyConnection readMyConnection readMyConnection $jsonResponse');
        myConnection = List<MyConnectionTile>.from(myConnectionData.map((i) => MyConnectionTile.fromJson(i)));
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

    return myConnection;
  }

  @override
  Future<void> addConnection({String userId, String invitedId}) async {
    Map params = {
      "user_id": userId,
      "invited_id": invitedId
    };

    var response = await http.post(
      "${Constants.siteURL}/api/connection/add-connection",
      body: convert.jsonEncode(params),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      }
    );

    var jsonResponse = await convert.jsonDecode(response.body);
    if (response.statusCode == 200){
      bool success = jsonResponse['success'];

      if (success) {
        invites.removeWhere((element) => element.id == invitedId); // remove in UI
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
  Future<void> removeConnection({String userId, String invitedId}) async {
    print(myConnection);
    myConnection.removeWhere((element) => element.id == invitedId); // remove in UI

    Map params = {
      "user_id": userId,
      "invited_id": invitedId
    };

    var response = await http.post(
      "${Constants.siteURL}/api/connection/remove-connection",
      body: convert.jsonEncode(params),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      }
    );

    var jsonResponse = await convert.jsonDecode(response.body);
    if (response.statusCode == 200){
      bool success = jsonResponse['success'];

      if (!success){
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
  Future<List<String>> searchUser({String userId, String pattern, bool invited}) async {
    // if (userDetail.firstName.toLowerCase().contains(text.toLowerCase()) || userDetail.lastName.toLowerCase().contains(text.toLowerCase()))
    print('searUSer pattern $pattern');

    Map params = {
      "user_id": userId,
      "pattern": pattern,
      "invited": invited // if true search sa my connection else search sa invites
    };

    var response = await http.post(
      "${Constants.siteURL}/api/connection/search-user",
      body: convert.jsonEncode(params),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      }
    );

    var jsonResponse = await convert.jsonDecode(response.body);
    if (response.statusCode == 200){
      bool success = jsonResponse['success'];
      List data = jsonResponse['data'];

      print('searchInvites searchInvites searchInvites $jsonResponse');

      if (success){
        userSearch = data.map((e) => e.toString()).toList();
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

    return userSearch;
  }
  
}