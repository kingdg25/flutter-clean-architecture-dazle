import 'dart:convert' as convert;
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/connections.dart';
import '../../domain/entities/invite_tile.dart';
import '../../domain/entities/my_connection_tile.dart';
import '../../domain/entities/property.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/connection_repository.dart';
import '../constants.dart';

class DataConnectionRepository extends ConnectionRepository {
  List<InviteTile>? invites;
  List<MyConnectionTile>? myConnection;
  List<Connections>? connections;
  List<String>? userSearch;

  late User agentInfo;

  List<Connections> shuffle(List<Connections> brokers) {
    var rand = new Random();
    for (var i = brokers.length - 1; i > 0; i--) {
      var n = rand.nextInt(i + 1);

      var temp = brokers[i];
      brokers[i] = brokers[n];
      brokers[n] = temp;
    }

    return brokers;
  }

  static DataConnectionRepository _instance =
      DataConnectionRepository._internal();
  DataConnectionRepository._internal() {
    invites = <InviteTile>[];
    myConnection = <MyConnectionTile>[];
    userSearch = <String>[];
  }
  factory DataConnectionRepository() => _instance;

  @override
  Future<void> notifyUser({String? email, String? mobileNumber}) async {
    Map params = {"email": email, "mobile_number": mobileNumber};

    var response = await http.post(
        Uri.parse("${Constants.siteURL}/notification/notify-user"),
        body: convert.jsonEncode(params),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        });

