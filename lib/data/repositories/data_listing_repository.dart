import 'package:dazle/app/utils/app.dart';
import 'package:dazle/data/constants.dart';
import 'package:dazle/domain/entities/property.dart';
import 'package:dazle/domain/repositories/listing_repository.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'dart:typed_data';

// import '../../app/utils/app_constant.dart';

class DataListingRepository extends ListingRepository {
  List<Property>? myListing;
  List<Property>? myCollection;
  final double maxFileSize = 10.0;

  static DataListingRepository _instance = DataListingRepository._internal();
  DataListingRepository._internal() {
    myListing = <Property>[];
    myCollection = <Property>[];
  }
  factory DataListingRepository() => _instance;

  @override
  Future<void> deleteAllUserListing({String? createdById}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var response = await http.delete(
        Uri.parse(
            "${Constants.siteURL}/api/listings/delete-all-user-listings/$createdById"),
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
  //======================= CREATE LISTING[START]
  Future<Property> create({Map? listing}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List imageUrls = await _getFileUrls(assetsBase64: listing!['assets']);

    listing['photos'] = imageUrls;
    listing.remove("assets");

    final user = await App.getUser();
    final uid = user.id;

    if (uid != null) {
      listing['createdBy'] = uid;
      Map params = {
        "property": listing,
        "user_token": prefs.getString("accessToken")
      };

      var response = await http.post(
          Uri.parse("${Constants.siteURL}/api/listings/create-listing"),
          body: convert.jsonEncode(params),
          headers: {
            'Authorization': 'Bearer ${prefs.getString("accessToken")}',
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          });

      var jsonResponse = await convert.jsonDecode(response.body);
      print(jsonResponse);
      if (response.statusCode == 200) {
        final Map property = jsonResponse["property"];

        // converts int to double
        final price = property['price'];
        final area = property['total_area'];
        final floorArea = property['floor_area'];
        final frontageArea = property['frontage_area'];
        String priceVar = '$price';
        String areaVar = '$area';
        String floorAreaVar = '$floorArea';
        String frontageAreaVar = '$frontageArea';
        double parsedPrice = double.parse(priceVar);
        double parsedArea = double.parse(areaVar);
        double parsedFloorArea = double.parse(floorAreaVar);
        double parsedFrontageArea = double.parse(frontageAreaVar);
        property['price'] = parsedPrice;
        property['total_area'] = parsedArea;
        property['floor_area'] = parsedFloorArea;
        property['frontage_area'] = parsedFrontageArea;

        print(property['createdAt'].runtimeType);
        print(property['createdAt']);

        final Property propertyInstance =
            Property.fromJson(property as Map<String, dynamic>);

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
  } //======================= CREATE LISTING[END]

  @override
  Future<List<Property>> getMyListing() async {
    final List<Property> listings = <Property>[];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final user = await App.getUser();
    final uid = user.id;

    if (uid == null) {
      throw {
        "error": false,
        "error_type": "dynamic",
        "status": "Has no user _id"
      };
    }

    var response = await http.get(
        Uri.parse("${Constants.siteURL}/api/listings/my-listings?user_id=$uid"),
        headers: {
          'Authorization': 'Bearer ${prefs.getString("accessToken")}',
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        });

    var jsonResponse = await convert.jsonDecode(response.body);
    print("LISTING YOW");
    if (response.statusCode == 200) {
      print('Listing length: ${jsonResponse['listings'].length}');
      jsonResponse['listings'].forEach((val) {
        final price = val['price'];
        final area = val['total_area'];
        final floorArea = val['floor_area'];
        final frontageArea = val['frontage_area'];
        String priceVar = '$price';
        String areaVar = '$area';
        String floorAreaVar = '$floorArea';
        String frontageAreaVar = '$frontageArea';
        double parsedPrice = double.parse(priceVar);
        double parsedArea = double.parse(areaVar);
        double parsedFloorArea = double.parse(floorAreaVar);
        double parsedFrontageArea = double.parse(frontageAreaVar);
        val['price'] = parsedPrice;
        val['total_area'] = parsedArea;
        val['floor_area'] = parsedFloorArea;
        val['frontage_area'] = parsedFrontageArea;
        print(val);
        listings.add(Property.fromJson(val));
      });
    } else if (response.statusCode == 401) {
      throw {
        "error": false,
        "error_type": "unauthorized",
        "status": "Unauthorized. Signing out!"
      };
    } else {
      throw {"error": true, "error_type": "dynamic", "status": "$jsonResponse"};
    }
    return listings;

    // return [
    //   Property(
    //       coverPhoto: 'https://picsum.photos/id/73/200/300',
    //       photos: [
    //         'https://picsum.photos/id/70/200/300',
    //         'https://picsum.photos/id/71/200/300',
    //         'https://picsum.photos/id/72/200/300',
    //       ],
    //       keywords: ['aa', 'ss'],
    //       price: '540,735.12',
    //       totalBedRoom: '213',
    //       totalBathRoom: '321',
    //       totalParkingSpace: '22',
    //       totalArea: '432',
    //       district: 'Lapasan',
    //       city: 'Cagayan de Oro City',
    //       amenities: ['Shared Gym', 'Covered Parking', 'Central AC'],
    //       isYourProperty: 'unfurnished',
    //       timePeriod: 'month',
    //       description:
    //           "Property Description: Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s")
    // ];
  }

  @override
  Future<List<Property>> getUserListings({uid}) async {
    final List<Property> listings = <Property>[];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final user = await App.getUser();
    final viewerId = user.id;

    if (viewerId == null) {
      throw {
        "error": false,
        "error_type": "dynamic",
        "status": "No user id found. Loggin out."
      };
    }

    var response = await http.get(
        Uri.parse(
            "${Constants.siteURL}/api/listings/get-listings-in-profile/$uid/$viewerId"),
        headers: {
          'Authorization': 'Bearer ${prefs.getString("accessToken")}',
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        });

    var jsonResponse = await convert.jsonDecode(response.body);
    print("LISTING YOW");
    if (response.statusCode == 200) {
      print(jsonResponse['listings'].length);
      jsonResponse['listings'].forEach((val) {
        final price = val['price'];
        final area = val['total_area'];
        final floorArea = val['floor_area'];
        final frontageArea = val['frontage_area'];
        String priceVar = '$price';
        String areaVar = '$area';
        String floorAreaVar = '$floorArea';
        String frontageAreaVar = '$frontageArea';
        double parsedPrice = double.parse(priceVar);
        double parsedArea = double.parse(areaVar);
        double parsedFloorArea = double.parse(floorAreaVar);
        double parsedFrontageArea = double.parse(frontageAreaVar);
        val['price'] = parsedPrice;
        val['total_area'] = parsedArea;
        val['floor_area'] = parsedFloorArea;
        val['frontage_area'] = parsedFrontageArea;
        print(val);
        listings.add(Property.fromJson(val));
      });
    } else {
      throw {"error": true, "error_type": "dynamic", "status": "$jsonResponse"};
    }
    return listings;

    // return [
    //   Property(
    //       coverPhoto: 'https://picsum.photos/id/73/200/300',
    //       photos: [
    //         'https://picsum.photos/id/70/200/300',
    //         'https://picsum.photos/id/71/200/300',
    //         'https://picsum.photos/id/72/200/300',
    //       ],
    //       keywords: ['aa', 'ss'],
    //       price: '540,735.12',
    //       totalBedRoom: '213',
    //       totalBathRoom: '321',
    //       totalParkingSpace: '22',
    //       totalArea: '432',
    //       district: 'Lapasan',
    //       city: 'Cagayan de Oro City',
    //       amenities: ['Shared Gym', 'Covered Parking', 'Central AC'],
    //       isYourProperty: 'unfurnished',
    //       timePeriod: 'month',
    //       description:
    //           "Property Description: Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s"),
    //   Property(
    //       coverPhoto: 'https://picsum.photos/id/73/200/300',
    //       photos: [
    //         'https://picsum.photos/id/70/200/300',
    //         'https://picsum.photos/id/71/200/300',
    //         'https://picsum.photos/id/72/200/300',
    //       ],
    //       keywords: ['aa', 'ss'],
    //       price: '540,735.12',
    //       totalBedRoom: '213',
    //       totalBathRoom: '321',
    //       totalParkingSpace: '22',
    //       totalArea: '432',
    //       district: 'Lapasan',
    //       city: 'Cagayan de Oro City',
    //       amenities: ['Shared Gym', 'Covered Parking', 'Central AC'],
    //       isYourProperty: 'unfurnished',
    //       timePeriod: 'month',
    //       description:
    //           "Property Description: Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s")
    // ];
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
          price: 664321.12,
          totalBedRoom: '11',
          totalBathRoom: '22',
          totalParkingSpace: '33',
          totalArea: 64,
          district: 'Lapasan',
          city: 'Cagayan de Oro City',
          amenities: ['Kitchen', 'Wifi', 'Eco Friendly', 'Security'],
          isYourProperty: 'furnished',
          timePeriod: 'year',
          description:
              "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.")
    ];
  }

  Future<List<String?>> _getFileUrls({required List assetsBase64}) async {
    List<String?> urls = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await Future.forEach(assetsBase64, (dynamic d) async {
      print('Asset: $d');
      _checkFileSize(base64: d['image'], fileName: d['name']);

      //===Compress image size [start]
      Uint8List bytes = convert.base64Decode(d['image']);
      Uint8List compressedImageBytes = await _compressAsset(bytes);
      //===Compress image size [end]

      print('Compressed Asset: $compressedImageBytes');
      String compressedBase64Asset = convert.base64Encode(compressedImageBytes);
      var response = await http.post(
          Uri.parse("${Constants.siteURL}/api/s3/upload-file-from-base64"),
          body: convert.jsonEncode(
              {"filename": d['name'], "base64": compressedBase64Asset}),
          headers: {
            'Authorization': 'Bearer ${prefs.getString("accessToken")}',
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          });
      var jsonResponse = await convert.jsonDecode(response.body);
      if (response.statusCode == 200) {
        urls.add(jsonResponse['data']['file_url']);
      } else {
        throw {
          "error": true,
          "error_type": "server_error",
          "status": "Listing not created."
        };
      }
    });
    return urls;
  }

  void _checkFileSize({required String base64, String? fileName}) {
    Uint8List bytes = convert.base64Decode(base64);
    double sizeInMB = bytes.length / 1000000;
    print(maxFileSize);
    if (sizeInMB > this.maxFileSize) {
      throw {
        "error": false,
        "error_type": "filesize_error",
        "status":
            "File size must not exceed ${this.maxFileSize}mb. A file $fileName has a size of ${sizeInMB.toStringAsFixed(2)} MB."
      };
    }
  }

  Future<Uint8List> _compressAsset(Uint8List list) async {
    var result = await FlutterImageCompress.compressWithList(
      list,
      quality: 90,
    );
    print('Before compression: ${list.length / 1000000}mb ');
    print('After compression: ${result.length / 1000000}mb');
    return result;
  }

  @override
  Future<Property> update({Map? data}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userToken = prefs.getString("accessToken");
    final listingId = data!['id'];
    List<String?> imageUrls;

    if (data['assets'] != null) {
      imageUrls = await _getFileUrls(assetsBase64: data['assets']);
      data.remove("assets");
      List<String?> photos = data['photos'];
      data['photos'] = [];
      List<String?> updatedPhotos = new List.from(photos)..addAll(imageUrls);
      print('updated photos : $updatedPhotos');
      data['photos'] = updatedPhotos;
    } else {
      data.remove("assets");
    }

    Map params = {"data": data};
    var response = await http.put(
        Uri.parse(
            "${Constants.siteURL}/api/listings/update-listing/$listingId"),
        body: convert.jsonEncode(params),
        headers: {
          'Authorization': 'Bearer ${userToken ?? ""}',
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        });

    var jsonResponse = await convert.jsonDecode(response.body);
    print(jsonResponse);
    if (response.statusCode == 200) {
      if (!jsonResponse['success']) {
        throw {
          "error": true,
          "error_type": jsonResponse['error_type'],
          "status": "Listing not updated."
        };
      }
      final Map property = jsonResponse["listing"];

      // converts int to double
      final price = property['price'];
      final area = property['total_area'];
      final floorArea = property['floor_area'];
      final frontageArea = property['frontage_area'];
      String priceVar = '$price';
      String areaVar = '$area';
      String floorAreaVar = '$floorArea';
      String frontageAreaVar = '$frontageArea';
      double parsedPrice = double.parse(priceVar);
      double parsedArea = double.parse(areaVar);
      double parsedFloorArea = double.parse(floorAreaVar);
      double parsedFrontageArea = double.parse(frontageAreaVar);
      property['price'] = parsedPrice;
      property['total_area'] = parsedArea;
      property['floor_area'] = parsedFloorArea;
      property['frontage_area'] = parsedFrontageArea;

      final Property propertyInstance =
          Property.fromJson(property as Map<String, dynamic>);

      return propertyInstance;
    } else {
      throw {
        "error": false,
        "error_type": "server_error",
        "status": "Listing not updated."
      };
    }
  }

  @override
  Future<Property> getListingDetails(String listingId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final Property selectedListing;

    var response = await http.get(
        Uri.parse("${Constants.siteURL}/api/listings/$listingId"),
        headers: {
          'Authorization': 'Bearer ${prefs.getString("accessToken")}',
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        });

    var jsonResponse = await convert.jsonDecode(response.body);

    if (response.statusCode == 200) {
      final Map property = jsonResponse["listing"];

      // converts int to double
      final price = property['price'];
      final area = property['total_area'];
      final floorArea = property['floor_area'];
      final frontageArea = property['frontage_area'];
      String priceVar = '$price';
      String areaVar = '$area';
      String floorAreaVar = '$floorArea';
      String frontageAreaVar = '$frontageArea';
      double parsedPrice = double.parse(priceVar);
      double parsedArea = double.parse(areaVar);
      double parsedFloorArea = double.parse(floorAreaVar);
      double parsedFrontageArea = double.parse(frontageAreaVar);
      property['price'] = parsedPrice;
      property['total_area'] = parsedArea;
      property['floor_area'] = parsedFloorArea;
      property['frontage_area'] = parsedFrontageArea;
      selectedListing = Property.fromJson(property as Map<String, dynamic>);

      print('printing selected listing');
      print(selectedListing.toString());
    } else if (response.statusCode == 401) {
      throw {
        "error": false,
        "error_type": "unauthorized",
        "status": "Unauthorized. Signing out!"
      };
    } else {
      throw {"error": true, "error_type": "dynamic", "status": "$jsonResponse"};
    }

    return selectedListing;
  }

  @override
  Future<void> deleteListing({String? listingId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var response = await http.delete(
        Uri.parse(
            "${Constants.siteURL}/api/listings/delete-listing/$listingId"),
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
}
