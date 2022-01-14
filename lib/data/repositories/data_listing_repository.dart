import 'package:dazle/app/utils/app.dart';
import 'package:dazle/data/constants.dart';
import 'package:dazle/domain/entities/property.dart';
import 'package:dazle/domain/repositories/listing_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class DataListingRepository extends ListingRepository {
  List<Property> myListing;
  List<Property> myCollection;

  static DataListingRepository _instance = DataListingRepository._internal();
  DataListingRepository._internal() {
    myListing = <Property>[];
    myCollection = <Property>[];
  }
  factory DataListingRepository() => _instance;

  @override
  Future<Property> create({Map listing}) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    // final user = convert.jsonDecode(await prefs.get('user'));

    final user = await App.getUser();
    final uid = user.id;

    if (uid!=null) {
      listing['createdBy'] = uid;
      Map params = {
      "property": listing,
      "user_token": prefs.getString("accessToken")
    };


      var response = await http.post(
        "${Constants.siteURL}/api/listings/create-listing",
        body: convert.jsonEncode(params),
        headers: {
          'Authorization': 'Bearer ${prefs.getString("accessToken")}',
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        }
      );

      var jsonResponse = await convert.jsonDecode(response.body);
      print(jsonResponse);
      if (response.statusCode == 200){
        final Map property = jsonResponse["property"];
        property['price'] = jsonResponse["property"]['price'].toString();

        print(property['createdAt'].runtimeType);
        print(property['createdAt']);
        
        final Property propertyInstance = Property.fromJson(property);

        print(propertyInstance.toJson());
        
        return propertyInstance;
      } else {
        throw {
          "error": true,
          "error_type": "server_error",
          "status": "Listing not created."
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
  Future<List<Property>> getMyListing() async {
    final List<Property> listings = <Property>[];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final user = await App.getUser();
    final uid = user.id;

    if (uid==null) {
      throw {
        "error": false,
        "error_type": "dynamic",
        "status": "Has no user _id"
      };
    }

    var response = await http.get(
        "${Constants.siteURL}/api/listings/my-listings?user_id=$uid",
        headers: {
          'Authorization': 'Bearer ${prefs.getString("accessToken")}',
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        }
    );
    
    var jsonResponse = await convert.jsonDecode(response.body);
    print("LISTING YOW");
    if (response.statusCode == 200){
      print(jsonResponse['listings'].length);
      jsonResponse['listings'].forEach((val){
        val['price'] = "${val['price'] ?? 0}";
        val['time_period'] = "${val['time_period'] ?? 0}";
        val['total_area'] = "${val['total_area'] ?? 0}";
        print(val);
        listings.add(Property.fromJson(val));
      });
    }
    print("WEWWEW");
    return listings;
    
    return [
      Property(
        coverPhoto: 'https://picsum.photos/id/73/200/300',
        photos: [
          'https://picsum.photos/id/70/200/300',
          'https://picsum.photos/id/71/200/300',
          'https://picsum.photos/id/72/200/300',
        ],
        keywords: ['aa', 'ss'],
        price: '540,735.12',
        totalBedRoom: '213',
        totalBathRoom: '321',
        totalParkingSpace: '22',
        totalArea: '432',
        district: 'Lapasan',
        city: 'Cagayan de Oro City',
        amenities: ['Shared Gym','Covered Parking','Central AC'],
        isYourProperty: 'unfurnished',
        timePeriod: 'month',
        description: "Property Description: Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s"
      )
    ];
  }
  
  @override
  Future<List<Property>> getMyCollection() async {
    return [
      Property(
        coverPhoto: 'https://picsum.photos/id/76/200/300',
        photos: [
          'https://picsum.photos/id/77/200/300',
          'https://picsum.photos/id/78/200/300',
          'https://picsum.photos/id/79/200/300',
        ],
        keywords: ['qq', 'ww'],
        price: '664,321.12',
        totalBedRoom: '11',
        totalBathRoom: '22',
        totalParkingSpace: '33',
        totalArea: '64',
        district: 'Lapasan',
        city: 'Cagayan de Oro City',
        amenities: ['Kitchen','Wifi','Eco Friendly','Security'],
        isYourProperty: 'furnished',
        timePeriod: 'year',
        description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
      )
    ];
  }

}