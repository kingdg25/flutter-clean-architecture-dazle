class Property {
  final String photoURL;
  final List keywords;
  final String amount;
  final String totalBedRoom;
  final String totalBathRoom;
  final String totalParkingSpace;
  final String totalArea;
  final String district;
  final String city;


  Property(
    this.photoURL,
    this.keywords,
    this.amount,
    this.totalBathRoom,
    this.totalBedRoom,
    this.totalParkingSpace,
    this.totalArea,
    this.district,
    this.city
  );

  Property.fromJson(Map<String, dynamic> json)
    : photoURL = json['photo_url'],
      keywords = json['keywords'],
      amount = json['amount'],
      totalBedRoom = json['total_bed_room'],
      totalBathRoom = json['total_bath_room'],
      totalParkingSpace = json['total_parking_space'],
      totalArea = json['total_area'],
      district = json['district'],
      city = json['city'];

  Map<String, dynamic> toJson() => {
    'photo_url': photoURL,
    'keywords': keywords,
    'amount': amount,
    'total_bed_room': totalBedRoom,
    'total_bath_room': totalBathRoom,
    'total_parking_space': totalParkingSpace,
    'total_area': totalArea,
    'district': district,
    'city': city
  };
}