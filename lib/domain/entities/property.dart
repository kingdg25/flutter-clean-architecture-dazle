// import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class Property {
  final String? coverPhoto;
  final List? photos;
  final List? amenities;
  final List? keywords;

  final String? propertyType;
  final String? propertyFor;
  final double? price;

  final String? timePeriod;
  var totalBedRoom;
  var totalBathRoom;
  final String? totalParkingSpace;
  final double? totalArea;
  final double? frontageArea;
  final double? floorArea;

  /// furnished or unfurnished
  final String? isYourProperty;
  final String? ownership;
  final String? district;
  final String? street;
  final String? landmark;
  final String? city;
  final String? description;
  final String? createdBy;
  final String? createdAt;
  final String? updatedAt;
  final String? viewType;
  final String? id;
  final String? pricing;
  var coordinates;
  var location;
  String? title;

  NumberFormat numberFormat = NumberFormat('##,###.00');

  String? get keywordsToString {
    return keywords?.join(" • ");
  }

  String get formatPrice => numberFormat.format(price);
  String get formatArea => numberFormat.format(totalArea);
  String get formatFrontageArea => numberFormat.format(frontageArea);
  String get formatFloorArea => numberFormat.format(floorArea);
  String get priceVar => "$price";

  String get completeAddress {
    String completeAddress = '';

    if (location == null) {
      return 'No complete Address';
    }

    if (location["RoomNo"].length > 0) {
      completeAddress = completeAddress + '${location["RoomNo"]}, ';
    }
    if (location["BuildingName"].length > 0) {
      completeAddress = completeAddress + '${location["BuildingName"]}, ';
    }
    if (location["HouseNo"].length > 0) {
      completeAddress = completeAddress + '${location["HouseNo"]}, ';
    }
    if (location["Street"].length > 0) {
      completeAddress = completeAddress + '${location["Street"]}, ';
    }
    if (location["Subdivision"].length > 0) {
      completeAddress = completeAddress + '${location["Subdivision"]}, ';
    }
    if (location["BrgyName"] != null) {
      completeAddress = completeAddress + '${location["BrgyName"]}, ';
    }
    if (location["CityName"] != null) {
      completeAddress = completeAddress + '${location["CityName"]}, ';
    }
    if (location["ProvinceName"] != null) {
      completeAddress = completeAddress + '${location["ProvinceName"]} ';
    }

    return completeAddress;
  }

  String get visibilityAddress {
    String visibilityAddress = '';

    if (location == null) {
      return 'No complete Address';
    }

    if ((location["RoomNo"].length > 0 &&
            location["ShowFloorNumber"] == true) ||
        location["ShowFloorNumber"] == null) {
      visibilityAddress = visibilityAddress + '${location["RoomNo"]}, ';
    }

    if ((location["BuildingName"].length > 0 &&
            location["ShowBuildingName"] == true) ||
        location["ShowBuildingName"] == null) {
      visibilityAddress = visibilityAddress + '${location["BuildingName"]}, ';
    }
    if ((location["HouseNo"].length > 0 &&
            location["ShowHouseNumber"] == true) ||
        location["ShowHouseNumber"] == null) {
      visibilityAddress = visibilityAddress + '${location["HouseNo"]}, ';
    }
    if ((location["Street"].length > 0 && location["ShowStreet"] == true) ||
        location["ShowStreet"] == null) {
      visibilityAddress = visibilityAddress + '${location["Street"]}, ';
    }
    if ((location["Subdivision"].length > 0 &&
            location["ShowSubdivision"] == true) ||
        location["ShowSubdivision"] == null) {
      visibilityAddress = visibilityAddress + '${location["Subdivision"]}, ';
    }
    if ((location["BrgyName"] != null && location["ShowBarangay"] == true) ||
        location["ShowBarangay"] == null) {
      visibilityAddress = visibilityAddress + '${location["BrgyName"]}, ';
    }
    if ((location["CityName"] != null && location["ShowCity"] == true) ||
        location["ShowCity"] == null) {
      visibilityAddress = visibilityAddress + '${location["CityName"]}, ';
    }
    if ((location["ProvinceName"] != null &&
            location["ShowProvince"] == true) ||
        location["ShowProvince"] == null) {
      visibilityAddress = visibilityAddress + '${location["ProvinceName"]} ';
    }

    return visibilityAddress;
  }

  Property(
      {this.coverPhoto,
      this.photos,
      this.amenities,
      this.keywords,
      this.propertyType,
      this.propertyFor,
      this.price,
      this.timePeriod,
      this.totalBathRoom,
      this.totalBedRoom,
      this.totalParkingSpace,
      this.totalArea,
      this.frontageArea,
      this.floorArea,
      this.isYourProperty,
      this.ownership,
      this.district,
      this.street,
      this.landmark,
      this.city,
      this.description,
      this.createdBy,
      this.createdAt,
      this.updatedAt,
      this.viewType,
      this.id,
      this.coordinates,
      this.pricing,
      this.location,
      this.title});

  Property.fromJson(Map<String, dynamic> json)
      : coverPhoto = json['cover_photo'],
        photos = json['photos'],
        amenities = json['amenities'],
        keywords = json['keywords'],
        propertyType = json['property_type'],
        propertyFor = json['property_for'],
        price = json['price'] as double?,
        timePeriod = json['time_period'],
        totalBedRoom = json['number_of_bedrooms'],
        totalBathRoom = json['number_of_bathrooms'],
        totalParkingSpace = json['number_of_parking_space'],
        totalArea = json['total_area'] as double?,
        frontageArea = json['frontage_area'] as double?,
        floorArea = json['floor_area'] as double?,
        isYourProperty = json['is_your_property'],
        ownership = json['ownership'],
        district = json['district'],
        street = json['street'],
        landmark = json['landmark'],
        city = json['city'],
        description = json['description'],
        createdBy = json['createdBy'],
        createdAt = json['createdAt'].toString(),
        updatedAt = json['updatedAt'].toString(),
        viewType = json['view_type'],
        id = json['_id'],
        coordinates = json['coordinates'],
        pricing = json['pricing'],
        location = json['location'],
        title = json['title'];

  Map<String, dynamic> toJson() => {
        'cover_photo': coverPhoto ?? "",
        'photos': photos ?? "",
        'amenities': amenities ?? "",
        'keywords': keywords ?? "",
        'pricing': pricing ?? "",
        'price': price ?? "",
        'time_period': timePeriod ?? "",
        'number_of_bedrooms': totalBedRoom ?? "",
        'number_of_bathrooms': totalBathRoom ?? "",
        'number_of_parking_space': totalParkingSpace ?? "",
        'total_area': totalArea ?? "",
        'floor_area': floorArea ?? "",
        'frontage_area': frontageArea ?? "",
        'is_your_property': isYourProperty ?? "",
        "ownership": ownership ?? "",
        'district': district ?? "",
        'street': street ?? "",
        'landmark': landmark ?? "",
        'city': city ?? "",
        'description': description ?? "",
        'create_by': createdBy,
        'view_type': viewType,
        'id': id,
        'coordinates': coordinates,
        'location': location,
        'title': title
      };
}
