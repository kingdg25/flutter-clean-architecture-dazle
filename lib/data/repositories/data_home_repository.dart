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
      PhotoTile(photoURL: '', text: 'Near you'),
      PhotoTile(photoURL: 'http://via.placeholder.com/200x150', text: 'Lorem Ipsum'),
      PhotoTile(photoURL: 'http://via.placeholder.com/350x150', text: 'text'),
      PhotoTile(photoURL: 'https://images.unsplash.com/photo-1532264523420-881a47db012d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9', text: 'text2'),
      PhotoTile(photoURL: 'https://picsum.photos/250?image=9', text: 'text3')
    ];
  }

  @override
  Future<List<Property>> getMatchedProperties() async {
    return [
      Property(
        photoURL: 'https://picsum.photos/200/300',
        keywords: ['keywords1', 'keywords2'],
        amount: '1,500,000.00',
        totalBedRoom: '99',
        totalBathRoom: '3',
        totalParkingSpace: '1',
        totalArea: '1200',
      ),
      Property(
        photoURL: 'https://picsum.photos/200/300',
        keywords: ['one', 'two'],
        amount: '8,786,123.00',
        totalBedRoom: '1',
        totalBathRoom: '2',
        totalParkingSpace: '3',
        totalArea: '500',
      ),
      Property(
        photoURL: 'https://picsum.photos/200/300',
        keywords: ['qwe', 'asd'],
        amount: '300,123.12',
        totalBedRoom: '9',
        totalBathRoom: '8',
        totalParkingSpace: '7',
        totalArea: '654',
      )
    ];
  }

  @override
  Future<List<PhotoTile>> getWhyBrooky() async {
    return [
      PhotoTile(photoURL: '', text: ''),
      PhotoTile(photoURL: '', text: ''),
      PhotoTile(photoURL: '', text: ''),
    ];
  }
  
  @override
  Future<List<Property>> getNewHomes() async {
    return [
      Property(
        photoURL: 'https://picsum.photos/id/237/200/300',
        keywords: ['qqq', 'www'],
        amount: '9,999,999.99',
        totalBedRoom: '81',
        totalBathRoom: '41',
        totalParkingSpace: '0',
        totalArea: '100',
      ),
      Property(
        photoURL: 'https://picsum.photos/id/132/200/300',
        keywords: ['aaa', 'ssss'],
        amount: '1,234,567.00',
        totalBedRoom: '9',
        totalBathRoom: '42',
        totalParkingSpace: '16',
        totalArea: '1,000',
      ),
      Property(
        photoURL: 'https://picsum.photos/id/456/200/300',
        keywords: ['ddd', 'dddd'],
        amount: '540,735.12',
        totalBedRoom: '88',
        totalBathRoom: '51',
        totalParkingSpace: '90',
        totalArea: '987',
      )
    ];
  }
  
}