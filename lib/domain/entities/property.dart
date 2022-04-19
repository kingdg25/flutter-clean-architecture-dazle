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
  final String? totalBedRoom;
  final String? totalBathRoom;
  final String? totalParkingSpace;
  final double? totalArea;

  /// furnished or unfurnished
  final String? isYourProperty;
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
  var coordinates;

  NumberFormat numberFormat = NumberFormat('##,###.00');

  String? get keywordsToString {
    return keywords?.join(" • ");
  }

  String get formatPrice => numberFormat.format(price);
  String get formatArea => numberFormat.format(totalArea);
  String get priceVar => "$price";

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
      this.isYourProperty,
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
      this.coordinates});

  Property.fromJson(Map<String, dynamic> json)
      : coverPhoto = json['cover_photo'],
        photos = json['photos'],
        amenities = json['amenities'],
        keywords = json['keywords'],
        propertyType = json['property_type'],
        propertyFor = json['property_for'],
        price = json['price'] as double?,
        // price = double.parse(json['price']),
        timePeriod = json['time_period'],
        totalBedRoom = json['number_of_bedrooms'],
        totalBathRoom = json['number_of_bathrooms'],
        totalParkingSpace = json['number_of_parking_space'],
        totalArea = json['total_area'] as double?,
        // totalArea = double.parse(json['price']),
        isYourProperty = json['is_your_property'],
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
        coordinates = json['coordinates'];

  Map<String, dynamic> toJson() => {
        'cover_photo': coverPhoto ?? "",
        'photos': photos ?? "",
        'amenities': amenities ?? "",
        'keywords': keywords ?? "",
        'price': price ?? "",
        'time_period': timePeriod ?? "",
        'number_of_bedrooms': totalBedRoom ?? "",
        'number_of_bathrooms': totalBathRoom ?? "",
        'number_of_parking_space': totalParkingSpace ?? "",
        'total_area': totalArea ?? "",
        'is_your_property': isYourProperty ?? "",
        'district': district ?? "",
        'street': street ?? "",
        'landmark': landmark ?? "",
        'city': city ?? "",
        'description': description ?? "",
        'create_by': createdBy,
        'view_type': viewType,
        'id': id,
        'coordinates': coordinates
      };
}
