import 'dart:convert' as convert;
import 'package:dazle/domain/entities/photo_tile.dart';
import 'package:dazle/domain/entities/property.dart';
import 'package:http/http.dart' as http;

import 'package:dazle/domain/repositories/home_repository.dart';
import 'package:dazle/data/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';



class DataHomeRepository extends HomeRepository {
  List<PhotoTile> spotLight;
  List<Property> matchedProperties;
  List<PhotoTile> whyBrooky;
  List<Property> newHomes;

  static DataHomeRepository _instance = DataHomeRepository._internal();
  DataHomeRepository._internal() {
    spotLight = <PhotoTile>[];
    matchedProperties = <Property>[];
    whyBrooky = <PhotoTile>[];
    newHomes = <Property>[];
  }
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
  Future<List<PhotoTile>> getSpotLight() async {
    return [
      PhotoTile('', 'Near you'),
      PhotoTile('http://via.placeholder.com/200x150', 'Lorem Ipsum'),
      PhotoTile('http://via.placeholder.com/350x150', 'text'),
      PhotoTile('https://images.unsplash.com/photo-1532264523420-881a47db012d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9', 'text2'),
      PhotoTile('https://picsum.photos/250?image=9', 'text3')
    ];
  }

  @override
  Future<List<Property>> getMatchedProperties() async {
    return [
      Property(
        'https://picsum.photos/200/300',
        ['keywords1', 'keywords2'],
        '1,500,000.00',
        '99',
        '3',
        '1',
        '1200 sqft',
        '',
        ''
      ),
      Property(
        'https://picsum.photos/200/300',
        ['one', 'two'],
        '8,786,123.00',
        '1',
        '2',
        '3',
        '500 sqft',
        '',
        ''
      ),
      Property(
        'https://picsum.photos/200/300',
        ['qwe', 'asd'],
        '300,123.12',
        '9',
        '8',
        '7',
        '654 sqft',
        '',
        ''
      )
    ];
  }

  @override
  Future<List<PhotoTile>> getWhyBrooky() async {
    return [
      PhotoTile('', ''),
      PhotoTile('', ''),
      PhotoTile('', ''),
    ];
  }
  
  @override
  Future<List<Property>> getNewHomes() async {
    return [
      Property(
        'https://picsum.photos/id/237/200/300',
        ['qqq', 'www'],
        '9,999,999.99',
        '81',
        '41',
        '0',
        '100 sqft',
        '',
        ''
      ),
      Property(
        'https://picsum.photos/id/132/200/300',
        ['aaa', 'ssss'],
        '1,234,567.00',
        '9',
        '42',
        '16',
        '1,000 sqft',
        '',
        ''
      ),
      Property(
        'https://picsum.photos/id/456/200/300',
        ['ddd', 'dddd'],
        '540,735.12',
        '88',
        '51',
        '90',
        '987 sqft',
        '',
        ''
      )
    ];
  }
  
}