    var jsonResponse = await convert.jsonDecode(response.body);
    if (response.statusCode == 200) {
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
  Future<List<InviteTile>?> readInvites(
      {String? email, String? filterByName}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map params = {"email": email, "filter_by_name": filterByName};

    var response = await http.post(
        Uri.parse("${Constants.siteURL}/api/connection/read-invite"),
        body: convert.jsonEncode(params),
        headers: {
          'Authorization': 'Bearer ${prefs.getString("accessToken")}',
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        }).timeout(
      const Duration(seconds: 20),
      onTimeout: () {
        throw {"error": true, "error_type": "dynamic", "status": "Timeout"};
      },
    );

    var jsonResponse = await convert.jsonDecode(response.body);
    if (response.statusCode == 200) {
      bool success = jsonResponse['success'];
      var invitesData = jsonResponse['invites'];

      if (success) {
        print('readInvites readInvites readInvites $jsonResponse');
        invites = List<InviteTile>.from(
            invitesData.map((i) => InviteTile.fromJson(i)));
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

    return invites;
  }

  @override
  Future<List<MyConnectionTile>?> readMyConnection(
      {String? email, String? filterByName}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map params = {"email": email, "filter_by_name": filterByName};

    var response = await http.post(
        Uri.parse("${Constants.siteURL}/api/connection/read-my-connection"),
        body: convert.jsonEncode(params),
        headers: {
          'Authorization': 'Bearer ${prefs.getString("accessToken")}',
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        }).timeout(
      const Duration(seconds: 20),
      onTimeout: () {
        throw {"error": true, "error_type": "dynamic", "status": "Timeout"};
      },
    );

    var jsonResponse = await convert.jsonDecode(response.body);
    if (response.statusCode == 200) {
      bool success = jsonResponse['success'];
      var myConnectionData = jsonResponse['my_connection'];

      if (success) {
        print(
            'readMyConnection readMyConnection readMyConnection $jsonResponse');
        myConnection = List<MyConnectionTile>.from(
            myConnectionData.map((i) => MyConnectionTile.fromJson(i)));
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

    return myConnection;
  }

  @override
  Future<void> addConnection({String? userId, String? invitedId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map params = {"user_id": userId, "invited_id": invitedId};

    var response = await http.post(
        Uri.parse("${Constants.siteURL}/api/connection/add-connection"),
        body: convert.jsonEncode(params),
        headers: {
          'Authorization': 'Bearer ${prefs.getString("accessToken")}',
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        });

    var jsonResponse = await convert.jsonDecode(response.body);
    if (response.statusCode == 200) {
      bool success = jsonResponse['success'];

      if (success) {
        invites!
            .removeWhere((element) => element.id == invitedId); // remove in UI
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
  Future<void> removeConnection({String? userId, String? invitedId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    myConnection!
        .removeWhere((element) => element.id == invitedId); // remove in UI

    Map params = {"user_id": userId, "invited_id": invitedId};

    var response = await http.post(
        Uri.parse("${Constants.siteURL}/api/connection/remove-connection"),
        body: convert.jsonEncode(params),
        headers: {
          'Authorization': 'Bearer ${prefs.getString("accessToken")}',
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        });

    var jsonResponse = await convert.jsonDecode(response.body);
    if (response.statusCode == 200) {
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
  Future<List<String>?> searchUser(
      {String? userId, String? pattern, bool? invited}) async {
    // if (userDetail.firstName.toLowerCase().contains(text.toLowerCase()) || userDetail.lastName.toLowerCase().contains(text.toLowerCase()))
    print('searUSer pattern $pattern');

    Map params = {
      "user_id": userId,
      "pattern": pattern,
      "invited":
          invited // if true search sa my connection else search sa invites
    };

    var response = await http.post(
        Uri.parse("${Constants.siteURL}/api/connection/search-user"),
        body: convert.jsonEncode(params),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        });

    var jsonResponse = await convert.jsonDecode(response.body);
    if (response.statusCode == 200) {
      bool success = jsonResponse['success'];
      List? data = jsonResponse['data'];

      print('searchInvites searchInvites searchInvites $jsonResponse');

      if (success) {
        userSearch = data!.map((e) => e.toString()).toList();
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

    return userSearch;
  }

  @override
  Future<List<Connections>?> readConnections(
      {String? email, String? filterByName}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map params = {"email": email, "filter_by_name": filterByName};

    var response = await http.post(
            Uri.parse("${Constants.siteURL}/api/connection/connections"),
            body: convert.jsonEncode(params),
            headers: {
          'Authorization': 'Bearer ${prefs.getString("accessToken")}',
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        }) // if this duration reached then show button
        // [`failed to load. try again`]
        .timeout(
      const Duration(seconds: 20),
      onTimeout: () {
        throw {"error": true, "error_type": "dynamic", "status": "Timeout"};
      },
    );

    var jsonResponse = await convert.jsonDecode(response.body);
    if (response.statusCode == 200) {
      bool success = jsonResponse['success'];
      var myConnectionData = jsonResponse['connectBrokers'];

      if (success) {
        connections = List<Connections>.from(
          myConnectionData.map(
            (i) {
              return Connections.fromJson(i);
            },
          ),
        );
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

    return shuffle(connections!);
  }

  @override
  Future<List<Property>> getAgentListings({uid}) async {
    final List<Property> listings = <Property>[];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http.get(
        Uri.parse("${Constants.siteURL}/api/listings/my-listings?user_id=$uid"),
        headers: {
          'Authorization': 'Bearer ${prefs.getString("accessToken")}',
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        });
    var jsonResponse = await convert.jsonDecode(response.body);
    if (response.statusCode == 200) {
      jsonResponse['listings'].forEach((val) {
        final price = val['price'];
        final area = val['total_area'];
        String priceVar = '$price';
        String areaVar = '$area';
        double parsedPrice = double.parse(priceVar);
        double parsedArea = double.parse(areaVar);
        val['price'] = parsedPrice;
        val['total_area'] = parsedArea;

        listings.add(Property.fromJson(val));
      });
    } else {
      throw {"error": true, "error_type": "dynamic", "status": "$jsonResponse"};
    }
    return listings;
  }

  @override
  Future<User> getAgentInfo({uid}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var response = await http
        .get(Uri.parse("${Constants.siteURL}/api/users/$uid"), headers: {
      'Authorization': 'Bearer ${pref.getString("accessToken")}',
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    });
    var jsonResponse = await convert.jsonDecode(response.body);

    if (response.statusCode == 200) {
      var user = jsonResponse;

      if (user is Map && user.containsKey("_id")) {
        await pref.setString('agent', convert.jsonEncode(user));
        agentInfo = User.fromJson(user as Map<String, dynamic>);

        return agentInfo;
      } else {
        throw {
          "error": false,
          "error_type": "error_fetching_profile",
          "status": jsonResponse['status']
        };
      }
    } else {
      throw {
        "error": false,
        "error_type": "dynamic",
        "status": "$jsonResponse"
      };
    }
  }
}
