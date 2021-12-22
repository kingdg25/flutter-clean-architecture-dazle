class Property {
  final String photoURL;
  final List amenities;
  final List keywords;
  final String amount;
  final String timePeriod;
  final String totalBedRoom;
  final String totalBathRoom;
  final String totalParkingSpace;
  final String totalArea;
  /// furnished or unfurnished
  final String isYourProperty;
  final String district;
  final String city;
  final String description;

  String get keywordsToString{
    return keywords.join(" • ");
  }


  Property({
    this.photoURL,
    this.amenities,
    this.keywords,
    this.amount,
    this.timePeriod,
    this.totalBathRoom,
    this.totalBedRoom,
    this.totalParkingSpace,
    this.totalArea,
    this.isYourProperty,
    this.district,
    this.city,
    this.description
  });

  Property.fromJson(Map<String, dynamic> json)
    : photoURL = json['photo_url'],
      amenities = json['amenities'],
      keywords = json['keywords'],
      amount = json['amount'],
      timePeriod = json['time_period'],
      totalBedRoom = json['total_bed_room'],
      totalBathRoom = json['total_bath_room'],
      totalParkingSpace = json['total_parking_space'],
      totalArea = json['total_area'],
      isYourProperty = json['is_your_property'],
      district = json['district'],
      city = json['city'],
      description = json['description'];

  Map<String, dynamic> toJson() => {
    'photo_url': photoURL,
    'amenities': amenities,
    'keywords': keywords,
    'amount': amount,
    'time_period': timePeriod,
    'total_bed_room': totalBedRoom,
    'total_bath_room': totalBathRoom,
    'total_parking_space': totalParkingSpace,
    'total_area': totalArea,
    'is_your_property': isYourProperty,
    'district': district,
    'city': city,
    'description': description
  };
}